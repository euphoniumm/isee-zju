import random

import numpy as np
from enum import Enum
import copy


# Enum of operation in EightPuzzle problem
class Move(Enum):
    """
    The class of move operation
    NOTICE: The direction denotes the 'blank' space move
    """
    Up = 0
    Down = 1
    Left = 2
    Right = 3


# EightPuzzle state
class PuzzleState(object):
    """
    Class for state in EightPuzzle-Problem
    Attr:
        square_size: Chessboard size, e.g: In 8-puzzle problem, square_size = 3
        state: 'square_size' x 'square_size square', '-1' indicates the 'blank' block  (For 8-puzzle, state is a 3 x 3 array)
        g: The cost from initial state to current state
        h: The value of heuristic function
        pre_move:  The previous operation to get to current state
        pre_state: Parent state of this state
    """
    def __init__(self, square_size):
        self.square_size = square_size
        self.state = None
        self.g = 0
        self.h = 0
        self.pre_move = None
        self.pre_state = None

        self.generate_state()

    def __eq__(self, other):
        return (self.state == other.state).all()

    def blank_pos(self):
        """
        Find the 'blank' position of current state
        :return:
            row: 'blank' row index, '-1' indicates the current state may be invalid
            col: 'blank' col index, '-1' indicates the current state may be invalid
        """
        index = np.argwhere(self.state == -1)
        row = -1
        col = -1
        if index.shape[0] == 1:  # find blank
            row = index[0][0]
            col = index[0][1]
        return row, col

    def num_pos(self, num):
        """
        Find the 'num' position of current state
        :return:
            row: 'num' row index, '-1' indicates the current state may be invalid
            col: 'num' col index, '-1' indicates the current state may be invalid
            return the num in the state's position
        """
        index = np.argwhere(self.state == num)
        row = -1
        col = -1
        if index.shape[0] == 1:  # find number
            row = index[0][0]
            col = index[0][1]
        return row, col

    def is_valid(self):
        """
        Check current state is valid or not (A valid state should have only one 'blank')
        :return:
            flag: boolean, True - valid state, False - invalid state
        """
        row, col = self.blank_pos()
        if row == -1 or col == -1:
            return False
        else:
            return True

    def clone(self):
        """
        Return the state's deepcopy
        :return:
        """
        return copy.deepcopy(self)

    def generate_state(self, random=False, seed=None):
        """
        Generate a new state
        :param random: True - generate state randomly, False - generate a normal state
        :param seed: Choose the seed of random, only used when random = True
        :return:
        """
        # arange左闭右开，0-square^2-1，将零替换为-1代表空格
        self.state = np.arange(0, self.square_size ** 2).reshape(self.square_size, -1)
        self.state[self.state == 0] = -1  # Set blank

        if random:
            np.random.seed(seed)  # seed值相同，两次shuffle结果相同（都是随机的）
            np.random.shuffle(self.state)

    def display(self):
        """
        Print state
        :return:
        """
        print("----------------------")
        for i in range(self.state.shape[0]):
            # print("{}\t{}\t{}\t".format(self.state[i][0], self.state[i][1], self.state[i][2]))
            # print(self.state[i, :])
            for j in range(self.state.shape[1]):
                if j == self.state.shape[1] - 1:
                    print("{}\t".format(self.state[i][j]))
                else:
                    print("{}\t".format(self.state[i][j]), end='')
        print("----------------------\n")


def check_move(curr_state, move):
    """
    Check the operation 'move' can be performed on current state 'curr_state'
    :param curr_state: Current puzzle state
    :param move: Operation to be performed
    :return:
        valid_op: boolean, True - move is valid; False - move is invalid
        src_row: int, current blank row index
        src_col: int, current blank col index
        dst_row: int, future blank row index after move
        dst_col: int, future blank col index after move
    """
    # assert isinstance(move, Move)  # Check operation type
    assert curr_state.is_valid()  # if curr_state.is_valid() return false then error, else continue

    if not isinstance(move, Move):  # judge move whether in Move class, return bool
        move = Move(move)

    src_row, src_col = curr_state.blank_pos()
    dst_row, dst_col = src_row, src_col
    valid_op = False

    if move == Move.Up:  # Number moves up, blank moves down
        dst_row -= 1
    elif move == Move.Down:
        dst_row += 1
    elif move == Move.Left:
        dst_col -= 1
    elif move == Move.Right:
        dst_col += 1
    else:  # Invalid operation
        dst_row = -1
        dst_col = -1

    if dst_row < 0 or dst_row > curr_state.state.shape[0] - 1 or dst_col < 0 or dst_col > curr_state.state.shape[1] - 1:
        valid_op = False
    else:
        valid_op = True

    return valid_op, src_row, src_col, dst_row, dst_col


def once_move(curr_state, move):
    """
    Perform once move to current state
    :param curr_state:
    :param move:
    :return:
        valid_op: boolean, flag of this move is valid or not. True - valid move, False - invalid move
        next_state: EightPuzzleState, state after this move
    """
    valid_op, src_row, src_col, dst_row, dst_col = check_move(curr_state, move)

    next_state = curr_state.clone()

    if valid_op:
        it = next_state.state[dst_row][dst_col]
        next_state.state[dst_row][dst_col] = -1
        next_state.state[src_row][src_col] = it
        next_state.pre_state = curr_state
        next_state.pre_move = move
        return True, next_state
    else:
        return False, next_state


