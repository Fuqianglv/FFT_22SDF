import math

pi = math.pi

N = 8  # Number of FFT Points
NB = 8   # Number of Twiddle Data Bits

NX = int((NB + 3) / 4)  


with open('twiddle.txt', 'w') as f:
    f.write("//      wn_re = cos(-2pi*n/{0:2d})        wn_im = sin(-2pi*n/{0:2d})\n".format(N))
    
    for n in range(N):
        wr = math.cos(-2 * pi * n / N)
        wi = math.sin(-2 * pi * n / N)

        wr_d = math.floor(wr * 2**(NB-1) + 0.5)
        if wr_d == 2**(NB-1):
            wr_d -= 1
        wi_d = math.floor(wi * 2**(NB-1) + 0.5)
        if wi_d == 2**(NB-1):
            wi_d -= 1
        wr_u = wr_d + 2**NB if wr_d < 0 else wr_d
        wi_u = wi_d + 2**NB if wi_d < 0 else wi_d

        dontcare = 1
        if n < N / 4:
            dontcare = 0
        if n < 2 * N / 4 and n % 2 == 0:
            dontcare = 0
        if n < 3 * N / 4 and n % 3 == 0:
            dontcare = 0
            
        wr_s =  "{0:0{1}X}".format(wr_u, NX)
        wi_s =  "{0:0{1}X}".format(wi_u, NX)
        f.write("assign  wn_re[{0:2d}] = {1}'h{2};   ".format(n, NB, wr_s))
        f.write("assign  wn_im[{0:2d}] = {1}'h{2};   ".format(n, NB, wi_s))
        f.write("// {0:2d} {1:.3f} {2:.3f}\n".format(n, wr, wi))