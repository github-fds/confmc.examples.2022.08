#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2016 by Future Design Systems.
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
#
# $ make            --> download through any JTAG
# $ make JTAG_ID=0  --> download through any JTAG
# $ make JTAG_ID=1  --> download through JTAG 1
# $ make JTAG_ID=2  --> download through JTAG 2
#------------------------------------------------------------------
ARCH	= $(shell uname)
MACH	= $(shell uname -m)
ifeq ($(ARCH),Linux)
  ifeq ($(MACH),x86_64)
        PLATFORM= linux64
  else
        PLATFORM= linux
  endif
else ifeq ($(findstring CYGWIN_NT,$(ARCH)),CYGWIN_NT)
  ifeq ($(MACH),x86_64)
        PLATFORM= cygwin64
  else
        PLATFORM= cygwin
  endif
else ifeq ($(findstring MINGW,$(ARCH)),MINGW)
  ifeq ($(MACH),x86_64)
        PLATFORM= mingw64
  else
        PLATFORM= mingw
  endif
else
  $(error un-supported platform $(ARCH))
endif
#------------------------------------------------------------------
ifeq ($(MAKECMDGOALS),$(findstring $(MAKECMDGOALS), "" "all" "vivado"))
ifndef XILINX_VIVADO
       $(warning XILINX_VIVADO environment variable not defined)
endif
export VIVADO = $(XILINX_VIVADO)/bin/vivado
export SOURCE = vivado_down.tcl	
export BITFILE= ../fpga.bit
export JTAG_ID = 0
       # 0 means auto detection
       # 1 or other
endif
#------------------------------------------------------------------
all: vivado

vivado:
	$(VIVADO) -mode batch -source $(SOURCE) || exit 1

#------------------------------------------------------------------
clean:
	-@/bin/rm -rf .Xil
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  *.html
	-@/bin/rm -f  *.xml
	-@/bin/rm -f  *.jou
	-@/bin/rm -f  *.backup*
	-@/bin/rm -f  planAhead.*
	-@/bin/rm -f  vivado.log
	-@/bin/rm -rf .cache

cleanup: clean
	-@/bin/rm -rf ./*.log
	-@/bin/rm -rf $(MODULE).ucf
	-@/bin/rm -rf $(MODULE).ut
	-@/bin/rm -rf $(MODULE).tcf

clobber: cleanup

cleanupall: cleanup
	-@/bin/rm -rf $(MODULE).bit
