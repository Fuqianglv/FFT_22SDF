# Copyright (c) 2024 LFQ

import cmath
import math
from jinja2 import Environment, FileSystemLoader

tf_width = 16
Ns = [2**i for i in range(3, 11)]  # N = 8, 16, 32, ..., 1024

output_fn = 'twiddlefactors.v'
env = Environment(loader=FileSystemLoader('.'))
template = env.get_template('twiddlefactors.v.t')
all_tfs = {}

for N in Ns:
    tfs = []
    leftshift = pow(2, tf_width - 1)
    
    for k in range(0, N // 8):
        tf = {}
        tf['k'] = k
        v = cmath.exp(-k * 2j * cmath.pi / N)
        
        if v.real > 0:
            tf['re_sign'] = ''
        else:
            tf['re_sign'] = '-'
            v = -v.real + (0 + 1j) * v.imag
        
        if v.imag > 0:
            tf['im_sign'] = ''
        else:
            tf['im_sign'] = '-'
            v = v.real - (0 + 1j) * v.imag
        
        tf['re'] = str(int(round(v.real * leftshift)))
        tf['im'] = str(int(round(v.imag * leftshift)))
        tfs.append(tf)
    
    all_tfs[N] = tfs

with open(output_fn, 'w') as f_out:
    f_out.write(template.render(tf_width=tf_width, tfs=all_tfs))