import numpy as np
import pandas as pd
import os

def SaveFile(pattern_all):
    directory = "C:\\Users\\USER\\Desktop\\verilog_Exercise\\RIM"
    GT_path = os.path.join(directory, "Pattern.dat")
    # 如果資料夾不存在，則建立
    if not os.path.exists(directory):
        os.makedirs(directory)
    # 寫入檔案
    with open(GT_path, "w") as file:
        file.write(pattern_all)
    print(f"資料已成功儲存至 {GT_path}")
    
def create_maze(n_sample):
    Input_List = [0, 1]
    maze_list = []
    for i in range(n_sample):
        print(f"第 {i} 個 Maze")
        # 使用 p=[機率0, 機率1] 來控制 0 和 1 的數量
        maze = np.random.choice(Input_List, 64, replace=True, p=[1 - 0.9, 0.9])
        maze = maze.reshape(8, 8)
        maze[0][0] = 1  # 確保起點是 1
        maze_list.append(maze)
        print(maze)
    return maze_list


def move(maze, pos_x, pos_y, back_flag):
    Down = 0
    Right = 0
    back_used = 0
    
    if (((pos_x + 1)<8) and (maze[pos_x + 1][pos_y] == 1)):
        Down = 1
    
    if (((pos_y + 1)<8) and (maze[pos_x][pos_y + 1] == 1)):
        Right = 1
    
    if (back_flag==0):
        if ((Down == 0) and (Right == 0)):
            next_pos_x = pos_x
            next_pos_y = pos_y
            end = 1
        elif ((Down == 0) and (Right == 1)):
            next_pos_x = pos_x
            next_pos_y = pos_y + 1
            end = 0
        else :
            next_pos_x = pos_x + 1
            next_pos_y = pos_y
            end = 0
        
    else:
        next_pos_x = pos_x
        next_pos_y = pos_y + 1
        end = 0
        back_used = 1
        
    if (Down and Right):
        Isfold = 1
    else:
        Isfold = 0
    return Isfold, next_pos_x, next_pos_y, end, back_used

def Rat_Action(maze):
    record_fold_x_list = []
    record_fold_y_list = []
    record_x_list = []
    record_y_list = []
    back_flag = 0
    start_pos_x = 0
    start_pos_y = 0
    now_pos_x = start_pos_x
    now_pos_y = start_pos_y
    keep_flag = 1
    while (keep_flag == 1):
        # print("現在勞鼠位置 : x = ", now_pos_x, ", y = ", now_pos_y)
        record_x_list.append(now_pos_x)
        record_y_list.append(now_pos_y)
        Isfold, next_pos_x, next_pos_y, end, back_used = move(maze, now_pos_x, now_pos_y, back_flag)
        if (back_used == 1):
            back_flag = 0
        if (Isfold == 1 and back_used ==0 ):
            record_fold_x_list.append(now_pos_x)
            record_fold_y_list.append(now_pos_y)
        else:
            pass
            
        if (end == 1 and (not record_fold_x_list)):
            keep_flag = 0
            print(f"沒路走")
            return now_pos_x, now_pos_y
        else:
            if (end == 0):
                keep_flag == 1
                now_pos_x = next_pos_x
                now_pos_y = next_pos_y
            elif ((not record_fold_x_list) == False):
                back_flag = 1
                keep_flag == 1
                now_pos_x = record_fold_x_list[-1]
                now_pos_y = record_fold_y_list[-1]
                record_fold_x_list = record_fold_x_list [0:-1]
                record_fold_y_list = record_fold_y_list [0:-1]
                # del(record_fold_x_list[-1])
                # del(record_fold_y_list[-1])
            else:
                keep_flag == 0
   

def main():
    n_sample = 10
    maze_list = create_maze(n_sample)
    # print(maze_list[0][7][7])
    for i in range(n_sample):
        print(f"第 {i} 個Maze的結果")
        end_pos_x, end_pos_y = Rat_Action(maze_list[i])
        if (end_pos_x == 7 and end_pos_y ==7):
            print("到終點")
        else:
            print(f"沒到終點 x:{end_pos_x}, y:{end_pos_y}")
    return
if __name__ == '__main__':
    main()