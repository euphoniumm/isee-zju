import random
from puzzle_state import PuzzleState, astar_search_for_puzzle_problem, run_moves, generate_moves, print_moves, convert_moves, runs
import numpy as np
import time

def main():

    # Create a initial state randomly
    square_size = 4

    init_state = PuzzleState(square_size=square_size)
    # dst = [1, 2, 3,
    #        8,-1, 6,
    #        7, 4, 5]
    dst = [1,  4, 5,  14,
           2,  6, 13, 15,
           11, 7, -1, 10,
           8,  9, 12, 3  ]
    # dst = [1, 4, 5, 14, 19, 25, 36,
    #        2, 6, 13, 15, 18, 26, 36,
    #        11, 7, -1, 10, 17, 27, 38,
    #        8, 9, 12, 3, 16, 28, 39,
    #        20, 21, 22, 23, 24, 29, 40,
    #        30, 31, 32, 33, 34, 35, 41,
    #        42, 43, 44, 45, 46, 47, 48]
    init_state.state = np.asarray(dst).reshape(square_size, square_size)  # 将list转化为array

    seeded = random.random()  # 控制每次移动的情况，seeded设为常数，移动情况相同，goal state相同
    move_list = generate_moves(move_num=80, seed=seeded)
    init_state.state = runs(init_state, move_list).state

    # Set a determined destination state
    dst_state = PuzzleState(square_size=square_size)
    dst_state.state = np.asarray(dst).reshape(square_size, square_size)

    # Find the path from 'init_state' to 'dst_state'
    time_start = time.time()
    type = 'hamming'  # 选择启发式函数
    move_list = astar_search_for_puzzle_problem(init_state, dst_state, type=type)
    time_end = time.time()

    move_list = convert_moves(move_list)

    # Perform your path
    if run_moves(init_state, dst_state, move_list):
        print_moves(init_state, move_list)
        print("Our dst state: ")
        dst_state.display()
        print("Get to dst state. Success !!!")
    else:
        print_moves(init_state, move_list)
        print("Our dst state: ")
        dst_state.display()
        print("Can not get to dst state. Failed !!!")

    print('The search time is %fs' % (time_end - time_start))

if __name__ == '__main__':
    main()
