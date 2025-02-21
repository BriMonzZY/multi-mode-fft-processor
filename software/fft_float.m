function X = fft_float(x, N)
% N-point FFT implementation using floating-point model
% Input:
%   x: input signal (N points)
% Output:
%   X: FFT result

% Bit-reverse the input
x = bit_reverse(x, log2(N));

% Process each stage (log2N stages)
for stage = 0:(log2(N)-1)
    num_blocks = N / (2^(stage + 1)); % 每一级有多少组
    butterflies_per_block = 2^stage; % 每一组有多少个
    step = 2^stage;
    
    % Calculate twiddle factors for this stage
    k = 0 : butterflies_per_block - 1;
    W = exp(-1j * 2 * pi * k / (2^(stage + 1)));
    
    for block = 0 : num_blocks - 1
        base = block * 2^(stage + 1);
        
        for b = 0 : butterflies_per_block - 1
            idx1 = base + b + 1; % Matlab索引从1开始
            idx2 = idx1 + step;
            
            % 获取旋转因子
            w = W(b + 1);
            
            % 蝶形运算
            a = x(idx1);
            b_val = x(idx2) * w;
            
            x(idx1) = a + b_val;
            x(idx2) = a - b_val;
        end
    end
end

X = x;

end
