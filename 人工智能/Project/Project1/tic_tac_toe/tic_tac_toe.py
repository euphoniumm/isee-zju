#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2019/3/2 21:06
# @Author  : yaoqi
# @Email   : yaoqi_isee@zju.edu.cn
# @File    : tic_tac_toe.py

# +++++++++++++++++++++++++++++++++++++++++++++ README ++++++++++++++++++++++++++++++++++++++++
# You will write a tic tac toc player and play game with this computer player.
# You will use MiniMaxSearch with depth limited strategy. For simplicity, Alpha-Beta Pruning
# is not considered.
# Let's make some assumptions.
# 1. The computer player(1) use circle(1) and you(-1) use cross(-1).
# 2. The computer player is MAX user and you are MIN user.
# 3. The miniMaxSearch depth is 3, so that the computer predict one step further. It first
# predicts what you will do if it makes a move and choose a move that maximize its gain.
# 4. You play first
# +++++++++++++++++++++++++++++++++++++++++++++ README ++++++++++++++++++++++++++++++++++++++++

import numpy as np


def MinimaxSearch(current_state):
    """
    Search the next step by Minimax Search with depth limited strategy
    The search depth is limited to 3, computer player(1) uses circle(1) and you(-1) use cross(-1)
    :param current_state: current state of the game, it's a 3x3 array representing the chess board, array element lies
    in {1, -1, 0}, standing for circle, cross, empty place.
    :return: row and column index that computer player will draw a circle on. Note 0<=row<=2, 0<=col<=2
    """
    # -------------------------------- Your code starts here ----------------------------- #
    # isinstance: 判断current_state是否为ndarray类型；assert后面的内容为False，则程序会报错，否则继续运行，这是一个很好的编程习惯
    assert isinstance(current_state, np.ndarray)
    assert current_state.shape == (3, 3)

    # get available actions
    game_state = current_state.copy()
    actions = get_available_actions(game_state)

    # computer player: traverse all the possible actions and maximize the utility function
    values = []
    depth = 3
    for action in actions:
        values.append(min_value(action_result(game_state.copy(), action, 1), depth))
    max_ind = int(np.argmax(values))
    row, col = actions[max_ind][0], actions[max_ind][1]

    return row, col


def get_available_actions(current_state):
    """
    get all the available actions given current state
    :param current_state:current state of the game, it's a 3x3 array
    :return: available actions. list of tuple [(r0, c0), (r1, c1), (r2, c2)]
    """
    assert isinstance(current_state, np.ndarray), 'current_state should be numpy ndarray'
    assert current_state.shape == (3, 3), 'current_state: expect 3x3 array, get {}'.format(current_state.shape)

    actions = []
    for i in range(current_state.shape[0]):
        for j in range(current_state.shape[1]):
            if current_state[i, j] == 0:
                actions.append((i, j))

    return actions


def action_result(current_state, action, player):
    """
    update the game state given the input action and player
    :param current_state: current state of the game, it's a 3x3 array
    :param action: current action, tuple type
    """
    assert isinstance(current_state, np.ndarray), 'current_state should be numpy ndarray'
    assert current_state.shape == (3, 3), 'current_state: expect 3x3 array, get {}'.format(current_state.shape)
    assert player in [1, -1], 'player should be either 1(computer) or -1(you)'

    tmep_state = current_state.copy()
    tmep_state[action] = player
    return tmep_state


def min_value(current_state, depth):
    """
    recursively call min_value and max_value, min_value is for human player(-1)
    """
    value = 100
    temp_state = current_state.copy()
    actions = get_available_actions(temp_state)
    if utility(temp_state) == 15 or utility(temp_state) == -15:
        return utility(temp_state)
    if depth == 0:  # 搜索结束
        return utility(temp_state)
    if not actions:
        return utility(temp_state)
    else:
        for action in actions:
            result_state = action_result(temp_state, action, player=-1)
            value = min(value, max_value(result_state, depth-1))
    return value


