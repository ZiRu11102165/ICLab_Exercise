import numpy as np
import pandas as pd
import os
directory = "C:\\Users\\USER\\Desktop\\verilog_Exercise\\CC"
Color_path = os.path.join(directory, "Candy_Crush_color.dat")
Position_path = os.path.join(directory, "Candy_Crush_position.dat")
Type_path = os.path.join(directory, "Candy_Crush_type.dat")

#####   Pattern 格式    ######
# 第一區 36糖果對應的顏色，從(0, 0)開始至(5, 5)，以2進制表示
# 第二區 四顆條紋糖果的位置
# 第三區 條紋糖果的類型, 1:垂直消除 ; 0:水平消除
#####   Pattern 格式    ######

# 定義各種列表
Candy_Color_List = np.array(['000', '001', '010', '011', '100', '101'])  # Candy 顏色
Special_Candy_position_List = np.array(['000', '001', '010', '011', '100', '101'])  # 位置
Special_Candy_type_List = np.array(['0', '1'])  # 糖果類型

# 隨機生成顏色、位置和類型資料
random_color = np.random.choice(Candy_Color_List, 36)
# random_position = np.random.choice(Special_Candy_position_List, 8)
random_type = np.random.choice(Special_Candy_type_List, 4)
random_position = [''.join(np.random.choice(Special_Candy_position_List, 2)) for _ in range(4)]
# 將隨機資料轉為字串，每個值獨立佔一行
random_color_str = '\n'.join(random_color)
random_position_str = '\n'.join(random_position)
random_type_str = '\n'.join(random_type)


# 如果資料夾不存在，則建立
if not os.path.exists(directory):
    os.makedirs(directory)
# 寫入檔案
with open(Color_path, "w") as file:
    file.write(random_color_str)

print(f"資料已成功儲存至 {Color_path}")
with open(Type_path, "w") as file:
    file.write(random_type_str)

print(f"資料已成功儲存至 {Type_path}")
with open(Position_path, "w") as file:
    file.write(random_position_str)

print(f"資料已成功儲存至 {Position_path}")
