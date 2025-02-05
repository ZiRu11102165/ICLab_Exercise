import numpy as np
import pandas as pd
import os

#####   Pattern 格式    ######
# 第一區 64個輸入 = 8x8 Maze建立
# 第二區 x的值 * 15 (3bit表示)
# 第三區 y的值 * 15 (3bit表示)
# 最終顯示 ： Maze(64)x(15*3)y(15*3)
#####   Pattern 格式    ######

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
        # print(f"第 {i} 個 Maze")
        # 使用 p=[機率0, 機率1] 來控制 0 和 1 的數量
        maze = np.random.choice(Input_List, 64, replace=True, p=[1 - 0.8, 0.8])
        maze = maze.reshape(8, 8)
        maze[0][0] = 1  # 確保起點是 1
        maze[7][7] = 1  # 確保起點是 1
        # print("maze[2][4] = ", maze[2][7])
        maze_list.append(maze)
        # print(maze)
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
        if (Down == 1):
            next_pos_x = pos_x + 1
            next_pos_y = pos_y 
            end = 0
        elif ((Down == 0) and (Right == 1)):
            next_pos_x = pos_x
            next_pos_y = pos_y + 1
            end = 0            
        else:
            next_pos_x = pos_x
            next_pos_y = pos_y
            end = 1
        
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
    count = 0
    record_count_list = []
    while (keep_flag == 1):
        # print("現在勞鼠位置 : x = ", now_pos_x, ", y = ", now_pos_y)
        record_x_list.append(now_pos_x)
        record_y_list.append(now_pos_y)
        
        Isfold, next_pos_x, next_pos_y, end, back_used = move(maze, now_pos_x, now_pos_y, back_flag)
        if (back_used == 1):
            back_flag = 0
        if (Isfold == 1 and back_used ==0 ):
            # print("Fold位置 : x = ", record_fold_x_list, ", y = ", record_fold_y_list)
            record_fold_x_list.append(now_pos_x)
            record_fold_y_list.append(now_pos_y)
            record_count_list.append(count)
        else:
            pass
        # print('count:',count)
        if((now_pos_x == 7) and (now_pos_y == 7)):
            keep_flag = 0
            print(f"到終點了")
            return record_x_list, record_y_list, 0
        elif (end == 1 and (not record_fold_x_list)):
            keep_flag = 0
            print(f"沒路走")
            return now_pos_x, now_pos_y, 1
        else:
            if (end == 0):
                keep_flag == 1
                now_pos_x = next_pos_x
                now_pos_y = next_pos_y
                count += 1
            elif ((not record_fold_x_list) == False):
                back_flag = 1
                keep_flag == 1
                now_pos_x = record_fold_x_list[-1]
                now_pos_y = record_fold_y_list[-1]
                record_fold_x_list = record_fold_x_list [0:-1]
                record_fold_y_list = record_fold_y_list [0:-1]

                count = record_count_list[-1]
                # record_count_list.pop()
                record_count_list = record_count_list [0:-1]
                record_x_list = record_x_list[0:count]
                record_y_list = record_y_list[0:count]
                # del(record_fold_x_list[-1])
                # del(record_fold_y_list[-1])
            else:
                keep_flag == 0
def DtoB(result):
    # print(result)
    DtoB_list = []
    for i in range(len(result)):
        record_in_DtoB = int(result[i])
        record_in = bin(record_in_DtoB)
        record_in_nonb = record_in.split('b')[1]
        record_in_save = record_in_nonb.zfill(3)
        DtoB_list.append(record_in_save)
    return DtoB_list
def comb(*input):
    #str = in[0]
    record = ''
    for i in range(len(input)):
        #record += '_'
        # record += str(input[i])
        record += f'{input[i]}'
    return str(record)
def main():
    n_sample = 150
    record_count = 0
    maze_list = create_maze(n_sample)
    pattern_all = []

    # print(maze_list[0][7][7])
    for i in range(n_sample):
        record_x_list, record_y_list, no_end = Rat_Action(maze_list[i])
        if (no_end == 0):
            record_count += 1
            print(f"第 {i} 個Maze的可用")
            # print(len(record_x_list), len(record_y_list))
            maze_np = np.array(maze_list[i]).flatten()
            
            comb_pattern = comb(maze_np,  DtoB(record_x_list),  DtoB(record_y_list))
            comb_pattern = comb_pattern.replace('[', '')
            comb_pattern = comb_pattern.replace(']', '')
            comb_pattern = comb_pattern.replace(' ', '')
            comb_pattern = comb_pattern.replace(',', '')
            comb_pattern = comb_pattern.replace('\'', '')
            comb_pattern = comb_pattern.replace('\n', '')
            print("每筆資料的len = ", len(comb_pattern))
            pattern_all.append(comb_pattern)
            if (record_count == 100):
                break
    pattern_all = '\n'.join(pattern_all)

    SaveFile(pattern_all)
        
    return
if __name__ == '__main__':
    main()