# Compiler and linker settings
GAS = as
NASM = nasm
LD = ld

# Flags
GAS_FLAGS = --fatal-warnings
NASM_FLAGS_32 = -f elf32
NASM_FLAGS_64 = -f elf64

# Linker flags
GAS_LDFLAGS = -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc
NASM_LDFLAGS_32 = -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc
NASM_LDFLAGS_64 = -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc

# Source and target files
GAS_SRC := $(wildcard *.s)
NASM_SRC := $(wildcard *.asm)
GAS_OBJS := $(GAS_SRC:.s=.o)
NASM_OBJS := $(NASM_SRC:.asm=.o)
PROGS := $(GAS_SRC:.s=) $(NASM_SRC:.asm=)

# Default target
.DEFAULT_GOAL := help

# Function to detect bit mode
define detect_gas_mode
	if grep -q "int.*\$$0x80" "$(1)"; then \
		echo "32"; \
	elif grep -q "mov.*%r.*syscall\|syscall.*mov.*%r" "$(1)"; then \
		echo "64"; \
	elif grep -q "syscall" "$(1)"; then \
		echo "Error: 64-bit program must use syscall with 64-bit registers" >&2; \
		exit 1; \
	else \
		echo "32"; \
	fi
endef

define detect_nasm_mode
	if grep -q "mov.*rax.*60\|mov.*eax.*60.*syscall" "$(1)"; then \
		echo "64"; \
	elif grep -q "bits\s\+64\|section\s\+\.text\s\+64" "$(1)"; then \
		if ! grep -q "mov.*rax.*60\|mov.*eax.*60.*syscall" "$(1)"; then \
			echo "Error: 64-bit program must use syscall 60 for exit" >&2; \
			exit 1; \
		fi; \
		echo "64"; \
	elif grep -q "mov.*eax.*1.*int" "$(1)"; then \
		echo "32"; \
	else \
		echo "32"; \
	fi
endef

# Build functions
define build_gas
	mode=$$($(call detect_gas_mode,$(1))); \
	echo "Building $(1) (GAS/AT&T syntax, $$mode-bit)..."; \
	$(GAS) $(GAS_FLAGS) -o $(2).o $(1) && \
	$(LD) $(GAS_LDFLAGS) -o $(2) $(2).o && \
	echo "Build successful: $(2)"
endef

define build_nasm
	mode=$$($(call detect_nasm_mode,$(1))); \
	echo "Building $(1) (NASM/Intel syntax, $$mode-bit)..."; \
	if [ "$$mode" = "64" ]; then \
		$(NASM) $(NASM_FLAGS_64) -o $(2).o $(1) && \
		$(LD) $(NASM_LDFLAGS_64) -o $(2) $(2).o; \
	else \
		$(NASM) $(NASM_FLAGS_32) -o $(2).o $(1) && \
		$(LD) $(NASM_LDFLAGS_32) -o $(2) $(2).o; \
	fi && \
	echo "Build successful: $(2)"
endef

# Build single file
b build:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Specify FILE=name"; \
		exit 1; \
	fi
	@if [ -f "$(FILE).s" ]; then \
		$(call build_gas,$(FILE).s,$(FILE)); \
	elif [ -f "$(FILE).asm" ]; then \
		$(call build_nasm,$(FILE).asm,$(FILE)); \
	else \
		echo "Error: $(FILE).s or $(FILE).asm not found"; \
		exit 1; \
	fi

# Default help
h help:
	@echo "Assembly Build System"
	@echo "Basic Commands:"
	@echo "  make b FILE=name        Build .s or .asm file"
	@echo "  make r FILE=name        Build and run program"
	@echo "  make a                  Build everything"
	@echo "  make c                  Clean build files"
	@echo "  make l                  Show available files"
	@echo ""
	@echo "File Types:"
	@echo "  .s    GAS/AT&T syntax (32/64 bit auto-detect)"
	@echo "  .asm  NASM/Intel syntax (32/64 bit by directive)"
	@echo ""
	@echo "Examples:"
	@echo "  make b FILE=hello       Build hello.s or hello.asm"
	@echo "  make r FILE=test        Run test program"

# Run program
r run: build
	@echo "Running $(FILE)..."
	@echo ""
	@timeout 10s ./$(FILE) || \
	if [ $$? -eq 124 ]; then \
		echo "Error: Timeout (10s)"; \
		exit 1; \
	fi

# Build all files
a all:
	@for file in $(GAS_SRC); do \
		base=$${file%.*}; \
		$(call build_gas,$$file,$$base); \
	done
	@for file in $(NASM_SRC); do \
		base=$${file%.*}; \
		$(call build_nasm,$$file,$$base); \
	done
	@if [ -n "$(GAS_SRC)$(NASM_SRC)" ]; then \
		echo "All builds completed successfully"; \
	else \
		echo "No assembly files found"; \
	fi

# Utility targets
c clean:
	@rm -f $(PROGS) $(GAS_OBJS) $(NASM_OBJS)
	@echo "Cleaned all build files"

l list:
	@echo "GAS files (.s):" && echo "$(GAS_SRC)"
	@echo "NASM files (.asm):" && echo "$(NASM_SRC)"

.PHONY: a all c clean l list h help b build r run
