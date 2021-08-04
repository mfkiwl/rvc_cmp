##########################################
# This is where we out the modelsim model
##########################################


# 1) Change directory to modesim
cd modelsim

# 2) Compile The Design
vlog "+define+HPATH=alive" -f .\ss_rvc_list.f

# 3a) Simulate the Design without gui
vsim.exe work.ss_rvc_tb -c -do 'run -all'

# 3b) Simulate the Design with gui
vsim.exe -gui work.ss_rvc_tb
