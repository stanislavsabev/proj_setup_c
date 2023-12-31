CC = gcc
STD = -std=c17
CFLAGS = -Wall -Wextra -g $(STD)
DFLAGS = DEBUG

# Directories
SRC_DIR = ./src
INC_DIR = ./include
LIB_DIR = ./lib
OBJ_DIR = ./obj
BIN_DIR = ./bin
DEBUG_DIR = $(OBJ_DIR)/debug
BIN_DEBUG_DIR = $(BIN_DIR)/debug

# Libraries
# FXLIB_DIR = $(PROJECTS_DIR)/fx-c
# FXLIB = fxlib.a

# Target name
TARGET_NAME = main

# compile macros
TARGET_NAME := main
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_DIR)/$(TARGET_NAME)
TARGET_DEBUG := $(BIN_DEBUG_DIR)/$(TARGET_NAME)
DFLAGS := $(addprefix -D,$(DFLAGS))

# src files & obj files
SRCS := $(foreach x, $(SRC_DIR), $(wildcard $(addprefix $(x)/*,.c*)))
SRC_HEADERS=$(wildcard $(SRC_DIR)/*.h)
INC_HEADERS=$(wildcard $(INC_DIR)/*.h)
OBJS := $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))
OBJS_DEBUG := $(addprefix $(DEBUG_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))

# clean files list
CLEAN_LIST := $(BIN_DIR) $(OBJ_DIR)


all: help ## Default rule

# non-phony targets
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c*
	$(CC) $(CFLAGS) -c -o $@ $^

$(DEBUG_DIR)/%.o: $(SRC_DIR)/%.c*
	$(CC) $(CFLAGS) $(DFLAGS)  -c -g -o $@ $^

$(TARGET_DEBUG): $(OBJS_DEBUG)
	$(CC) $(CFLAGS) $(DFLAGS)  -g -o $@ $^
 
# phony rules

b: build ##
build: build_release build_debug ## Build all


rb: rebuild ##
rebuild: clean build ## Clean and rebuild target


release: makedirs headers $(TARGET) ## Build Release
	@printf "build: OK\n"


headers: $(SRC_HEADERS) $(INC_HEADERS)


db: debug ##
debug: makedirs headers $(TARGET_DEBUG) ## Build Debug
	@printf "debug build: OK\n"

run: build ## Run Release
	@printf "run: "
	$(TARGET_DEBUG)
	# $(TARGET)


c: clean ##
clean: ## Clean build directories
	@echo Clean $(CLEAN_LIST)
	@rm -rf $(CLEAN_LIST)


makedirs: ## Create buld directories
	@mkdir -p $(BIN_DIR) $(OBJ_DIR) $(DEBUG_DIR) $(BIN_DEBUG_DIR) $(LIB_DIR) $(INC_DIR)


libs: ## Source external libraries
	mkdir -p  $(LIBFXC_INC_DIR)
	$(RM)  $(LIB_DIR)/* $(LIBFXC_INC_DIR)/*
	@cp -fr $(LIBFXC_SRC_DIR)/include/* $(LIBFXC_INC_DIR)
	@cp -fr $(LIBFXC_SRC_DIR)/lib/* $(LIB_DIR)


format: ## Format with clang-format
	@clang-format -i $(SRCS)


h: help ##
help: ## Show this message
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make  \033[36m<target>\033[0m\n\nTargets:\n"} \
    /^[a-zA-Z_-]+:.*?##/ { if(length($$2) == 0 ) { printf "\033[36m%7s\033[0m", $$1 } \
							  else { printf "\t\033[36m%-10s\033[0m %s\n", $$1, $$2 }}' $(MAKEFILE_LIST)


.PHONY: b build rb rebuild release headers db debug run c clean makedirs libs format h help