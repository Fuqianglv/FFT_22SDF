import os
import matplotlib.pyplot as plt
import numpy as np
import math

def butterfly(I_a, I_b, Q_a, Q_b, out_I_a, out_I_b, out_Q_a, out_Q_b):
    out_I_a.clear()
    out_I_b.clear()
    out_Q_a.clear()
    out_Q_b.clear()
    
    for i in range(len(I_a)):
        out_I_a.append(int(I_a[i] + I_b[i]+1)>>1)
        out_I_b.append(int(I_a[i] - I_b[i]+1)>>1)
        out_Q_a.append(int(Q_a[i] + Q_b[i]+1)>>1)
        out_Q_b.append(int(Q_a[i] - Q_b[i]+1)>>1)
        
    print(f"out_I_a: {out_I_a}")
    print(f"out_I_b: {out_I_b}")
    print(f"out_Q_a: {out_Q_a}")
    print(f"out_Q_b: {out_Q_b}")
    
    
def bit_reverse(N, S, I, Q, I_a, I_b, Q_a, Q_b):
    I_a.clear()
    I_b.clear()
    Q_a.clear()
    Q_b.clear()
    
    for i in range(0, N, S):
        # SDF 方式存放数据
        I_a.extend(I[i:i + S // 2])  # 前 S/2 个放入 I_a
        I_b.extend(I[i + S // 2:i + S])  # 后 S/2 个放入 I_b
        
        Q_a.extend(Q[i:i + S // 2])  # 前 S/2 个放入 Q_a
        Q_b.extend(Q[i + S // 2:i + S])  # 后 S/2 个放入 Q_b
    
    print(f"I_a: {I_a}")
    print(f"I_b: {I_b}")
    print(f"Q_a: {Q_a}")
    print(f"Q_b: {Q_b}")

def twiddle(N, S, I, Q, I_out, Q_out):
    # 生成蝶形运算所需的旋转因子
    I=np.array(I)
    Q=np.array(Q)
    WN = []
    data_out = []
    data = I + 1j*Q
    '''for i in range(S):
        WN.append(math.cos(2 * math.pi * i / S) - 1j * math.sin(2 * math.pi * i / S))
    
    for i in range(0, N, S):
        for j in range(0, S, S//4):
            for k in range(0, S//4):
                if(j==0):
                    data_out.append(data[i+j+k]*WN[0])
                elif(j==S//2):
                    data_out.append(data[i+j+k]*WN[2*k])
                elif(j==S//4):
                    data_out.append(data[i+j+k]*WN[k])
                elif(j==3*S//4):
                    data_out.append(data[i+j+k]*WN[3*k])'''
                    
    for i in range(N):
        WN.append(math.cos(2 * math.pi * i / N) - 1j * math.sin(2 * math.pi * i / N))               
    for i in range(0, N):
        sel1 = 1 if i & 1<<(int(math.log2(S)-2)) else 0
        sel0 = 1 if i & 1<<(int)(math.log2(S)-1) else 0
        sel = (sel1<<1) | sel0
        print(f"i: {i}")
        print(f"sel: {sel}")
        
        m = (i&((S-1)>>2))
        print(f"m: {m}")
        addr = sel * m <<(int)(math.log2(N)-int(math.log2(S)))
        print(f"addr: {addr}")
        print(f"WN[addr]: {WN[addr]}")
        data_out.append(data[i]*WN[addr])
        

    I_out[:] = np.array(data_out).real.astype(np.int64).tolist()
    Q_out[:] = np.array(data_out).imag.astype(np.int64).tolist()

    
    print(f"I_out_tw: {I_out}")
    print(f"Q_out_tw: {Q_out}")

def out_IQ(N,S,I, Q):
    I_out = []
    Q_out = []
    for i in range(0, N//2, S):
        I_out.extend(I[i:i + S])
        I_out.extend(I[i+N//2:i + S+N//2])
        Q_out.extend(Q[i:i + S])
        Q_out.extend(Q[i+N//2:i + S+N//2])
    print(f"I_out: {I_out}")
    print(f"Q_out: {Q_out}")
    I[:]=I_out
    Q[:]=Q_out

def convert(N,S,I, Q):
    I_out = []
    Q_out = []
    for i in range(0, N):
        sel1 = 1 if i & 1<<(int(math.log2(S)-2)) else 0
        sel0 = 1 if i & 1<<(int)(math.log2(S)-1) else 0
        if(sel1==1 and sel0==1):
            I_out.append(Q[i])
            Q_out.append(-I[i])
        else:
            I_out.append(I[i])
            Q_out.append(Q[i])
    I[:]=I_out
    Q[:]=Q_out
    

def sdf(N,S,I,Q):
    I_a = []
    I_b = []
    Q_a = []
    Q_b = []
    I_out_a = []
    I_out_b = []
    Q_out_a = []
    Q_out_b = []
    I_out = []
    Q_out = []
    print(f"bit_reverse1:********************************")
    bit_reverse(N, S, I, Q, I_a, I_b, Q_a, Q_b)
    print(f"butterfly1:********************************")
    butterfly(I_a, I_b, Q_a, Q_b, I_out_a, I_out_b, Q_out_a, Q_out_b)
    
    print(f"bit_reverse2:********************************")
    I = I_out_a + I_out_b  # 将 I_out_a 和 I_out_b 拼接成一个 I
    Q = Q_out_a + Q_out_b  # 将 Q_out_a 和 Q_out_b 拼接成一个 Q
    out_IQ(N,S//2,I, Q)
    print(f"I: {I}")
    print(f"Q: {Q}")
    
    convert(N,S,I, Q)
    
    bit_reverse(N, S//2, I, Q, I_a, I_b, Q_a, Q_b)
    print(f"butterfly2:********************************")
    butterfly(I_a, I_b, Q_a, Q_b, I_out_a, I_out_b, Q_out_a, Q_out_b)
    I = I_out_a + I_out_b  # 将 I_out_a 和 I_out_b 拼接成一个 I
    Q = Q_out_a + Q_out_b  # 将 Q_out_a 和 Q_out_b 拼接成一个 Q
    print(f"I: {I}")
    print(f"Q: {Q}")
    out_IQ(N,S//4,I, Q)
    print(f"I: {I}")
    print(f"Q: {Q}")
    print(f"twiddle:********************************")
    twiddle(N, S, I, Q, I_out, Q_out)
    return I_out, Q_out
    
    
        

    
'''
# 文件路径
file_path = 'data_before_fft.txt'

# 检查文件是否存在
if not os.path.exists(file_path):
    print(f"错误: 文件 {file_path} 不存在")
    exit()

# 数据位宽
bit_length = 16  # 每个 I/Q 信号占用 8 位

# 读取并解析数据
I_signals = []
Q_signals = []

try:
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if len(line) != 2*bit_length:  # 每行应包含 16 位数据
                continue

            # 提取 I 路和 Q 路二进制字符串
            I_bin = line[:bit_length]  # 取前8位
            Q_bin = line[bit_length:]  # 取后8位

            # 解析为整数（考虑有符号数处理）
            I_val = int(I_bin, 2)
            Q_val = int(Q_bin, 2)

            # 处理有符号数 (8位有符号数范围 -128 到 127)
            if I_val >= 2**(bit_length - 1):
                I_val -= 2**bit_length
            if Q_val >= 2**(bit_length - 1):
                Q_val -= 2**bit_length

            I_signals.append(I_val)
            Q_signals.append(Q_val)

except Exception as e:
    print(f"读取文件时发生错误: {e}")
    exit()

# 检查是否有数据
if not I_signals or not Q_signals:
    print("未读取到有效数据")
    exit()

# 打印部分读取的数据
print(f"读取到的I信号数量: {len(I_signals)}")
print(f"读取到的Q信号数量: {len(Q_signals)}")
print(f"部分I信号: {I_signals[:10]}")
print(f"部分Q信号: {Q_signals[:10]}")

'''
Fs = 100 * 1_000_000  # 采样率100MHz
downsample_rate = 1  # 降采样倍数
bit_length = 8   # 16位有符号数
# 信号参数
N = 1024 * downsample_rate  # 采样点数
n = np.arange(1, N+1)
t = n / Fs
f = -4*1_000_000  # 信号频率1


# 生成I路和Q路测试信号
s_i = np.cos(2 * np.pi * f * t)
s_q = np.sin(2 * np.pi * f * t)
I_signals = np.round((pow(2,bit_length-1)-1) * s_i)  # I路放大100倍
Q_signals = np.round((pow(2,bit_length-1)-1) * s_q)  # Q路放大100倍
I_signals[:] = np.array(I_signals).astype(np.int32).tolist()
Q_signals[:] = np.array(Q_signals).astype(np.int32).tolist()
N=1024
I_out, Q_out = sdf(N, 1024, I_signals, Q_signals)
I_out, Q_out = sdf(N, 256, I_out, Q_out)
I_out, Q_out = sdf(N, 64, I_out, Q_out)
I_out, Q_out = sdf(N, 16, I_out, Q_out)
I_out, Q_out = sdf(N, 4, I_out, Q_out)

I = [0] * N     # 初始化列表，避免索引越界
Q = [0] * N   
new = 0

for i in range(len(I_out)):
    new =(i&(0x3<<0))<<(8) | (i&(0x3<<2))<<(4)  |(i&(0x3<<4)) | (i&(0x3<<6))>>(4) | (i&(0x3<<8))>>(8) 
    #print(f"new: {new}")
    #print(f"i: {i}")
    I[new] = I_out[i]
    Q[new] = Q_out[i]
    
I_out = I
Q_out = Q
#取平方和
I_out = np.array(I_out)
Q_out = np.array(Q_out)
I_out = I_out * I_out
Q_out = Q_out * Q_out
I_out = I_out + Q_out
#画出I_out和Q_out
plt.plot(I_out)
# 显示图像
plt.show()


