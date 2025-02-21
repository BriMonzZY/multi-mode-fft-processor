function x_reversed = bit_reverse(x, n_bits)
% Bit-reverse the input vector
% x: input vector
% n_bits: number of bits (log2(N))
% Example:
%   x=[0 1 2 3 4 5 6 7]
%   n_bits=3
%   x_reversed=[0 4 2 6 1 5 3 7]

N = length(x);
reversed_indices = zeros(1, N);

for i = 0:N-1
    reversed = 0;
    for bit_pos = 1:n_bits
        reversed = bitshift(reversed, 1);
        reversed = reversed + bitget(i, bit_pos);
    end
    reversed_indices(i + 1) = reversed;
end

x_reversed = x(reversed_indices + 1); % 转换为Matlab的1-based索引

end
