#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2018 by Future Design Systems
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile

#-------------------------------------------------------------------------------
export FPGA_TYPE    = z7
#-------------------------------------------------------------------------------
ifeq ($(MAKECMDGOALS),$(findstring $(MAKECMDGOALS), "" "all" "vivado"))
    ifndef XILINX_VIVADO
           $(error XILINX_VIVADO environment variable not defined)
    endif
    ifndef CONFMC_HOME
           $(error CONFMC_HOME environment variable not defined)
    endif
    export VIVADO = $(XILINX_VIVADO)/bin/vivado
    export VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-)
    export VIVADO_VER=vivado.$(VIVADO_VERSION)
    BFM_AXI=$(CONFMC_HOME)/hwlib/trx_axi
    ifeq ("$(wildcard $(BFM_AXI)/syn/vivado.$(FPGA_TYPE)/bfm_axi.edif)","")
         $(warning "$(BFM_AXI)/syn/vivado.$(FPGA_TYPE)/bfm_axi.edif not found.")
         ifeq ("$(wildcard $(BFM_AXI)/syn/vivado/bfm_axi.edif)","")
              $(warning "$(BFM_AXI)/syn/vivado/bfm_axi.edif not found.")
         else
              export DIR_BFM_EDIF=$(BFM_AXI)/syn/vivado
         endif
    else
         export DIR_BFM_EDIF=$(BFM_AXI)/syn/vivado.$(FPGA_TYPE)
    endif
endif
#------------------------------------------------------------------
export PROJECT_DIR  = project_1
export DESIGN       = fft
export PROJECT_NAME = project_$(DESIGN)
export DESIGN_NAME  = design_$(DESIGN)
export PART         = xc7z020-clg484-1
export BOARD        = ZED
export BOARD_PART   = avnet.com:zedboard:1.4
export FIP_HOME     = ../../../iplib

export TOP          = fpga
export SOURCE       = run_vivado.tcl
export RIGOR        = 1
export ILA         ?= 0
export GUI         ?= 1

FLOG	= $(MODULE)
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
	-@/bin/rm -rf .Xil
	-@/bin/rm -rf work .cache
	-@/bin/rm -f  *.html
	-@/bin/rm -f  *.xml
	-@/bin/rm -f  *.jou
	-@/bin/rm -f  *.backup*
	-@/bin/rm -f  planAhead.*
	-@/bin/rm -f  vivado.log
	-@/bin/rm -f  vivado_pid*.str  vivado_pid*.debug
	-@/bin/rm -f  fsm_encoding.os
	-@/bin/rm -f  impact_impact.xwbt  impact.xsl webtalk.log
	-@/bin/rm -rf work
	-@/bin/rm -rf project_1
	-@/bin/rm -fr project_1.cache
	-@/bin/rm -fr project_1.hw
	-@/bin/rm -fr project_1.ip_user_files
	-@/bin/rm -f  project_1.xpr
	-@/bin/rm -f  all.xdc
	-@/bin/rm -f  tight_setup_hold_pins.txt
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done
	/bin/rm -f xfft_16bit256samples_c_*_viv*.edn
	/bin/rm -f xfft_16bit256samples_xfft*.edn

cleanup clobber: clean
	-@/bin/rm -f  ./*.log
	-@/bin/rm -f  $(MODULE).ucf
	-@/bin/rm -f  $(MODULE).ut
	-@/bin/rm -f  $(MODULE).tcf
	-@/bin/rm -f  $(MODULE).edn
	-@/bin/rm -f  $(MODULE).edif
	-@/bin/rm -f all.xdc
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanupall: cleanup
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  fpga.bit
	-@/bin/rm -f  $(MODULE).bit
	-@/bin/rm -f  $(MODULE).ltx
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done