def max_value(current_state, depth):
    """
    recursively call min_value and max_value, max_value is for computer(1)
    """
    value = -100
    temp_state = current_state.copy()
    actions = get_available_actions(temp_state)
    if utility(temp_state) == 15 or utility(temp_state) == -15:
        return utility(temp_state)
    if depth == 0:
        return utility(temp_state)
    if not actions:
        return utility(temp_state)
    else:
        for action in actions:
            result_state = action_result(temp_state, action, player=1)
            value = max(value, min_value(result_state, depth - 1))
    return value


def utility(current_state):
    """
    return utility function given current state and flag
    """
    current_state_utility = 0
    o_list = [0, 0, 0]  # o1，o2
    x_list = [0, 0, 0]  # x1，x2
    flag = 0
    o_counts_row = np.zeros((1, 3))  # 分别为一二三行的o数
    x_counts_row = np.zeros((1, 3))  # 分别为一二三行的x数
    o_counts_col = np.zeros((1, 3))  # 分别为一二三列的o数
    x_counts_col = np.zeros((1, 3))  # 分别为一二三列的x数
    o_counts_diag = np.zeros((1, 3))  # 分别为两对角线上的o数，最后一个数为0，方便遍历
    x_counts_diag = np.zeros((1, 3))  # 分别为两对角线上的x数，最后一个数为0，方便遍历
    # 行
    for i in range(current_state.shape[0]):
        for j in range(current_state.shape[1]):
            if current_state[i, j] == 1:
                o_counts_row[0, i] = o_counts_row[0, i] + 1
            elif current_state[i, j] == -1:
                x_counts_row[0, i] = x_counts_row[0, i] + 1
    # 列
    for i in range(current_state.shape[1]):
        for j in range(current_state.shape[0]):
            if current_state[j, i] == 1:
                o_counts_col[0, i] = o_counts_col[0, i] + 1
            elif current_state[j, i] == -1:
                x_counts_col[0, i] = x_counts_col[0, i] + 1
    # 对角
    for i in range(3):
        # 正对角
        if current_state[i, i] == 1:
            o_counts_diag[0, 0] = o_counts_diag[0, 0] + 1
        elif current_state[i, i] == -1:
            x_counts_diag[0, 0] = x_counts_diag[0, 0] + 1
        # 副对角
        if current_state[i, 2 - i] == 1:
            o_counts_diag[0, 1] = o_counts_diag[0, 1] + 1
        elif current_state[i, 2 - i] == -1:
            x_counts_diag[0, 1] = x_counts_diag[0, 1] + 1
    # 计算 o1，o2，o3和utility
    for i in range(3):
        # 先看是否有o3，x3
        if (o_counts_row[0, i] == 3) or (o_counts_col[0, i] == 3) or (o_counts_diag[0, i] == 3):
            current_state_utility = 15
            flag = 1
            break
        elif (x_counts_row[0, i] == 3) or (x_counts_col[0, i] == 3) or (x_counts_diag[0, i] == 3):
            current_state_utility = -15
            flag = 1
            break
        # o2
        if o_counts_row[0, i] == 2:
            if x_counts_row[0, i] == 0:
                o_list[1] = o_list[1] + 1
        elif o_counts_col[0, i] == 2:
            if x_counts_col[0, i] == 0:
                o_list[1] = o_list[1] + 1
        elif o_counts_diag[0, i] == 2:
            if x_counts_diag[0, i] == 0:
                o_list[1] = o_list[1] + 1
        # x2
        if x_counts_row[0, i] == 2:
            if o_counts_row[0, i] == 0:
                x_list[1] = x_list[1] + 1
        elif x_counts_col[0, i] == 2:
            if o_counts_col[0, i] == 0:
                x_list[1] = x_list[1] + 1
        elif x_counts_diag[0, i] == 2:
            if o_counts_diag[0, i] == 0:
                x_list[1] = x_list[1] + 1
        # o1
        if o_counts_row[0, i] == 1:
            if x_counts_row[0, i] == 0:
                o_list[0] = o_list[0] + 1
        elif o_counts_col[0, i] == 1:
            if x_counts_col[0, i] == 0:
                o_list[0] = o_list[0] + 1
        elif o_counts_diag[0, i] == 1:
            if x_counts_diag[0, i] == 0:
                o_list[0] = o_list[0] + 1
        # x1
        if x_counts_row[0, i] == 1:
            if o_counts_row[0, i] == 0:
                x_list[0] = x_list[0] + 1
        elif x_counts_col[0, i] == 1:
            if o_counts_col[0, i] == 0:
                x_list[0] = x_list[0] + 1
        elif x_counts_diag[0, i] == 1:
            if o_counts_diag[0, i] == 0:
                x_list[0] = x_list[0] + 1
    if flag == 0:
        current_state_utility = 3 * o_list[1] + o_list[0] - 3 * x_list[1] - x_list[0]
    return current_state_utility

