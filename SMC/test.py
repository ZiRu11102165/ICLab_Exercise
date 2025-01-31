import numpy as np

def comb(*input):
    #str = in[0]
    str = ''
    for i in range(len(input)):
        #str += '_'
        # str += str(input[i])
        str += f'{input[i]}'
    return str

def random_generate():
    i = 0
    random_modes = []
    random_vgs = []
    random_vds = []
    random_w = []
    save_str = []
    
    # 定義各種列表
    Input_List = np.array([0, 1, 2, 3, 4, 5, 6, 7])  # Input 3bit
    Mode_List = np.array([0, 1, 2, 3])  # Mode
    # 設定要生成的組數
    num_samples = 10
    for i in range(num_samples):
        # 生成隨機數據
        random_modes.append(np.random.choice(Mode_List, 1))
        random_vgs.append(np.random.choice(Input_List, 6, replace=True).tolist())
        random_vds.append(np.random.choice(Input_List, 6, replace=True).tolist())
        random_w.append(np.random.choice(Input_List, 6, replace=True).tolist())
    for i in range(num_samples):
        str = comb(random_modes[i], random_vgs[i], random_vds[i], random_w[i])
        save_str.append(str)
    print(save_str)
    
if __name__ == '__main__':
    random_generate()