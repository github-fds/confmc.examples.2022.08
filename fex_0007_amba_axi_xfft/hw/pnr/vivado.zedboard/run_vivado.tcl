set TOP          $::env(TOP)
set DESIGN       $::env(DESIGN)
set DESIGN_NAME  $::env(DESIGN_NAME)
set PROJECT_NAME $::env(PROJECT_NAME)
set PROJECT_DIR  $::env(PROJECT_DIR)
set FIP_HOME     $::env(FIP_HOME)
set PART         $::env(PART)
set BOARD_PART   $::env(BOARD_PART)
set PWD          [pwd]

set DIR_RTL        "../../design/verilog"
set DIR_BFM        "$::env(CONFMC_HOME)/hwlib/trx_axi"
set DIR_AXI        "${FIP_HOME}/amba_axi/rtl/verilog"
set DIR_APB        "${FIP_HOME}/axi_to_apb/rtl/verilog"
set DIR_CONFIG     "${FIP_HOME}/xfft_config/rtl/verilog"
set DIR_MEM        "${FIP_HOME}/mem_axi_dual/rtl/verilog"
set DIR_MEM_BRAM   "${FIP_HOME}/mem_axi_dual/bram_true_dual_port/$::env(FPGA_TYPE)/$::env(VIVADO_VER)"
set DIR_M2S        "${FIP_HOME}/axi_mem2stream/rtl/verilog"
set DIR_S2M        "${FIP_HOME}/axi_stream2mem/rtl/verilog"
set DIR_XFFT       "${FIP_HOME}/xfft/$::env(FPGA_TYPE)/$::env(VIVADO_VER)/xfft_16bit256samples"
set DIR_XDC        "./xdc"

create_project -force ${PROJECT_NAME} ${PROJECT_DIR} -part ${PART}
#set_property BOARD_PART ${BOARD_PART} [current_project]
create_bd_design ${DESIGN_NAME}

set_property verilog_dir "${PWD}
                          ${DIR_RTL}
                          ${DIR_BFM}/rtl/verilog
                          ${DIR_AXI}
                          ${DIR_APB}
                          ${DIR_CONFIG}
                          ${DIR_MEM}
                          ${DIR_MEM_BRAM}
                          ${DIR_M2S}
                          ${DIR_S2M}
                          ${DIR_XFFT}
                          " [current_fileset]

set_property verilog_define "VIVADO=1 SYN=1 AMBA_AXI4=1 BOARD_ZED=1" [current_fileset]
# The glob command returns all of the files within the specified file path matching the file pattern. 
# In Vivado, there are three filesets created by default:
# sources_1, constrs_1, and sim_1.
# The sources_1 fileset contains all the verilog and vhdl source files for synthesis,
# the constrs_1 fileset contains all of the .xdc files,
# and the sim_1 fileset contains your testbench for your project.
add_files -norecurse -fileset sources_1 ${PWD}/syn_define.v
add_files -norecurse -fileset sources_1 ${DIR_RTL}/fpga.v
add_files -norecurse -fileset sources_1 ${DIR_BFM}/rtl/verilog/bfm_axi_stub.v
add_files -norecurse -fileset sources_1 ${DIR_AXI}/amba_axi_m2s3.v
add_files -norecurse -fileset sources_1 ${DIR_APB}/axi_to_apb_s3.v
add_files -norecurse -fileset sources_1 ${DIR_CONFIG}/xfft_config_stub.v
add_files -norecurse -fileset sources_1 ${DIR_MEM}/bram_axi_dual.v
add_files -norecurse -fileset sources_1 ${DIR_M2S}/axi_mem2stream_stub.v
add_files -norecurse -fileset sources_1 ${DIR_S2M}/axi_stream2mem_stub.v
add_files -norecurse -fileset sources_1 ${DIR_XFFT}/xfft_16bit256samples_stub.v

add_files -fileset constrs_1 ${DIR_XDC}/fpga_etc.xdc
add_files -fileset constrs_1 ${DIR_XDC}/fpga_zed.xdc
add_files -fileset constrs_1 ${DIR_XDC}/con-fmc_lpc_zed.xdc
if {[file exists "additional.xdc"] == 1} {
         add_files -fileset constrs_1 "additional.xdc"
}

add_files -fileset sources_1 "$::env(DIR_BFM_EDIF)/bfm_axi.edif"
add_files -fileset sources_1 "${FIP_HOME}/axi_mem2stream/syn/vivado.$::env(FPGA_TYPE)/axi_mem2stream.edif"
add_files -fileset sources_1 "${FIP_HOME}/axi_stream2mem/syn/vivado.$::env(FPGA_TYPE)/axi_stream2mem.edif"
add_files -fileset sources_1 "${FIP_HOME}/xfft_config/syn/vivado.$::env(FPGA_TYPE)/xfft_config.edif"
add_files -fileset sources_1 "${DIR_MEM_BRAM}/bram_true_dual_port_32x16KB/bram_true_dual_port_32x16KB.xci"
add_files -fileset sources_1 "${DIR_MEM_BRAM}/bram_true_dual_port_32x32KB/bram_true_dual_port_32x32KB.xci"
add_files -fileset sources_1 "${DIR_MEM_BRAM}/bram_true_dual_port_32x64KB/bram_true_dual_port_32x64KB.xci"
add_files -fileset sources_1 "${DIR_XFFT}/xfft_16bit256samples.xci"

import_files -force

set_property is_global_include true [get_files  syn_define.v]
set_property top ${TOP} [current_fileset]
update_compile_order -fileset sources_1
set_property source_mgmt_mode DisplayOnly [current_project]

proc syn_impl { } {
    global PROJECT_DIR PROJECT_NAME DESIGN_NAME TOP
    # run synth 
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    # run imple 
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1

    file copy -force ${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/${TOP}.bit ${TOP}.bit
}