def check_state(src_state, dst_state):
    """
    Check current state is same as destination state
    :param src_state:
    :param dst_state:
    :return:
    """
    return (src_state.state == dst_state.state).all()


def run_moves(curr_state, dst_state, moves):
    """
    Perform list of move to current state, and check the final state is same as destination state or not
    Ideally, after we perform moves to current state, we will get a state same as the 'dst_state'
    :param curr_state: EightPuzzleState, current state
    :param dst_state: EightPuzzleState, destination state
    :param moves: List of Move
    :return:
        flag of moves: True - We can get 'dst_state' from 'curr_state' by 'moves'
    """
    pre_state = curr_state.clone()
    next_state = None

    for move in moves:
        valid_move, next_state = once_move(pre_state, move)

        if not valid_move:
            return False

        pre_state = next_state.clone()

    if check_state(next_state, dst_state):
        return True
    else:
        return False


def runs(curr_state, moves):
    """
    Perform list of move to current state, get the result state
    NOTICE: The invalid move operation would be ignored
    :param curr_state:
    :param moves:
    :return:
    """
    pre_state = curr_state.clone()
    next_state = None

    for move in moves:
        valid_move, next_state = once_move(pre_state, move)
        pre_state = next_state.clone()
    return next_state


def print_moves(init_state, moves):
    """
    While performing the list of move to current state, this function will also print how each move is performed
    :param init_state: The initial state
    :param moves: List of move
    :return:
    """
    print("Initial state")
    init_state.display()

    pre_state = init_state.clone()
    next_state = None

    for idx, move in enumerate(moves):
        if move == Move.Up:  # Number moves up, blank moves down
            print("{} th move. Goes up.".format(idx))
        elif move == Move.Down:
            print("{} th move. Goes down.".format(idx))
        elif move == Move.Left:
            print("{} th move. Goes left.".format(idx))
        elif move == Move.Right:
            print("{} th move. Goes right.".format(idx))
        else:  # Invalid operation
            print("{} th move. Invalid move: {}".format(idx, move))

        valid_move, next_state = once_move(pre_state, move)

        if not valid_move:
            print("Invalid move: {}, ignore".format(move))

        next_state.display()

        pre_state = next_state.clone()

    print("We get final state: ")
    next_state.display()


def generate_moves(move_num=30, seed=None):
    """
    Generate a list of move in a determined length randomly
    :param move_num:
    :return:
        move_list: list of move
    """
    move_dict = {}
    move_dict[0] = Move.Up
    move_dict[1] = Move.Down
    move_dict[2] = Move.Left
    move_dict[3] = Move.Right

    random.seed(seed)
    index_arr = np.random.randint(0, 4, move_num)
    index_list = list(index_arr)

    move_list = [move_dict[idx] for idx in index_list]

    return move_list


def convert_moves(moves):
    """
    Convert moves from int into Move type
    :param moves:
    :return:
    """
    if len(moves):
        if isinstance(moves[0], Move):
            return moves
        else:
            return [Move(move) for move in moves]
    else:
        return moves


"""
NOTICE:
1. init_state is a 3x3 numpy array, the "space" is indicated as -1, for example
    1 2 -1              1 2
    3 4 5   stands for  3 4 5
    6 7 8               6 7 8
2. moves contains directions that transform initial state to final state. Here
    0 stands for up
    1 stands for down
    2 stands for left
    3 stands for right
    We 
   There might be several ways to understand "moving up/down/left/right". Here we define
   that "moving up" means to move 'space' up, not move other numbers up. For example
    1 2 5                1 2 -1
    3 4 -1   move up =>  3 4 5
    6 7 8                6 7 8
   This definition is actually consistent with where your finger moves to
   when you are playing 8 puzzle game.
   
3. It's just a simple example of A-Star search. You can implement this function in your own design.  
"""

