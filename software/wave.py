import matplotlib.pyplot as plt

def read_hex_data_from_file(file_name):
    with open(file_name, 'r') as file:
        data = file.read().split()
    return [int(value, 16) for value in data]

def plot_re_im(re_data, im_data):
    print(len(re_data))
    plt.figure(figsize=(12, 5))

    plt.subplot(1, 2, 1)
    # plt.plot(range(len(re_data)), re_data, marker='o', color='blue', linestyle='-', label='Real Part')
    plt.plot(range(len(re_data)), re_data, color='blue', linestyle='-', label='Real Part')
    plt.xlabel('Index')
    plt.ylabel('Real')
    plt.title('FFT Real output')
    plt.grid(True)
    plt.legend()

    plt.subplot(1, 2, 2)
    # plt.plot(range(len(im_data)), im_data, marker='o', color='red', linestyle='-', label='Imaginary Part')
    plt.plot(range(len(im_data)), im_data, color='red', linestyle='-', label='Imaginary Part')
    plt.xlabel('Index')
    plt.ylabel('Imag')
    plt.title('FFT Imag output')
    plt.grid(True)
    plt.legend()

    plt.tight_layout()
    plt.show()

re_data = read_hex_data_from_file('../rtl/sim/test_vector/fft_output_re.txt')
im_data = read_hex_data_from_file('../rtl/sim/test_vector/fft_output_im.txt')


plot_re_im(re_data, im_data)
