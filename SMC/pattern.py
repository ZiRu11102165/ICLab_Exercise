import numpy as np
import pandas as pd
import os


#####   Pattern 格式    ######
# 第一區 1個計算的模式，以2進制表示
# 第二區 6個Vgs的值
# 第三區 6個Vds的值
# 第四區 6個W的值
# 第五區 1個GT的值
# 最終顯示 ： Mode(1)Vgs(6)Vds(6)W(6)GT(4) 
#####   Pattern 格式    ######

def SaveFile(pattern_all):
    directory = "C:\\Users\\USER\\Desktop\\verilog_Exercise\\SMC"
    GT_path = os.path.join(directory, "Pattern.dat")
    # 如果資料夾不存在，則建立
    if not os.path.exists(directory):
        os.makedirs(directory)
    # 寫入檔案
    with open(GT_path, "w") as file:
        file.write(pattern_all)
    print(f"資料已成功儲存至 {GT_path}")
    
def gm_Calculator(vgs, vds, w):
    gm_result = []
    for i in range(0,6):
        if ((vgs[i]-1) > vds[i]):
            gm = int((2/3)*(w[i]*vds[i]))
        else :
            gm = int((2/3)*(w[i]*(vgs[i]-1)))
        gm_result.append(gm)
    gm_result_sort = np.array(gm_result)
    print("gm_result_sort = ", gm_result_sort)
    gm_result_final = np.sort(gm_result_sort)
    print("gm_result_final = ", gm_result_final[::-1])
    return gm_result_final[::-1]

def id_Calculator(vgs, vds, w):
    id_result = []
    for i in range(0,6):
        if ((vgs[i]-1) > vds[i]):
            id = int((1/3)*(w[i]*(2*(vgs[i]-1)*vds[i]-vds[i]*vds[i])))
        else :
            id = int((1/3)*(w[i]*((vgs[i]-1)*(vgs[i]-1))))
        id_result.append(id)
    id_result_sort = np.array(id_result)
    # print(id_result_sort)
    id_result_final = np.sort(id_result_sort)
    # print(id_result_final[::-1])
    return id_result_final[::-1]

def DtoB(inorout, result):
    print(result)
    if (inorout == 'in'):
        DtoB_list = []
        for i in range(len(result)):
            record_in_DtoB = int(result[i])
            record_in = bin(record_in_DtoB)
            record_in_nonb = record_in.split('b')[1]
            record_in_save = record_in_nonb.zfill(3)
            DtoB_list.append(record_in_save)
        # print(DtoB_list)
        return DtoB_list
    else:
        result_DtoB = int(result)
        result_B = bin(result_DtoB)
        result_B_nonb = result_B.split('b')[1]
        final_result_B = result_B_nonb.zfill(10)
        # print(final_result_B)
        return final_result_B
       
def Mode_Calculator(mode, vgs, vds, w):
    gm = gm_Calculator(vgs, vds, w)
    id = id_Calculator(vgs, vds, w)
    if (mode == 0):
        result = gm[3] + gm[4] + gm[5]
    elif (mode == 1):
        result = 3*id[3] + 4*id[4] + 5*id[5]
    elif (mode == 2):
        result = gm[0] + gm[1] + gm[2]
    elif (mode == 3):
        result = 3*id[0] + 4*id[1] + 5*id[2]
    # final_result = str(int(result))
    # final_result = final_result.zfill(4)
    final_result = int(result)
    final_result = DtoB('out', result)
    return final_result

def comb(*input):
    #str = in[0]
    str = ''
    for i in range(len(input)):
        #str += '_'
        # str += str(input[i])
        str += f'{input[i]}'
    return str

def random_generate(num_samples):
    random_modes = []
    random_vgs = []
    random_vds = []
    random_w = []
    random_modes_record = []
    random_vgs_record = []
    random_vds_record = []
    random_w_record = []
    
    # 定義各種列表
    Input_List = np.array([1, 2, 3, 4, 5, 6, 7])  # Input 3bit
    Mode_List = np.array([0, 1, 2, 3])  # Mode
    # # 設定要生成的組數
    # num_samples = 10
    for i in range(num_samples):
        # 生成隨機數據
        modes = np.random.choice(Mode_List, 1)
        random_modes.append(modes)
        random_modes_record.append(DtoB('in', modes))
        
        vgs = np.random.choice(Input_List, 6, replace=True).tolist()
        random_vgs.append(vgs)
        random_vgs_record.append(DtoB('in', vgs))
        
        vds = np.random.choice(Input_List, 6, replace=True).tolist()
        random_vds.append(vds)
        random_vds_record.append(DtoB('in', vds))
        w = np.random.choice(Input_List, 6, replace=True).tolist()
        random_w.append(w)
        random_w_record.append(DtoB('in', w))

    return random_modes, random_vgs, random_vds, random_w, random_modes_record, random_vgs_record, random_vds_record, random_w_record
        
def main():
    gt_list = []
    save_str = []
    num_samples = 100
    mode, vgs, vds, w, mode_record, vgs_record, vds_record, w_record = random_generate(num_samples)
    for i in range(num_samples):
        gt_list.append(Mode_Calculator(mode[i], vgs[i], vds[i], w[i]))
    for i in range(num_samples):
        str = comb(mode_record[i], vgs_record[i], vds_record[i], w_record[i], gt_list[i])
        clean_str = str.replace('[', '')
        clean_str = clean_str.replace(']', '')
        clean_str = clean_str.replace(' ', '')
        clean_str = clean_str.replace(',', '')
        clean_str = clean_str.replace('\'', '')
        
        save_str.append(clean_str)
    pattern_str_all = '\n'.join(save_str)
    print(pattern_str_all)
    SaveFile(pattern_str_all)


if __name__ == '__main__':
    main()