def astar_search_for_puzzle_problem(init_state, dst_state, type='euclidean'):
    """
    Use AStar-search to find the path from init_state to dst_state
    :param init_state:  Initial puzzle state
    :param dst_state:   Destination puzzle state
    :return:  All operations needed to be performed from init_state to dst_state
        moves: list of Move. e.g: move_list = [Move.Up, Move.Left, Move.Right, Move.Up]
    """

    def linearConflict(curr_state, dst_state):
        LinearConflict = 0
        for x in range(0, 3):
            counter = 0
            temp = []
            for y in range(0, 3):
                if curr_state.state[x][y] in dst_state.state[x]:
                    temp.append(curr_state.state[x][y])
                    counter += 1
            if counter == 2:
                dst_state_temp = dst_state.state[x].tolist()
                curr_state_temp = curr_state.state[x].tolist()
                G1 = dst_state_temp.index(temp[0])
                G2 = dst_state_temp.index(temp[1])
                L1 = curr_state_temp.index(temp[0])
                L2 = curr_state_temp.index(temp[1])
                if (G1 - G2 > 0 and L1 - L2 < 0) or (G1 - G2 < 0 and L1 - L2 > 0):
                    LinearConflict += 1
            if counter == 3:
                dst_state_temp = dst_state.state[x].tolist()
                curr_state_temp = curr_state.state[x].tolist()
                G1 = dst_state_temp.index(temp[0])
                G2 = dst_state_temp.index(temp[1])
                G3 = dst_state_temp.index(temp[2])
                L1 = curr_state_temp.index(temp[0])
                L2 = curr_state_temp.index(temp[1])
                L3 = curr_state_temp.index(temp[2])
                if (G1 - G2 > 0 and L1 - L2 < 0) or (G1 - G2 < 0 and L1 - L2 > 0):
                    LinearConflict += 1
                if (G1 - G3 > 0 and L1 - L3 < 0) or (G1 - G3 < 0 and L1 - L3 > 0):
                    LinearConflict += 1
                if (G3 - G2 > 0 and L3 - L2 < 0) or (G3 - G2 < 0 and L3 - L2 > 0):
                    LinearConflict += 1
        return LinearConflict

    def update_cost(curr_state, dst_state, type):
        """
            Update curr_state.h and curr_state.g by type
            hamming:  the number of tiles that are not in their final position
            euclidean: the sum of each number's euclidean distance to their correct position
            chebyshev: the sum of each number's chebyshev distance to their correct position
            manhattan: the sum of each number's manhattan distance to their correct position
            conflict: manhattan distance + linear conflicts * 2
        """
        curr_state.h = 0
        flag_conflicts = 0
        for each in np.nditer(curr_state.state):
            index = np.argwhere(curr_state.state == each)
            curr_row, curr_col = curr_state.num_pos(curr_state.state[index[0, 0], index[0, 1]])
            dst_row, dst_col = dst_state.num_pos(curr_state.state[index[0, 0], index[0, 1]])
            diff_row = abs(curr_row - dst_row)
            diff_col = abs(curr_col - dst_col)
            if type == 'hamming':
                if diff_col != 0 or diff_row != 0:
                    curr_state.h = curr_state.h + 1

            elif type == 'euclidean':
                curr_state.h = curr_state.h + (diff_col**2 + diff_row**2) ** 0.5

            elif type == 'chebyshev':
                curr_state.h = curr_state.h + max(diff_row, diff_col)

            elif type == 'manhattan':
                curr_state.h = curr_state.h + diff_row + diff_col

            elif type == 'conflicts':
                curr_state.h = curr_state.h + diff_row + diff_col
                flag_conflicts = 1

            else:
                curr_state.h = 0

        if flag_conflicts:
            LinearConflict = linearConflict(curr_state, dst_state)
            curr_state.h = curr_state.h + LinearConflict * 2

        curr_state.g = curr_state.pre_state.g + 1
        return curr_state

    def find_front_node(open_list):
        """
        return the node of min fn as index, open_list[index]
        """
        min_fn = open_list[0].h + open_list[0].g
        index = 0
        for i in range(len(open_list)):
            if open_list[i].h + open_list[i].g < min_fn:
                index = i
                min_fn = open_list[i].h + open_list[i].g
        return index, open_list[index]

    def state_in_list(state, list):
        """
        if state in list, return in_list=ture, match_state=state
        """
        in_list = False
        match_state = None
        for each in list:
            if each == state:
                in_list = True
                match_state = each.clone()
                break
        return in_list, match_state

    def get_path(curr_state):
        """
        return move_list for initiate to current
        """
        move_list = []
        state_temp = curr_state.clone()
        while state_temp.pre_move != None:
            move_list.append(state_temp.pre_move)
            state_temp = state_temp.pre_state.clone()
        move_list.reverse()
        return move_list

    def expand_state(curr_state):
        """
        return a list of curr_state's child nodes
        """
        childs = []
        for i in range(4):
            flag_next_state, next_state = once_move(curr_state, i)
            if flag_next_state:
                childs.append(next_state)
        return childs

    start_state = init_state.clone()
    end_state = dst_state.clone()
    open_list = []
    close_list = []
    move_list = []

    # Initial A-star
    open_list.append(start_state)  # 程序刚开始运行，open_list里只有start_state

    while len(open_list) > 0:
        # Get best node from open_list
        curr_idx, curr_state = find_front_node(open_list)

        # Delete best node from open_list
        open_list.pop(curr_idx)

        # Add best node in close_list
        close_list.append(curr_state)

        # Check whether found solution
        if curr_state == dst_state:
            moves = get_path(curr_state)
            return moves

        # current state not a solution, then expand node
        childs = expand_state(curr_state)

        for child_state in childs:

            # judge child state whether visited, if visited go next child, else go on
            in_list, match_state = state_in_list(child_state, close_list)
            if in_list:
                continue

            # Assign cost to child state. You can also do this in Expand operation
            child_state = update_cost(child_state, dst_state, type)  # 如果这个child没有被访问过，他的cost就需要更新

            # Find a better state in open_list
            in_list, match_state = state_in_list(child_state, open_list)
            if in_list:
                continue

            open_list.append(child_state)

