#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2018 by Future Design Systems
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#-------------------------------------------------------------------------------
ifeq ($(MAKECMDGOALS),$(findstring $(MAKECMDGOALS), "" "all" "vivado"))
    ifndef XILINX_VIVADO
       $(error XILINX_VIVADO environment variable not defined)
    else
        export VIVADO         = $(XILINX_VIVADO)/bin/vivado
        export VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-7)
        export VIVADO_VER     = vivado.$(VIVADO_VERSION)
    endif
    ifndef CONFMC_HOME
       $(error CONFMC_HOME environment variable not defined)
    else
        export BFM_AXI = ${CONFMC_HOME}/hwlib/trx_axi
        export BFM_AXI_EDIF = ${BFM_AXI}/syn/vivado.z7
        ifeq ("$(wildcard ${BFM_AXI}/syn/vivado.z7/bfm_axi.edif)","")
             $(warning "${BFM_AXI}/syn/vivado.z7/bfm_axi.edif not found.")
             ifeq ("$(wildcard ${BFM_AXI}/syn/vivado/bfm_axi.edif)","")
                  $(error "${BFM_AXI}/syn/vivado/bfm_axi.edif not found.")
             else
                  export DIR_BFM_EDIF=${BFM_AXI}/syn/vivado
             endif
        else
             export DIR_BFM_EDIF=${BFM_AXI}/syn/vivado.z7
        endif
    endif
endif
#------------------------------------------------------------------
export VIVADO       = $(XILINX_VIVADO)/bin/vivado
export PROJECT_DIR  = myproj
export DESIGN       = bfm_axi_mem
export PROJECT_NAME = project_$(DESIGN)
export DESIGN_NAME  = design_$(DESIGN)

export WORK         = work
export PART         = xc7z020-clg484-1
export TOP          = fpga
export BOARD_PART   = avnet.com:zedboard:1.4

export SOURCE       = run_vivado.tcl
export RIGOR        = 1
export GUI         ?= 1

#------------------------------------------------------------------
all: vivado

vivado:
	if [ "$(GUI)" = "1" ]; then\
		$(VIVADO) -mode gui -source $(SOURCE);\
	else\
		$(VIVADO) -mode batch -source $(SOURCE);\
	fi

#------------------------------------------------------------------
DIRS    = $(subst /,, $(dir $(wildcard */Makefile)))
clean:
	@/bin/rm   -f  vivado.jou
	@/bin/rm   -f  vivado.log
	@/bin/rm   -f  vivado_*.backup.jou
	@/bin/rm   -f  vivado_*.backup.log
	@/bin/rm   -f  hs_err_*.log
	@/bin/rm   -f  vivado_pid*.str
	@/bin/rm   -f  vivado_pid*.zip
	@if [ -d .Xil ]; then /bin/rm -fr .Xil; fi
	@if [ -d hd_visual ]; then /bin/rm -fr hd_visual; fi

cleanup: clean

cleanupall: cleanup
	@/bin/rm -f  $(TOP).bit
	@if [ -d $(PROJECT_DIR) ]; then /bin/rm -fr $(PROJECT_DIR); fi
