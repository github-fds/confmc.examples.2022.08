set TOP          $::env(TOP)
set DESIGN       $::env(DESIGN)
set DESIGN_NAME  $::env(DESIGN_NAME)
set PROJECT_NAME $::env(PROJECT_NAME)
set PROJECT_DIR  $::env(PROJECT_DIR)
set PART         $::env(PART)
set BOARD_PART   $::env(BOARD_PART)
set PWD          [pwd]

set DIR_RTL        "../../design/verilog"
set DIR_BFM        "$::env(CONFMC_HOME)/hwlib/trx_axi"
set DIR_AES        "../../../iplib/aes128_axi"
set DIR_AES_EDIF   "${DIR_AES}/syn/vivado.$::env(FPGA_TYPE)"
set DIR_AES_FIFO   "${DIR_AES}/fifo_sync/$::env(FPGA_TYPE)/$::env(VIVADO_VER)"
set DIR_AES_MEM    "${DIR_AES}/mem_dual_port/$::env(FPGA_TYPE)/$::env(VIVADO_VER)"
set DIR_XDC        "xdc"

create_project -force ${PROJECT_NAME} ${PROJECT_DIR} -part ${PART}
#set_property BOARD_PART ${BOARD_PART} [current_project]
create_bd_design ${DESIGN_NAME}

set_property verilog_dir "${PWD}
                          ${DIR_RTL}
                          ${DIR_BFM}/rtl/verilog
                          ${DIR_AES}/rtl/verilog
                          ${DIR_AES}/rtl/verilog/aes128_core
                          ${DIR_AES_FIFO}
                          ${DIR_AES_MEM}
                          " [current_fileset]

add_files -fileset sources_1 "$::env(DIR_BFM_EDIF)/bfm_axi.edif"
add_files -fileset sources_1 "${DIR_AES}/syn/vivado.z7/aes128_axi.edif"
#add_files -fileset sources_1 "${DIR_AES_FIFO}/fifo_32to128_512/fifo_32to128_512.xci"
#add_files -fileset sources_1 "${DIR_AES_FIFO}/fifo_128to32_512/fifo_128to32_512.xci"
#add_files -fileset sources_1 "${DIR_AES_MEM}/bram_dual_port_8x512/bram_dual_port_8x512.xci"
#add_files -fileset sources_1 "${DIR_AES_MEM}/sbox_dual_port_8x512/sbox_dual_port_8x512.xci"
#add_files -fileset sources_1 "${DIR_AES_MEM}/sibox_dual_port_8x512/sibox_dual_port_8x512.xci"

set_property verilog_define "VIVADO=1 SYN=1 AMBA_AXI4=1 BOARD_ZED=1" [current_fileset]
add_files -norecurse ${PWD}/syn_define.v
add_files -norecurse ${DIR_RTL}/fpga.v
add_files -norecurse ${DIR_BFM}/rtl/verilog/bfm_axi_stub.v
add_files -norecurse ${DIR_AES}/rtl/verilog/aes128_axi_stub.v

add_files -fileset constrs_1 ${DIR_XDC}/fpga_etc.xdc
add_files -fileset constrs_1 ${DIR_XDC}/fpga_zed.xdc
add_files -fileset constrs_1 ${DIR_XDC}/con-fmc_lpc_zed.xdc

set_property is_global_include true [get_files  ${PWD}/syn_define.v]
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

syn_impl
