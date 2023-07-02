# -*- coding: utf-8 -*-
"""
Created on Wed Apr 24 15:26:54 2019

@author: lee
"""
import os
import time

from path import Path
import matplotlib.pyplot as plt
# import matplotlib.image as mpimg
import numpy as np
import cv2

from particle_filter_class import Rect, Particle
from particle_filter_class import extract_feature, transition_step, weighting_step, resample_step


def show_img_with_rect(dst_img, rect=None, frame_id=None, particles=None, save_dir=None):
    tmp_img = np.array(dst_img)
    if len(tmp_img.shape) == 2:
        tmp_img = cv2.cvtColor(tmp_img, cv2.COLOR_GRAY2BGR)
    
    if rect is not None:
        cv2.rectangle(tmp_img, (rect.ly, rect.lx), (rect.ly + rect.h, rect.lx + rect.w), (255, 0, 0), 1)

    if frame_id is not None:
        text = 'Frame: {:03d}'.format(frame_id)
        cv2.putText(tmp_img, text, (rect.ly, rect.lx), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 255), 2)
    
    if particles is not None:
        if not isinstance(particles, list):  # Single particle
            particles = [particles]
        for particle in particles:
            cv2.circle(tmp_img, (int(particle.cy), int(particle.cx)), 1, (0, 255, 0), -1)

    cv2.imshow('img', tmp_img)
    cv2.waitKey(50) 
    
    if save_dir is not None:
        cv2.imwrite(save_dir/'{:03d}.png'.format(frame_id), tmp_img)


def main():
    home_dir = Path()
    print('Current path: ', home_dir.getcwd())

    # Choose the dataset for evaluation
    # test_split = 'car'
    test_split = 'David2'
    dataset_dir = home_dir/'..'/'data'/test_split/'imgs'
    save_dir = home_dir/'..'/'data'/test_split/'results1'

    # Determine the initial bounding box location
    init_rect = Rect(0, 0, 0, 0)
    if test_split == 'car':
        init_rect = Rect(68, 47, 97, 115)
    elif test_split == 'David2':
        init_rect = Rect(140, 62, 70, 36)

    # Some variables you can change
    ref_wh = [15, 15]            # Reference size of particle
    sigmas = [4, 4, 0.03, 0.03]  # Transition sigma of each attr of a particle
    n_particles = 400            # Number of particles used in particle filter
    feature_type = 'HOG'         # Default feature type, you can try some better features(e.g: HOG)
    step = 5                     # Gap of

    # create file
    save_dir = save_dir/feature_type
    if not os.path.exists(save_dir/'step{}'.format(step)):
        file_path = save_dir + '\\' + 'step{}'.format(step)
        save_dir = save_dir/'step{}'.format(step)
        os.mkdir(file_path)
        if not os.path.exists(save_dir/'particle_num{}'.format(n_particles)):
            file_path = save_dir + '\\' + 'particle_num{}'.format(n_particles)
            save_dir = save_dir/'particle_num{}'.format(n_particles)
            os.mkdir(file_path)
    else:
        save_dir = save_dir / 'step{}'.format(step)
        if not os.path.exists(save_dir/'particle_num{}'.format(n_particles)):
            file_path = save_dir + '\\' + 'particle_num{}'.format(n_particles)
            save_dir = save_dir/'particle_num{}'.format(n_particles)
            os.mkdir(file_path)
        else:
            save_dir = save_dir / 'particle_num{}'.format(n_particles)
    print(save_dir)
    
    # Read image sequences
    img_list = dataset_dir.files()
    n_imgs = len(img_list)
    if n_imgs < 10:
        print("Too short img sequences length ({}) for tracking ! ".format(n_imgs))
        return

    start_time = time.time()

    # Initial particles
    init_img = cv2.imread(img_list[0], -1)
    init_particle = init_rect.to_particle(ref_wh, sigmas=sigmas)
    particles = [init_particle.clone() for i in range(n_particles)]  # Initialize particles
    
    # Initial matching template
    init_features = extract_feature(init_img, init_rect, ref_wh, feature_type)
    template = init_features  # Use feature of the latest frame as the matching template

    show_img_with_rect(init_img, init_rect, 0, particles, save_dir=save_dir)

    for idx in range(1, n_imgs, step):
        curr_img = cv2.imread(img_list[idx], -1)

        # Transition particles by Gaussian Distribution
        particles = transition_step(particles, sigmas)

        # Compute each particle's weight by its similarity of template
        weights = weighting_step(curr_img, particles, ref_wh, template, feature_type)
        
        # Decision of best bounding box location by weights
        max_idx = np.argmax(weights)
        curr_particle = particles[max_idx]
        template = extract_feature(curr_img, curr_particle.to_rect(ref_wh), ref_wh, feature_type)
        
        show_img_with_rect(curr_img, curr_particle.to_rect(ref_wh), idx, particles, save_dir=save_dir)

        # Resample the particles by their weights
        particles = resample_step(particles, weights, rsp_sigmas=[2, 2, 0.015, 0.015])
    cv2.destroyAllWindows()
    cost_time = time.time() - start_time
    print('Time cost: {:.3f}'.format(cost_time))


if __name__ == '__main__':
    main()
