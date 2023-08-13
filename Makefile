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
OBJS := $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))
OBJS_DEBUG := $(addprefix $(DEBUG_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))

# clean files list
CLEAN_LIST := $(BIN_DIR) $(OBJ_DIR)

# default rule
default: all

all: help

.PHONY: help
help: ## Show this message
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

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
makedir: ## Create buld directories
	@mkdir -p $(BIN_DIR) $(OBJ_DIR) $(DEBUG_DIR) $(BIN_DEBUG_DIR) $(LIB_DIR) $(INC_DIR)

build: build_release build_debug ## Build all

rebuild: clean build ## Clean and rebuild target

build_release: makedir $(TARGET) ## Build Release
	@printf "build: OK\n"

build_debug: makedir $(TARGET_DEBUG) ## Build Debug
	@printf "debug build: OK\n"

debug: build_debug ## Run Debug
	@printf "debug: "
	./$(TARGET_DEBUG)

run: build ## Run Release
	@printf "run: "
	./$(TARGET)

clean: ## Clean build directories
	@echo Clean $(CLEAN_LIST)
	@rm -rf $(CLEAN_LIST)


.PHONY: makedir clean build run debug build_release build_debug