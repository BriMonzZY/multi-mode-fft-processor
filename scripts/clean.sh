#!/bin/bash
## clean temp files in project
##
## By brimonzzy
## Email: zzzy218@foxmail.com
##

cd ..
prj_path=$(pwd)
echo "project path: $prj_path"

read -p "是否执行该操作？(y/n): " choice
# 判断用户输入
case "$choice" in 
  y|Y )
    ;;
  n|N )
    exit 1
    ;;
  * )
    echo "无效的输入，请输入 'y' 或 'n'。"
    exit 1
    ;;
esac

rm -rf $prj_path/sim/vcs/generated-src
rm -rf $prj_path/sim/vcs/output
rm -rf $prj_path/sim/vcs/verdi_config_file

rm -rf $prj_path/syn/syn_asic/output
rm -rf $prj_path/syn/syn_asic/syn
