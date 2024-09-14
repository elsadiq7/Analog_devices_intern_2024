vsim -gui work.fir_tb 
add wave -position insertpoint  \
sim:/fir_tb/clk \
sim:/fir_tb/rst_n \
sim:/fir_tb/x_n \
sim:/fir_tb/y_n

add wave -position insertpoint  \
sim:/fir_tb/ff1 \
sim:/fir_tb/ff2 \
sim:/fir_tb/ff3

run -all 


