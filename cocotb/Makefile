
TOPLEVEL_LANG := vhdl
TOPLEVEL := restoring_division
MODULE := test_division
SIM ?= questa
GUI ?= 1
export CI ?= 0
# starting layer for simulation
export DEBUG_ATTACH ?= 0
export FACTORY ?= 0
export FAIL_FAST ?= 0

WAVEDO?=wave.do
ifeq ($(GUI), 1)
	VSIM_ARGS += -do $(WAVEDO)
endif


# We still use VHDL `93 :-/
VCOM_ARGS = -2008
# For power simulation with ASIC models. It would be better to use VLOG_ARGS, but this is broken currently
# and fixed only in master branch of cocotb (commit 2bd215c from 27 Aug 2019)
COMPILE_ARGS = +define+ARM_UD_MODEL +define+INITIALIZE_MEMORY +noacc +define+PE_FAM_N=$(NUM_FAMILIES)
# we need our custom modelsim.ini with defined library mappings for Xilinx libraries
# this seems to be the only way to reliably set those mappings for both vcom/vlog/vsim
PLUSARGS = -modelsimini ./modelsim.ini
# These arguments will be passed directly to `vsim` invocation in generated `run_sim.do` file
#VSIM_ARGS = -L fifo_generator_v13_2_5
VSIM_ARGS += -t 1ps
# enable optionally for greater design visility, but at cost of longer simulation run time
VSIM_ARGS += -voptargs=\"+acc\"
# "uninitialized output with no driver" warnings came so far only from Xilinx IP internals
VSIM_ARGS += +nowarn8683 +nowarn8684

WPWD=$(shell sh -c 'pwd -W')
PWD=$(shell pwd)

ifeq ($(OS),Msys)
WPWD=$(shell sh -c 'pwd -W')
else
WPWD=$(shell pwd)
endif

# On many linux system default interpreter is Python 2, but we need Python >= 3.6
# Ubuntu uses Dash shell by default, which breaks cocotb internal scripts
ifneq ($(OS),Windows_NT)
PYTHON_BIN ?= /usr/bin/python3
export PYTHON_BIN
SHELL := /bin/bash
export SHELL
endif

# On some distros and with some simulators cocotb may pick a stdlib bundled with simulator,
# instead of system version. This may break Python code if we're importing any external Python modules
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6

SRC_DIR = $(WPWD)/../src

# Looking at XPM sources, only XPM_CDC modules may need glbl.v - depending on module parameter settings
#VERILOG_SOURCES = $(SRC_DIR)/asic_models/ikva_dp_mem_cln22ul/ikva_dp_mem.v \
#$(SRC_DIR)/aaa.v \



VHDL_SOURCES = $(SRC_DIR)/restoring_division.vhd

include $(shell cocotb-config --makefiles)/Makefile.sim

 
clean::
	rm -rf __pycache__
	rm -rf sim_build
	rm -f results.xml
	rm -f vsim.wlf
	rm -f transcript
	rm -f vsim_stacktrace.vstf










