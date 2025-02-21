clc;clear;

% FFT点数
N = 64;

t = 0:N-1;
f = 10;
% x_re = cos(2*pi*f*t/N);
% x_im = sin(2*pi*f*t/N);
% x_re = flip(1:N);
% x_im = flip(1:N);
x_re = cos(1/3*pi*t);
x_im = zeros(1,N);
x = complex(x_re, x_im);

% 计算FFT
X_my = fft_float(x, N);
X_matlab = fft(x, N);

% 比较结果
subplot(2,1,1);
plot(abs(X_my));
title('My FFT');
subplot(2,1,2);
plot(abs(X_matlab));
title('Matlab FFT');

% 计算最大误差
max_error = max(abs(X_my - X_matlab));
fprintf('最大误差: %e\n', max_error);
