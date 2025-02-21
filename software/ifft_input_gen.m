function ifft_input_gen(N)
% 生成激励的verilog代码

% 处理原输入数据
x_re = 0.00003*flip(1:N);
x_im = 0.00003*flip(1:N);

% 原输入定点化
x_re_fixed=int16(round(x_re * 2^15)); % Q15
x_im_fixed=int16(round(x_im * 2^15));
x_fixed = complex(x_re_fixed, x_im_fixed);

% 计算FFT
X_matlab = fft(x_fixed, N);
X_re = int16(real(X_matlab));
X_im = int16(imag(X_matlab));

for ii = 1:N
    hex_value = dec2hex(typecast(X_re(ii), 'uint16'), 4);
    fprintf('%s\n', hex_value);
end
fprintf("\n\n\n");
for ii = 1:N
    hex_value = dec2hex(typecast(X_im(ii), 'uint16'), 4);
    fprintf('%s\n', hex_value);
end

end
