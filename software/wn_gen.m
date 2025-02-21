function wn_gen(N, IFFT)
% 生成N点FFT的旋转因子ROM的verilog代码

if IFFT
    n=0:(N/2-1);
    w_re=cos(2*pi*n/N);
    wn_re=int16(round(w_re * 2^15));
    w_im=sin(2*pi*n/N);
    wn_im=int16(round(w_im * 2^15));
else
    n=0:(N/2-1);
    w_re=cos(2*pi*n/N);
    wn_re=int16(round(w_re * 2^15));
    w_im=-sin(2*pi*n/N);
    wn_im=int16(round(w_im * 2^15));
end

% 打印实部赋值
for ii = 1:(N/2)
    if wn_re(ii) >= 0
        hex_value = dec2hex(typecast(wn_re(ii), 'uint16'), 4);
        fprintf('assign wn_re[%d] = $signed(16''sh%s);\n', ii-1, hex_value);
    else
        hex_value = dec2hex(typecast(abs(wn_re(ii)), 'uint16'), 4);
        fprintf('assign wn_re[%d] = $signed(-16''sh%s);\n', ii-1, hex_value);
    end
end

% 打印虚部赋值
for ii = 1:(N/2)
    if wn_im(ii) >= 0
        hex_value = dec2hex(typecast(wn_im(ii), 'uint16'), 4);
        fprintf('assign wn_im[%d] = $signed(16''sh%s);\n', ii-1, hex_value);
    else
        hex_value = dec2hex(typecast(abs(wn_im(ii)), 'uint16'), 4);
        fprintf('assign wn_im[%d] = $signed(-16''sh%s);\n', ii-1, hex_value);
    end
end

end
