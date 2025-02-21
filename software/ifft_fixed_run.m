clc;clear;

% 设置FFT点数
N = 256;

% 处理原输入数据
t = 0:N-1;
x_re = 0.00003*flip(1:N);
x_im = 0.00003*flip(1:N);

% 原输入定点化
x_re_fixed=int16(round(x_re * 2^15)); % Q15
x_im_fixed=int16(round(x_im * 2^15));
x_fixed = complex(x_re_fixed, x_im_fixed);

% 计算FFT
X_matlab = fft(x_fixed, N);
X_matlab_fixed_re = int16(real(X_matlab));
X_matlab_fixed_im = int16(imag(X_matlab));
X_matlab_fixed = complex(X_matlab_fixed_re, X_matlab_fixed_im);

% 计算IFFT
X_matlab_ifft = ifft(X_matlab_fixed, N);
[X_ifft_re, X_ifft_im] = ifft_fixed(X_matlab_fixed_re, X_matlab_fixed_im, N);

X_matlab_ifft_fixed_re = int16(real(X_matlab_ifft));
X_matlab_ifft_fixed_im = int16(imag(X_matlab_ifft));


% fprintf('Output:\n');
% for ii = 1:N
%     hex_value = dec2hex(typecast(abs(X_re(ii)), 'uint16'), 4);
%     fprintf('%d:%s\n', ii-1, hex_value);
% end

% 比较结果
subplot(2,2,1);
plot(abs(X_ifft_re));
title('My IFFT re');
subplot(2,2,2);
plot(abs(X_matlab_ifft_fixed_re));
title('Matlab IFFT re');
subplot(2,2,3);
plot(abs(X_ifft_im));
title('My IFFT im');
subplot(2,2,4);
plot(abs(X_matlab_ifft_fixed_im));
title('Matlab IFFT im');

% 计算最大误差
max_error = max(abs(X_ifft_re - X_matlab_ifft_fixed_re));
fprintf('实部最大误差: %e\n', max_error);
max_error = max(abs(X_ifft_im - X_matlab_ifft_fixed_im));
fprintf('虚部最大误差: %e\n', max_error);
