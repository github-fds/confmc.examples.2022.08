SHELL=/bin/sh
ARCH=$(shell uname)

ARCH=$(shell uname -s)
ifeq ($(findstring MINGW,$(ARCH)),MINGW)
      PLATFORM=mingw
else ifeq ($(findstring CYGWIN,$(ARCH)),CYGWIN)
      PLATFORM=cygwin
else ifeq ($(findstring Linux,$(ARCH)),Linux)
      PLATFORM=linux
endif
MACHINE:=$(shell uname -m)
PROCESSOR:=$(uname -p)

ifndef CONFMC_HOME
       $(warning CONFMC_HOME environment variable not defined)
       #export CONFMC_HOME=${HOME}/work/projects/ez-usb-fx3
       export CONFMC_HOME=../../../..
endif

DEFINES ?=
CFLAGS  ?=-std=gnu99 -O
LDFLAGS ?=

ifeq ($(findstring Linux,$(ARCH)),Linux)
    CC      =gcc
    DEFINES+=
    CFLAGS +=-I$(CONFMC_HOME)/include
    LDFLAGS+=-L$(CONFMC_HOME)/lib/$(PLATFORM)_$(MACHINE) -lconapi -lusb-1.0
else ifeq ($(findstring MINGW,$(ARCH)),MINGW)
    CC=gcc
    DIR_LIBUSB=$(CONFMC_HOME)/libusb-1.0.22.win
    DEFINES  +=-DCOMPAT_MINGW_MS_VSNPRINTF -DBUILDING_STATIC
    CFLAGS   +=-I$(CONFMC_HOME)/include -I$(DIR_LIBUSB)/include
    ifeq ($(MACHINE),x86_64)
    LDFLAGS  +=-L$(CONFMC_HOME)/lib/$(PLATFORM)_$(MACHINE) -Wl,-Bstatic -lconapi\
             -L$(DIR_LIBUSB)/MinGW64/static -Wl,-Bstatic -lusb-1.0
    else
    LDFLAGS  +=-L$(CONFMC_HOME)/lib/$(PLATFORM)_$(MACHINE) -Wl,-Bstatic -lconapi\
             -L$(DIR_LIBUSB)/MinGW32/static -Wl,-Bstatic -lusb-1.0
    endif
else ifeq ($(findstring CYGWIN,$(ARCH)),CYGWIN)
    ifeq ($(MACHINE),x86_64)
        CC=$(MACHINE)-w64-mingw32-gcc
    else
        CC=$(MACHINE)-w32-mingw32-gcc
    endif
    DIR_LIBUSB=$(CONFMC_HOME)/libusb-1.0.22.win
    DEFINES+=
    CFLAGS+=-I$(CONFMC_HOME)/include -I$(DIR_LIBUSB)/include
    ifeq ($(MACHINE),x86_64)
    LDFLAGS+=-L$(CONFMC_HOME)/lib/$(PLATFORM)_$(MACHINE) -Wl,-Bstatic -lconapi\
             -L$(DIR_LIBUSB)/MinGW64/static -Wl,-Bstatic -lusb-1.0
    else
    LDFLAGS+=-L$(CONFMC_HOME)/lib/$(PLATFORM)_$(MACHINE) -Wl,-Bstatic -lconapi\
             -L$(DIR_LIBUSB)/MinGW32/static -lusb-1.0
    endif
endif

ifndef OBJECTDIR
  OBJECTDIR = obj
endif
ifeq (${wildcard $(OBJECTDIR)},)
  DUMMY:= $(shell mkdir $(OBJECTDIR))
else
  DUMMY:= $(shell rm -rf $(OBJECTDIR))
  DUMMY:= $(shell mkdir $(OBJECTDIR))
endif

TARGET= test
SRC   = main.c\
        arg_parser.c\
        trx_axi_api.c\
        aes128_api.c\
        rijndael.c\
        bmp_handle.c\
        test_bench.c
OBJS  = $(SRC:.c=.o)

DEFINES +=-DTRX_BFM -DTRX_AXI -DRIGOR -DVERBOSE
CFLAGS  +=-Isrc -I${CONFMC_HOME}/hwlib/trx_axi/api/c -Isrc.aes
CFLAGS  +=-IBmpHandle/src -I../../iplib/aes128_axi/api/c
LDFLAGS +=

H_DIR  =src:${CONFMC_HOME}/hwlib/trx_axi/api/c:$(CONFMC_HOME)/include\
           :BmpHandle/src:../../iplib/aes128_axi/api/c:src.aes
C_DIR  =src:${CONFMC_HOME}/hwlib/trx_axi/api/c:BmpHandle/src\
           :../../iplib/aes128_axi/api/c:src.aes

vpath %.h       $(H_DIR)
vpath %.c       $(C_DIR)

$(OBJECTDIR)/%.o: %.c
	$(CC) -c $(DEFINES) $(CFLAGS) -o $@ $<

all: pre $(addprefix $(OBJECTDIR)/,$(OBJS))
	$(CC) -o $(TARGET) $(addprefix $(OBJECTDIR)/,$(OBJS)) $(LDFLAGS)
#	$(CC) -o $(TARGET) $^ $(LDFLAGS)

pre:
	if [ -f compile.log ]; then /bin/rm -f compile.log; fi
	@echo "**DEFINES $(DEFINES)"
	@echo "**CFLAGS  $(CFLAGS) "
	@echo "**LDFLAGS $(LDFLAGS)"
	@echo "**H_DIR   $(H_DIR)  "
	@echo "**C_DIR   $(C_DIR)  "

run: $(TARGET)
	./$(TARGET) -c 0 -i images/lena_512x512.bmp -m 0
	@echo "Program done, check result images."
	@ls bmp_*
# 	./$(TARGET) -c 0 -i images/lena_512x512.bmp -m 1
# 	./$(TARGET) -c 0 -i images/lena_512x512.bmp -m 2
# 	./$(TARGET) -c 0 -i images/lena_512x512.bmp -m 3

clean:
	/bin/rm -fr obj
	/bin/rm -f  $(TARGET)
	/bin/rm -f  $(TARGET).exe

cleanup: clean
	/bin/rm -f bmp_org.bmp bmp_enc.bmp bmp_dec.bmp

cleanupall: cleanup

# $ make DEFINES=-DDEBUG=1
