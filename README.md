# multi-mode FFT processor

Support calculation of 64/128/256/512 point FFT and IFFT.



```
.
├── README.md
├── software # algorithm
├── docs # spec、整体架构、接口时序、测试用例说明、测试结果波形、主要模块架构、ASIC或者FPGA综合结果
├── rtl
|   ├── src
|   ├── sim
|   |   ├── lib # 存放一些仿真库，例如 sim_models
|   |   ├── tb_src
|   |   ├── vcs
│   │   │   ├── vcs.mk
|   |   |   └── Makefile
|   |   ├── xcelium
│   │   │   ├── xcelium.mk
|   |   |   └── Makefile
|   |   ├── modelsim
|   |   |   └── Makefile
|   |   └── verilator
|   |       └── Makefile
|   └── syn
|       ├── syn_asic
|       |   ├── syn # 综合生成的文件
|       |   |   ├── log
|       |   |   ├── mapped
|       |   |   ├── report
|       |   |   ├── script
|       |   |   └── unmapped
|       |   ├── db # 存放PDK
|       |   └── scripts # ASIC综合脚本、约束文件
|       └── syn_fpga
|           └── scripts # FPGA综合脚本
├── scripts
└── (backup # 备份)

```


