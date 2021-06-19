#  Author : Jabez Winston <jabezwinston@gmail.com>

include project.mk

CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy

ifeq ($(OS),Windows_NT)
    IS_CC_FOUND = $(shell where $(CC))
    $(info Platform: Windows)
    SHELL = cmd
    CP  = copy
    RM  = del /s /q
    MKDIR = mkdir
    syspath = $(subst /,\,$(1))
else
    IS_CC_FOUND = $(shell which $(CC))
    $(info Platform: Linux / macOS)
    RM = rm -rf
    MKDIR = mkdir -p
    syspath = $(subst /,/,$(1))
endif

OBJ_DIR = _build

EXE =  $(PROJ_NAME).elf
BIN =  $(PROJ_NAME).bin
HEX =  $(PROJ_NAME).hex

ARTIFACTS = $(EXE) $(BIN) $(HEX)

ASM_FILES = $(notdir $(ASM_SRCS))
ASM_OBJS += $(addprefix $(OBJ_DIR)/, $(ASM_FILES:.S=.o))
ASM_PATHS = $(sort $(dir $(ASM_SRCS)))
vpath %.S $(ASM_PATHS)

C_FILES = $(notdir $(C_SRCS))
C_OBJS += $(addprefix $(OBJ_DIR)/, $(C_FILES:.c=.o))
C_PATHS = $(sort $(dir $(C_SRCS)))
DEP += $(C_OBJS:%.o=%.d)
vpath %.c $(C_PATHS)

all: $(ARTIFACTS)

upload: $(HEX)
	@echo [ UPLOAD ] $<
	@echo.
	@echo Waiting ... Press reset button to start download !
	@echo.
	@$(UPLOAD_TOOL) $(HEX) $(UPLOAD_TOOL_PARAMS) 

$(OBJ_DIR):
	@echo [ MKDIR ] $@
	@$(MKDIR) $(call syspath,$@)

$(BIN): $(EXE)
	@echo [ BIN ] $@
	@$(OBJCOPY) -O binary $< $@

$(HEX): $(EXE)
	@echo [ HEX ] $@
	@$(OBJCOPY) -O ihex $< $@

$(EXE): $(OBJ_DIR) $(C_OBJS) $(ASM_OBJS)
	@echo [ LD ] $@
	@$(CC) $(LDFLAGS) -o "$@" $(C_OBJS) $(ASM_OBJS) $(addprefix -L,$(LIBPATHS)) $(addprefix -l,$(LIBS))

-include $(DEP)

$(OBJ_DIR)/%.o: %.S
	@echo [ AS ] $<
	@$(CC) $(CFLAGS) -o "$@" "$<"

$(OBJ_DIR)/%.o: %.c
	@echo [ CC ] $<
	@$(CC) $(CFLAGS) -MMD $(addprefix -I,$(INCLUDE_PATHS)) -o "$@" "$<"

clean:
	@echo "Cleaning..."
	@$(RM) $(ARTIFACTS) $(call syspath,$(OBJ_DIR))