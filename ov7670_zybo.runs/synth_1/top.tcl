# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.cache/wt [current_project]
set_property parent.project_path C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
add_files -quiet c:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
set_property used_in_implementation false [get_files c:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
add_files -quiet c:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.dcp
set_property used_in_implementation false [get_files c:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.dcp]
read_verilog -library xil_defaultlib {
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/sccb_rom.v
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/rgb565_ctrl.v
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/vga_generator.v
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/sccb_if.v
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/camera_controller.v
  C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/sources_1/new/top.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/constrs_1/new/pin.xdc
set_property used_in_implementation false [get_files C:/Users/MatsudaKazuaki/Documents/GitHub/ov7670_zybo/ov7670_zybo.srcs/constrs_1/new/pin.xdc]


synth_design -top top -part xc7z010clg400-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }
