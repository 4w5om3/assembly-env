# Compiler and linker settings
AS = as
LD = ld

# Flags
ASFLAGS = --fatal-warnings    # Treat warnings as errors
LDFLAGS = -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc

# Verbose mode (make VERBOSE=1)
ifeq ($(VERBOSE),1)
    HIDE =
else
    HIDE = @
endif

# Error handling for make
.DELETE_ON_ERROR:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables --silent

# Find all .s files in current directory
SRC = $(wildcard *.s)
# Generate object file names from source files
OBJS = $(SRC:.s=.o)
# Generate executable names from source files
PROGS = $(SRC:.s=)

# Default target shows help
help:
	@echo "Usage:"
	@echo "  make build FILE=filename  # Build single file (without .s extension)"
	@echo "  make run FILE=filename    # Build and run file (without .s extension)"
	@echo "  make all                  # Build all assembly files"
	@echo "  make list                 # List all available files"
	@echo "  make clean                # Remove all built files"
	@echo ""
	@echo "Options:"
	@echo "  VERBOSE=1                 # Show all commands being executed"

# Function to check file format
define check_file_format
	@if [ ! -z "$$(tail -c1 $(1))" ]; then \
		echo "Error: $(1) is missing a newline at end of file"; \
		exit 1; \
	fi
endef

# Error handler function
define handle_error
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(1)"; \
		exit 1; \
	fi
endef

# Build single file
build:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify FILE=filename (without .s)"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE).s" ]; then \
		echo "Error: $(FILE).s does not exist"; \
		exit 1; \
	fi
	@if [ ! -s "$(FILE).s" ]; then \
		echo "Error: $(FILE).s is empty"; \
		exit 1; \
	fi
	$(call check_file_format,$(FILE).s)
	@if ! grep -q "\.text" "$(FILE).s" || ! grep -q "_start\|main:" "$(FILE).s"; then \
		echo "Error: $(FILE).s is missing basic assembly structure (.text section and entry point)"; \
		exit 1; \
	fi
	@echo "Assembling $(FILE).s..."
	$(HIDE)$(AS) $(ASFLAGS) -o $(FILE).o $(FILE).s 2> $(FILE).err
	@if [ -s $(FILE).err ]; then \
		echo "Assembly errors in $(FILE).s:"; \
		cat $(FILE).err; \
		rm -f $(FILE).err; \
		exit 1; \
	fi
	$(HIDE)rm -f $(FILE).err
	@echo "Linking $(FILE).o..."
	$(HIDE)$(LD) $(LDFLAGS) -o $(FILE) $(FILE).o 2> $(FILE).err
	@if [ -s $(FILE).err ]; then \
		echo "Linking errors in $(FILE):"; \
		cat $(FILE).err; \
		rm -f $(FILE).err; \
		exit 1; \
	fi
	$(HIDE)rm -f $(FILE).err
	@echo "Built $(FILE) successfully"

# Run single file with error handling
run: build
	@echo "Running $(FILE):"
	$(HIDE)timeout 10s ./$(FILE); \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 124 ]; then \
		echo "Error: Program timed out (exceeded 10 seconds)"; \
		exit 1; \
	elif [ $$EXIT_CODE -ne 0 ]; then \
		echo "Error: Program terminated with exit code $$EXIT_CODE"; \
		exit 1; \
	fi

# Build all files
all: $(PROGS)
	@echo "Built all files successfully"
	$(call handle_error,"Failed to build all files")

# Link rule with error handling
%: %.o
	@echo "Linking $@..."
	$(HIDE)$(LD) $(LDFLAGS) -o $@ $< 2> $@.err
	@if [ -s $@.err ]; then \
		echo "Linking errors in $@:"; \
		cat $@.err; \
		rm -f $@.err; \
		exit 1; \
	fi
	$(HIDE)rm -f $@.err
	$(call handle_error,"Failed to link $@")

# Assemble rule with error handling
%.o: %.s
	@if [ ! -s $< ]; then \
		echo "Error: $< is empty"; \
		exit 1; \
	fi
	$(call check_file_format,$<)
	@if ! grep -q "\.text" $< || ! grep -q "_start\|main:" $<; then \
		echo "Error: $< is missing basic assembly structure (.text section and entry point)"; \
		exit 1; \
	fi
	@echo "Assembling $<..."
	$(HIDE)$(AS) $(ASFLAGS) -o $@ $< 2> $@.err
	@if [ -s $@.err ]; then \
		echo "Assembly errors in $<:"; \
		cat $@.err; \
		rm -f $@.err; \
		exit 1; \
	fi
	$(HIDE)rm -f $@.err
	$(call handle_error,"Failed to assemble $<")

# Clean all generated files
clean:
	@echo "Cleaning up..."
	$(HIDE)rm -f $(PROGS) $(OBJS) *.err
	$(call handle_error,"Failed to clean files")

# List all targets
list:
	@echo "Available files:"
	@echo $(SRC) | tr ' ' '\n' | sed 's/\.s$$//'
	$(call handle_error,"Failed to list files")

# Catch-all for undefined targets
%:
	@echo "Error: Unknown target '$@'"
	@echo "Use 'make help' to see available commands"
	@exit 1

.PHONY: all clean list help build run
