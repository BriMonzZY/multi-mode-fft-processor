function input_gen(N)
% 生成激励的verilog代码

n=0:N-1;

% 输入激励
in_re = 0.005*sin(n);
in_im = 0.005*sin(n);
% 定点化输入激励
x_re=int16(round(in_re * 2^15)); % Q15
x_im=int16(round(in_im * 2^15));

fprintf('reg [15:0] x_re;\n');
fprintf('reg [15:0] x_re;\n\n');

for ii = 1:N
    hex_value = dec2hex(typecast(x_re(ii), 'uint16'), 4);
    fprintf('%s\n', hex_value);
end
fprintf("\n\n\n");
for ii = 1:N
    hex_value = dec2hex(typecast(x_im(ii), 'uint16'), 4);
    fprintf('%s\n', hex_value);
end

end
