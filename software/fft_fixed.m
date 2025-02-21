function [X_re, X_im] = fft_fixed(x_re, x_im, N)
% N-point fixed FFT
% Input:
%   x_re: real part of input signal (int16)
%   x_im: image part of input signal (int16)
% Output:
%   X_re: real part of FFT result
%   X_im: image part of FFT result

real = x_re;
imag = x_im;

% 生成旋转因子
rotation_factors = cell(log2(N), 1);
for stage = 1:log2(N)
    m = 2^(log2(N) - stage + 1);
    factors = int16(zeros(m/2, 2));
    for k = 0:(m/2 - 1)
        theta = 2 * pi * k / m;
        W_real = cos(theta);
        W_imag = -sin(theta);
        factors(k+1, 1) = int16(round(W_real * 2^15));
        factors(k+1, 2) = int16(round(W_imag * 2^15));
    end
    rotation_factors{stage} = factors;
end
% W=rotation_factors{1}

for stage = 1:log2(N)
    m = 2^(log2(N) - stage + 1);
    half_m = m / 2;
    factors = rotation_factors{stage};
    for k = 0:(N/m - 1)
        for j = 0:(half_m - 1)
            idx1 = k * m + j + 1;
            idx2 = idx1 + half_m;

            % 提取 x(idx1) 和 x(idx2)
            a_re = real(idx1);
            a_im = imag(idx1);
            b_re = real(idx2);
            b_im = imag(idx2);

            % 蝶形运算
            temp_re = int16(a_re - b_re);
            temp_im = int16(a_im - b_im);
            real(idx1) = int16(a_re + b_re);
            imag(idx1) = int16(a_im + b_im);

            % 获取旋转因子
            W_real = factors(j+1, 1);
            W_imag = factors(j+1, 2);

            t_re = int32(temp_re) * int32(W_real) - int32(temp_im) * int32(W_imag);
            t_im = int32(temp_re) * int32(W_imag) + int32(temp_im) * int32(W_real);

            % 右移15位并四舍五入
            % 逐级处理蝶形运算，每次乘法后右移15位进行四舍五入，加减法后右移1位防止溢出。
            t_re = int16(bitshift(t_re + 16384, -15));
            t_im = int16(bitshift(t_im + 16384, -15));

            real(idx2) = t_re;
            imag(idx2) = t_im;
        end
    end

    fprintf('Stage%d re0 output:\n', stage);
    for ii = 1:N/2
        hex_value = dec2hex(typecast(abs(real(ii)), 'uint16'), 4);
        fprintf('%s\n', hex_value);
    end
    fprintf('\n');
    fprintf('Stage%d re1 output:\n', stage);
    for ii = 1:N/2
        hex_value = dec2hex(typecast(abs(real(ii+half_m)), 'uint16'), 4);
        fprintf('%s\n', hex_value);
    end
    fprintf('\n\n\n\n');

end

X_re = bit_reverse(real, log2(N));
X_im = bit_reverse(imag, log2(N));

end
