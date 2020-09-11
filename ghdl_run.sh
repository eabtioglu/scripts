#!/bin/bash

function delete_files(){
    tb_top=$1
    eleb=$2
    $(rm -rf *.cf)
    $(rm -rf *.vcd)
    $(rm -rf *.o)
    if [ $eleb -eq 1 ]
      then
        $(rm $tb_top)
    fi
}

if [ $# -eq 0 ]
  then
    echo "No argument is entered!"
    echo "---------------------------------------------------"
    echo "--------------------Example Usage------------------"
    echo "./ghdl_run.sh <top_file_name.vhd> <analyze only option>"
    echo "./ghdl_run.sh tb_top"
    echo "./ghdl_run.sh tb_top -a"
    echo "with argument -a only performs analyze"
    echo "---------------------------------------------------"
    exit
fi

filenames=$(ls)
GHDL_OPTIONS="-a -fsynopsys --std=08"
top_file=${1:0:-4} 

for filenames in *vhd; do
    { 
        ghdl $GHDL_OPTIONS ${filenames}
    } || {
        echo "Analyze failed with file : ${filenames}!"
        delete_files $top_file 0
        exit
    }
done
if [ $# -eq 2 ]
  then
    if [ $2 == "-a" ]; then
        delete_files $top_file 0
        exit
    fi
fi

{
    ghdl -e -fsynopsys --std=08 $top_file
} || {
    echo "Elaboration failed with file: $top_file"
    delete_files $top_file 1
    exit
}
ghdl -r --std=08 $top_file --vcd=wave.vcd
gtkwave wave.vcd config.gtkw --rcvar 'do_initial_zoom_fit yes'
delete_files $top_file 1
clear


