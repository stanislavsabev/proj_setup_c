
CC=gcc
CSTANDARD=-std=c17
WFLAGS=-Wall -Wextra
CFLAGS=$(WFLAGS) $(CSTANDARD)

SRC_DIR=src
OBJ_DIR=obj
BIN_DIR=bin
DEBUG_DIR=$(OBJ_DIR)/debug
BIN_DEBUG_DIR=$(BIN_DIR)/debug
TARGET_NAME=main

# compile macros
TARGET_NAME := main
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_DIR)/$(TARGET_NAME)
TARGET_DEBUG := $(BIN_DEBUG_DIR)/$(TARGET_NAME)


# src files & obj files
SRCS := $(foreach x, $(SRC_DIR), $(wildcard $(addprefix $(x)/*,.c*)))
OBJS := $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))
OBJS_DEBUG := $(addprefix $(DEBUG_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))

# clean files list
CLEAN_LIST := $(BIN_DIR) $(OBJ_DIR)

# default rule
default: all

.PHONY: all
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
	$(CC) $(CFLAGS) -c -g -o $@ $^

$(TARGET_DEBUG): $(OBJS_DEBUG)
	$(CC) $(CFLAGS) -g -o $@ $^
 
# phony rules
.PHONY: makedir
makedir: ## Create buld directories
	@mkdir -p $(BIN_DIR) $(OBJ_DIR) $(DEBUG_DIR) $(BIN_DEBUG_DIR)

.PHONY: build
build: build_release build_debug ## Build all

.PHONY: build_release
build: makedir $(TARGET) ## Build Release
	@printf "build: OK\n"

.PHONY: build_debug ## Build Debug
build_debug: makedir $(TARGET_DEBUG)
	@printf "build debug: OK\n"

.PHONY: debug
debug: build_debug ## Run Debug
	@printf "debug: "
	./$(TARGET_DEBUG)

.PHONY: run
run: build ## Run Release
	@printf "run: "
	./$(TARGET)

.PHONY: clean
clean: ## Clean build directories
	@echo Clean $(CLEAN_LIST)
	@rm -rf $(CLEAN_LIST)
