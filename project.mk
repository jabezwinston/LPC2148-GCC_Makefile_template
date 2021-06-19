#  Author : Jabez Winston <jabezwinston@gmail.com>

############################ Project files and configuration ######################

PROJ_NAME = blink

# Add C files as many you want
C_SRCS += main.c 
C_SRCS += delay/delay.c

INCLUDE_PATHS += .
INCLUDE_PATHS += ./delay

ASM_SRCS += crt0.S

# Compiler and Linker flags
CFLAGS += -c -mcpu=arm7tdmi-s  -Wall -nostdlib -nostartfiles
LDFLAGS += -mcpu=arm7tdmi-s -T lpc2148.ld -nostdlib -nostartfiles

##################### Upload program to microcontroller ###########################

UPLOAD_TOOL = lpc21isp

PORT ?= COM7
BAUD_RATE = 9600
CRYSTAL_FREQ = 12000000

UPLOAD_TOOL_PARAMS = $(PORT) $(BAUD_RATE) $(CRYSTAL_FREQ)

###################################################################################