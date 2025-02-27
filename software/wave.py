import matplotlib.pyplot as plt

def read_hex_data_from_file(file_name):
  with open(file_name, 'r') as file:
    data = file.read().split()
  return [int(value, 16) for value in data]

def plot_data(y_data):
  x_data = list(range(len(y_data)))
  
  plt.figure(figsize=(10, 5))
  plt.plot(x_data, y_data)
  # plt.plot(x_data, y_data, marker='o') # mark the data point
  plt.xlabel('X')
  plt.ylabel('Y')
  plt.title('FFT out')
  plt.grid(True)
  plt.show()

y_data = read_hex_data_from_file('../rtl/sim/test_vector/fft_output_re.txt')

plot_data(y_data)
