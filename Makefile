# Compiler and linker settings
AS = as
LD = ld

# Flags
LDFLAGS = -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc

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
	$(AS) -o $(FILE).o $(FILE).s
	$(LD) $(LDFLAGS) -o $(FILE) $(FILE).o
	@echo "Built $(FILE) successfully"

# Run single file
run: build
	@echo "Running $(FILE):"
	@./$(FILE)

# Build all files
all: $(PROGS)

# Link rule
%: %.o
	$(LD) $(LDFLAGS) -o $@ $<

# Assemble rule
%.o: %.s
	$(AS) -o $@ $<

# Clean all generated files
clean:
	rm -f $(PROGS) $(OBJS)

# List all targets
list:
	@echo "Available files:"
	@echo $(SRC) | tr ' ' '\n' | sed 's/\.s$$//'

.PHONY: all clean list help build run
