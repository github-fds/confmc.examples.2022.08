set DESIGN       $::env(DESIGN)
set DESIGN_NAME  $::env(DESIGN_NAME)
set PROJECT_NAME $::env(PROJECT_NAME)
set PROJECT_DIR  $::env(PROJECT_DIR)
set BOARD        $::env(BOARD)
set FPGA_TYPE    $::env(FPGA_TYPE)
set PART         $::env(PART)
set BOARD_PART   $::env(BOARD_PART)
set BFM_AXI      $::env(BFM_AXI)
set XDC_DIR      $::env(XDC_DIR)

source ${DESIGN_NAME}.tcl

add_files -fileset constrs_1 ${XDC_DIR}/con-fmc_lpc_zed.xdc
add_files -fileset constrs_1 ${XDC_DIR}/fpga_etc.xdc
add_files -fileset constrs_1 ${XDC_DIR}/fpga_zed.xdc

make_wrapper -files [get_files ${PROJECT_DIR}/${PROJECT_NAME}.srcs/sources_1/bd/${DESIGN_NAME}/${DESIGN_NAME}.bd] -top
add_files -norecurse           ${PROJECT_DIR}/${PROJECT_NAME}.gen/sources_1/bd/${DESIGN_NAME}/hdl/${DESIGN_NAME}_wrapper.v
set_property top ${DESIGN_NAME}_wrapper [current_fileset]
update_compile_order -fileset sources_1
set_property source_mgmt_mode DisplayOnly [current_project]

proc syn_impl { } {
    global PROJECT_DIR PROJECT_NAME DESIGN_NAME

    # run synth 
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    # run imple 
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1

    file copy -force ${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/${DESIGN_NAME}_wrapper.bit ${DESIGN_NAME}_wrapper.bit
    write_bd_layout -format pdf -orientation portrait -force ${DESIGN_NAME}.pdf

    assign_bd_address -export_to_file AddressMap.cvs
    assign_bd_address -export_gui_to_file AddressMapGui.csv
}

