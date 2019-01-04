#!/bin/bash 
set -v
sudo bash ./run_test_fpga.sh array_test1
sudo bash ./run_test_fpga.sh array_test2
sudo bash ./run_test_fpga.sh basicopt1
sudo bash ./run_test_fpga.sh bulgarian
sudo bash ./run_test_fpga.sh expr
sudo bash ./run_test_fpga.sh gcd
sudo bash ./run_test_fpga.sh hanoi
sudo bash ./run_test_fpga.sh lvalue2
sudo bash ./run_test_fpga.sh magic
sudo bash ./run_test_fpga.sh manyarguments
sudo bash ./run_test_fpga.sh multiarray
sudo bash ./run_test_fpga.sh pi
sudo bash ./run_test_fpga.sh qsort
sudo bash ./run_test_fpga.sh queens
sudo bash ./run_test_fpga.sh statement_test
sudo bash ./run_test_fpga.sh superloop
sudo bash ./run_test_fpga.sh tak