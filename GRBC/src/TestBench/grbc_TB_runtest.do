SetActiveLib -work
comp -include "$dsn\src\Datatypes\Byte.vhd" 
comp -include "$dsn\src\Datatypes\Word.vhd" 
comp -include "$dsn\src\Datatypes\128_Stream.vhd" 
comp -include "$dsn\src\Datatypes\256_LUT.vhd" 
comp -include "$dsn\src\Sbox_Transformation.vhd" 
comp -include "$dsn\src\KeyExpansion.vhd" 
comp -include "$dsn\src\GRBC_ent.vhd" 
comp -include "$dsn\src\TestBench\grbc_TB.vhd" 
asim +access +r TESTBENCH_FOR_grbc 
wave 
wave -noreg IO
wave -noreg PK
wave -noreg LU
wave -noreg ED
wave -noreg RD
wave -noreg Start
wave -noreg Clk
wave -noreg Done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\grbc_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_grbc 
