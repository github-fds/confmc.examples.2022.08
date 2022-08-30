ifeq ($(MAKECMDGOALS),$(findstring $(MAKECMDGOALS), "" "all" "elab" "sim"))
    ifndef XILINX_VIVADO
       $(error XILINX_VIVADO environment variable not defined)
    endif
    ifndef CONFMC_HOME
       $(error CONFMC_HOME environment variable not defined)
    endif

    VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-)
    export VIVADO=vivado.$(VIVADO_VERSION)
endif

export FPGA_TYPE=z7
#export FPGA_TYPE=zusp
export GUI ?= 0

all: elab sim

elab:
	xelab -prj xsim.prj -debug typical -L secureip -L unisims_ver -L unimacro_ver top glbl -s top

sim:
	if [ "$(GUI)" = "1" ]; then\
		xsim top -gui -t xsim_run.tcl;\
	else\
		xsim top -t xsim_run.tcl;\
	fi

clean:
	/bin/rm -f  top.wdb
	/bin/rm -f  wave.vcd
	/bin/rm -f  webtalk_*.backup.jou
	/bin/rm -f  webtalk_*.backup.log
	/bin/rm -f  webtalk.jou
	/bin/rm -f  webtalk.log
	/bin/rm -f  xelab.log
	/bin/rm -f  xelab.pb
	/bin/rm -fr .Xil/
	/bin/rm -f  xsim_*.backup.jou
	/bin/rm -f  xsim_*.backup.log
	/bin/rm -fr xsim.dir/
	/bin/rm -f  xsim.jou
	/bin/rm -f  xsim.log
	/bin/rm -f  xvlog.log
	/bin/rm -f  xvlog.pb

cleanup: clean

cleanupall: cleanup
