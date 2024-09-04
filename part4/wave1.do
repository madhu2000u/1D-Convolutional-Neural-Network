onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /check_timing/dut/controller/clk
add wave -noupdate /check_timing/dut/controller/reset
add wave -noupdate /check_timing/dut/controller/new_matrix
add wave -noupdate /check_timing/dut/controller/output_data
add wave -noupdate /check_timing/dut/controller/addr_x
add wave -noupdate /check_timing/dut/controller/addr_w
add wave -noupdate /check_timing/dut/controller/clear_acc
add wave -noupdate /check_timing/dut/controller/clear_pipeline_multiplier
add wave -noupdate /check_timing/dut/controller/clear_reg
add wave -noupdate /check_timing/dut/controller/en_acc
add wave -noupdate /check_timing/dut/controller/en_pipeline_reg
add wave -noupdate /check_timing/dut/controller/enable_mult
add wave -noupdate /check_timing/dut/controller/en_adders
add wave -noupdate /check_timing/dut/controller/valid_out_internal
add wave -noupdate /check_timing/dut/controller/clear_cntrMem
add wave -noupdate /check_timing/dut/controller/enable_cntrWriteMem
add wave -noupdate /check_timing/dut/controller/clear_cntrMac
add wave -noupdate /check_timing/dut/controller/enable_cntrMac
add wave -noupdate /check_timing/dut/controller/clear_cntrWriteMemW
add wave -noupdate /check_timing/dut/controller/clear_cntrMemBank
add wave -noupdate /check_timing/dut/controller/enable_cntrMemBank
add wave -noupdate /check_timing/dut/controller/countMemOut
add wave -noupdate /check_timing/dut/controller/countMemOutDelay
add wave -noupdate /check_timing/dut/controller/output_ready
add wave -noupdate /check_timing/dut/controller/output_valid
add wave -noupdate -radix unsigned /check_timing/dut/controller/countMacOut
add wave -noupdate /check_timing/dut/controller/countMem_X_Out
add wave -noupdate /check_timing/dut/controller/countWriteMem_W_Out
add wave -noupdate /check_timing/dut/controller/countMemBankOut
add wave -noupdate /check_timing/dut/controller/countOutputBufferWriteOut
add wave -noupdate /check_timing/dut/controller/countOutputBufferReadOut
add wave -noupdate /check_timing/dut/controller/enable_cntrWriteMem_W
add wave -noupdate /check_timing/dut/controller/input_ready
add wave -noupdate /check_timing/dut/controller/input_valid
add wave -noupdate /check_timing/dut/controller/countMemState
add wave -noupdate /check_timing/dut/controller/operationState
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_0
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_1
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_2
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_3
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_4
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_5
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_6
add wave -noupdate /check_timing/dut/controller/wr_en_x_g1_7
add wave -noupdate -divider {New Divider}
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_0
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_1
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_2
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_3
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_4
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_5
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_6
add wave -noupdate /check_timing/dut/controller/wr_en_w_g1_7
add wave -noupdate /check_timing/dut/vectorMemG1_0/addr
add wave -noupdate -radix decimal -childformat {{{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/vectorMemG1_0/mem[0][13]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][12]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][11]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][10]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][9]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][8]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][7]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][6]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][5]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][4]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][3]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][2]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][1]} {-radix decimal} {/check_timing/dut/vectorMemG1_0/mem[0][0]} {-radix decimal}} {/check_timing/dut/vectorMemG1_0/mem[0]}
add wave -noupdate -radix decimal {/check_timing/dut/vectorMemG1_1/mem[0]}
add wave -noupdate -radix decimal {/check_timing/dut/vectorMemG1_2/mem[0]}
add wave -noupdate -radix decimal {/check_timing/dut/vectorMemG1_3/mem[0]}
add wave -noupdate -radix decimal {/check_timing/dut/vectorMemG1_4/mem[0]}
add wave -noupdate -radix decimal {/check_timing/dut/vectorMemG1_5/mem[0]}
add wave -noupdate -radix decimal -childformat {{{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/vectorMemG1_6/mem[0][13]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][12]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][11]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][10]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][9]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][8]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][7]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][6]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][5]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][4]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][3]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][2]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][1]} {-radix decimal} {/check_timing/dut/vectorMemG1_6/mem[0][0]} {-radix decimal}} {/check_timing/dut/vectorMemG1_6/mem[0]}
add wave -noupdate -radix decimal -childformat {{{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/vectorMemG1_7/mem[0][13]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][12]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][11]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][10]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][9]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][8]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][7]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][6]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][5]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][4]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][3]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][2]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][1]} {-radix decimal} {/check_timing/dut/vectorMemG1_7/mem[0][0]} {-radix decimal}} {/check_timing/dut/vectorMemG1_7/mem[0]}
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_0/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_0/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_0/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_0/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_0/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_1/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_1/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_1/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_1/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_1/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_2/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_2/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_2/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_2/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_2/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_3/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_3/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_3/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_3/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_3/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_4/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_4/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_4/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_4/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_4/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_5/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_5/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_5/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_5/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_5/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_6/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_6/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_6/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_6/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_6/mem
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/matrixMemG1_7/mem[7]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[6]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[5]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[4]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[3]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[2]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[1]} -radix decimal} {{/check_timing/dut/matrixMemG1_7/mem[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/matrixMemG1_7/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[2]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/matrixMemG1_7/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/matrixMemG1_7/mem
add wave -noupdate /check_timing/dut/controller/matrixSize
add wave -noupdate /check_timing/dut/controller/delay_pipeline_n
add wave -noupdate /check_timing/dut/controller/pipelineStages
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/output_buffer/mem[63]} -radix decimal} {{/check_timing/dut/output_buffer/mem[62]} -radix decimal} {{/check_timing/dut/output_buffer/mem[61]} -radix decimal} {{/check_timing/dut/output_buffer/mem[60]} -radix decimal} {{/check_timing/dut/output_buffer/mem[59]} -radix decimal} {{/check_timing/dut/output_buffer/mem[58]} -radix decimal} {{/check_timing/dut/output_buffer/mem[57]} -radix decimal} {{/check_timing/dut/output_buffer/mem[56]} -radix decimal} {{/check_timing/dut/output_buffer/mem[55]} -radix decimal} {{/check_timing/dut/output_buffer/mem[54]} -radix decimal} {{/check_timing/dut/output_buffer/mem[53]} -radix decimal} {{/check_timing/dut/output_buffer/mem[52]} -radix decimal} {{/check_timing/dut/output_buffer/mem[51]} -radix decimal} {{/check_timing/dut/output_buffer/mem[50]} -radix decimal} {{/check_timing/dut/output_buffer/mem[49]} -radix decimal} {{/check_timing/dut/output_buffer/mem[48]} -radix decimal} {{/check_timing/dut/output_buffer/mem[47]} -radix decimal} {{/check_timing/dut/output_buffer/mem[46]} -radix decimal} {{/check_timing/dut/output_buffer/mem[45]} -radix decimal} {{/check_timing/dut/output_buffer/mem[44]} -radix decimal} {{/check_timing/dut/output_buffer/mem[43]} -radix decimal} {{/check_timing/dut/output_buffer/mem[42]} -radix decimal} {{/check_timing/dut/output_buffer/mem[41]} -radix decimal} {{/check_timing/dut/output_buffer/mem[40]} -radix decimal} {{/check_timing/dut/output_buffer/mem[39]} -radix decimal} {{/check_timing/dut/output_buffer/mem[38]} -radix decimal} {{/check_timing/dut/output_buffer/mem[37]} -radix decimal} {{/check_timing/dut/output_buffer/mem[36]} -radix decimal} {{/check_timing/dut/output_buffer/mem[35]} -radix decimal} {{/check_timing/dut/output_buffer/mem[34]} -radix decimal} {{/check_timing/dut/output_buffer/mem[33]} -radix decimal} {{/check_timing/dut/output_buffer/mem[32]} -radix decimal} {{/check_timing/dut/output_buffer/mem[31]} -radix decimal} {{/check_timing/dut/output_buffer/mem[30]} -radix decimal} {{/check_timing/dut/output_buffer/mem[29]} -radix decimal} {{/check_timing/dut/output_buffer/mem[28]} -radix decimal} {{/check_timing/dut/output_buffer/mem[27]} -radix decimal} {{/check_timing/dut/output_buffer/mem[26]} -radix decimal} {{/check_timing/dut/output_buffer/mem[25]} -radix decimal} {{/check_timing/dut/output_buffer/mem[24]} -radix decimal} {{/check_timing/dut/output_buffer/mem[23]} -radix decimal} {{/check_timing/dut/output_buffer/mem[22]} -radix decimal} {{/check_timing/dut/output_buffer/mem[21]} -radix decimal} {{/check_timing/dut/output_buffer/mem[20]} -radix decimal} {{/check_timing/dut/output_buffer/mem[19]} -radix decimal} {{/check_timing/dut/output_buffer/mem[18]} -radix decimal} {{/check_timing/dut/output_buffer/mem[17]} -radix decimal} {{/check_timing/dut/output_buffer/mem[16]} -radix decimal -childformat {{{[27]} -radix decimal} {{[26]} -radix decimal} {{[25]} -radix decimal} {{[24]} -radix decimal} {{[23]} -radix decimal} {{[22]} -radix decimal} {{[21]} -radix decimal} {{[20]} -radix decimal} {{[19]} -radix decimal} {{[18]} -radix decimal} {{[17]} -radix decimal} {{[16]} -radix decimal} {{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}}} {{/check_timing/dut/output_buffer/mem[15]} -radix decimal} {{/check_timing/dut/output_buffer/mem[14]} -radix decimal} {{/check_timing/dut/output_buffer/mem[13]} -radix decimal} {{/check_timing/dut/output_buffer/mem[12]} -radix decimal} {{/check_timing/dut/output_buffer/mem[11]} -radix decimal} {{/check_timing/dut/output_buffer/mem[10]} -radix decimal} {{/check_timing/dut/output_buffer/mem[9]} -radix decimal} {{/check_timing/dut/output_buffer/mem[8]} -radix decimal} {{/check_timing/dut/output_buffer/mem[7]} -radix decimal} {{/check_timing/dut/output_buffer/mem[6]} -radix decimal} {{/check_timing/dut/output_buffer/mem[5]} -radix decimal} {{/check_timing/dut/output_buffer/mem[4]} -radix decimal} {{/check_timing/dut/output_buffer/mem[3]} -radix decimal} {{/check_timing/dut/output_buffer/mem[2]} -radix decimal -childformat {{{[27]} -radix decimal} {{[26]} -radix decimal} {{[25]} -radix decimal} {{[24]} -radix decimal} {{[23]} -radix decimal} {{[22]} -radix decimal} {{[21]} -radix decimal} {{[20]} -radix decimal} {{[19]} -radix decimal} {{[18]} -radix decimal} {{[17]} -radix decimal} {{[16]} -radix decimal} {{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}}} {{/check_timing/dut/output_buffer/mem[1]} -radix decimal} {{/check_timing/dut/output_buffer/mem[0]} -radix decimal}} -expand -subitemconfig {{/check_timing/dut/output_buffer/mem[63]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[62]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[61]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[60]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[59]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[58]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[57]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[56]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[55]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[54]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[53]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[52]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[51]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[50]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[49]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[48]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[47]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[46]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[45]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[44]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[43]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[42]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[41]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[40]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[39]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[38]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[37]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[36]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[35]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[34]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[33]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[32]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[31]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[30]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[29]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[28]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[27]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[26]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[25]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[24]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[23]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[22]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[21]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[20]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[19]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[18]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[17]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[16]} {-height 16 -radix decimal -childformat {{{[27]} -radix decimal} {{[26]} -radix decimal} {{[25]} -radix decimal} {{[24]} -radix decimal} {{[23]} -radix decimal} {{[22]} -radix decimal} {{[21]} -radix decimal} {{[20]} -radix decimal} {{[19]} -radix decimal} {{[18]} -radix decimal} {{[17]} -radix decimal} {{[16]} -radix decimal} {{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}}} {/check_timing/dut/output_buffer/mem[16][27]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][26]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][25]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][24]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][23]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][22]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][21]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][20]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][19]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][18]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][17]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][16]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][15]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][14]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][13]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][12]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][11]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][10]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][9]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][8]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][7]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][6]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][5]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][4]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][3]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][2]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][1]} {-radix decimal} {/check_timing/dut/output_buffer/mem[16][0]} {-radix decimal} {/check_timing/dut/output_buffer/mem[15]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[14]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[13]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[12]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[11]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[10]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[9]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[8]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[7]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[6]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[5]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[4]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[3]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[2]} {-height 16 -radix decimal -childformat {{{[27]} -radix decimal} {{[26]} -radix decimal} {{[25]} -radix decimal} {{[24]} -radix decimal} {{[23]} -radix decimal} {{[22]} -radix decimal} {{[21]} -radix decimal} {{[20]} -radix decimal} {{[19]} -radix decimal} {{[18]} -radix decimal} {{[17]} -radix decimal} {{[16]} -radix decimal} {{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}}} {/check_timing/dut/output_buffer/mem[2][27]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][26]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][25]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][24]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][23]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][22]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][21]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][20]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][19]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][18]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][17]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][16]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][15]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][14]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][13]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][12]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][11]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][10]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][9]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][8]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][7]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][6]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][5]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][4]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][3]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][2]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][1]} {-radix decimal} {/check_timing/dut/output_buffer/mem[2][0]} {-radix decimal} {/check_timing/dut/output_buffer/mem[1]} {-height 16 -radix decimal} {/check_timing/dut/output_buffer/mem[0]} {-height 16 -radix decimal}} /check_timing/dut/output_buffer/mem
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/clk
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/data_in
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/data_out
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/wr_addr
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/rd_addr
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/wr_en
add wave -noupdate -radix decimal /check_timing/dut/output_buffer/rd_en
add wave -noupdate -radix decimal /check_timing/dut/controller/buffer_ready
add wave -noupdate /check_timing/dut/controller/valid_out_internal
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/clk
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/reset
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/b
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/macUnit_0/pipelinedMultOut[27]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[26]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[25]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[24]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[23]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[22]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[21]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[20]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[19]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[18]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[17]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[16]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[15]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[14]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[13]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[12]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[11]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[10]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[9]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[8]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[7]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[6]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[5]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[4]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[3]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[2]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[1]} -radix decimal} {{/check_timing/dut/macUnit_0/pipelinedMultOut[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/macUnit_0/pipelinedMultOut[27]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[26]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[25]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[24]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[23]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[22]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[21]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[20]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[19]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[18]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[17]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[16]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[15]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[14]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[13]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[12]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[11]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[10]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[9]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[8]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[7]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[6]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[5]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[4]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[3]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[2]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[1]} {-height 16 -radix decimal} {/check_timing/dut/macUnit_0/pipelinedMultOut[0]} {-height 16 -radix decimal}} /check_timing/dut/macUnit_0/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_0/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/clear_acc
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_1/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_2/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_3/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_4/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_5/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_6/clr_rst_mpx
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/en_pipeline_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/enable_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/clear_reg
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/clear_pipeline_mult
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/a
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/b
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/pipelinedMultOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/pipelinedRegOut
add wave -noupdate -radix decimal /check_timing/dut/macUnit_7/clr_rst_mpx
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/reset
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/clear_adders
add wave -noupdate -radix decimal -childformat {{{/check_timing/dut/pipelined_adders/mac_out_0[27]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[26]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[25]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[24]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[23]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[22]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[21]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[20]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[19]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[18]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[17]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[16]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[15]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[14]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[13]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[12]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[11]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[10]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[9]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[8]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[7]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[6]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[5]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[4]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[3]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[2]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[1]} -radix decimal} {{/check_timing/dut/pipelined_adders/mac_out_0[0]} -radix decimal}} -subitemconfig {{/check_timing/dut/pipelined_adders/mac_out_0[27]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[26]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[25]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[24]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[23]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[22]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[21]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[20]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[19]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[18]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[17]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[16]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[15]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[14]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[13]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[12]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[11]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[10]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[9]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[8]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[7]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[6]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[5]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[4]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[3]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[2]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[1]} {-height 16 -radix decimal} {/check_timing/dut/pipelined_adders/mac_out_0[0]} {-height 16 -radix decimal}} /check_timing/dut/pipelined_adders/mac_out_0
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_1
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl1_0
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_2
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_3
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl1_1
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_4
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_5
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl1_2
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_6
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/mac_out_7
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl1_3
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl2_0
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl2_1
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/sum_lvl3_0
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder0/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder1/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/reset
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder2/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder3/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder4/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder5/sum
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/clk
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/en_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/clear_adders
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/a
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/b
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/sum_output
add wave -noupdate -radix decimal /check_timing/dut/pipelined_adders/adder6/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1672 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 373
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1574 ns} {1769 ns}