# Do not modify the following code
class GameJudge(object):
    def __init__(self):
        self.game_state = np.zeros(shape=(3, 3), dtype=int)

    def make_one_move(self, row, col, player):
        """
        make one move forward
        :param row: row index of the circle(cross)
        :param col: column index of the circle(cross)
        :param player: player = 1 for computer / player = -1 for human
        :return:
        """
        # 1 stands for circle, -1 stands for cross, 0 stands for empty
        assert 0 <= row <= 2, "row index of the move should lie in [0, 2]"
        assert 0 <= col <= 2, "column index of the move should lie in [0, 2]"
        assert player in [-1, 1], "player should be noted as -1(human) or 1(computer)"
        self.game_state[row, col] = player

    def check_game_status(self):
        """
        return game status
        :return: 1 for computer wins, -1 for human wins, 0 for draw, 2 in the play
        """

        # somebody wins
        sum_rows = np.sum(self.game_state, axis=1).tolist()
        if 3 in sum_rows:
            return 1
        if -3 in sum_rows:
            return -1

        sum_cols = np.sum(self.game_state, axis=0).tolist()
        if 3 in sum_cols:
            return 1
        if -3 in sum_cols:
            return -1

        sum_diag = self.game_state[0][0] + self.game_state[1][1] + self.game_state[2][2]
        if sum_diag == 3:
            return 1
        if sum_diag == -3:
            return -1

        sum_rdiag = self.game_state[0][2] + self.game_state[1][1] + self.game_state[2][0]
        if sum_rdiag == 3:
            return 1
        if sum_rdiag == -3:
            return -1

        # draw
        if len(np.where(self.game_state == 0)[0]) == 0:
            return 0

        # in the play
        return 2

    def human_input(self):
        """
        take the human's move in
        :return: row and column index of human input
        """
        print("Input the row and column index of your move")
        print("1, 0 means draw a cross on the row 1, col 0")
        ind, succ = None, False
        while not succ:
            ind = list(map(int, input().strip().split(',')))
            if ind[0] < 0 or ind[0] > 2 or ind[1] < 0 or ind[1] > 2:
                succ = False
                print("Invalid input, the two numbers should lie in [0, 2]")
            elif self.game_state[ind[0], ind[1]] != 0:
                succ = False
                print(" You can not put cross on places already occupied")
            else:
                succ = True
        return ind[0], ind[1]

    def print_status(self, player, status):
        """
        print the game status
        :param player: player of the last move
        :param status: game status
        :return:
        """
        print("-----------------------------------------------------")
        for row in range(3):
            for col in range(3):
                if self.game_state[row, col] == 1:
                    print("[O]", end="")
                elif self.game_state[row, col] == -1:
                    print("[X]", end="")
                else:
                    print("[ ]", end="")
            print("")

        if player == 1:
            print("Last move was conducted by computer")
        elif player == -1:
            print("Last move was conducted by you")

        if status == 1:
            print("Computer wins")
        elif status == -1:
            print("You win")
        elif status == 2:
            print("Game going on")
        elif status == 0:
            print("Draw")

    def get_game_state(self):
        return self.game_state
