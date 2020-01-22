#
# Makefile for the OSLO package.
#

ifeq ($(DEBUG),)
CCFLAGS += -Os -DNDEBUG
else
CCFLAGS += -Os -g
endif
VERBOSE = @


checkcc    = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null >/dev/null 2>&1; then echo "$(1)"; fi)
CCFLAGS   += -m32 -std=gnu99 -mregparm=3 -Iinclude/ -W -Wall -ffunction-sections -fstrict-aliasing -fomit-frame-pointer -minline-all-stringops -Winline  --param max-inline-insns-single=50
CCFLAGS	  += $(call checkcc,-fno-stack-protector)
OBJ = asm.o util.o tis.o tpm.o sha.o elf.o mp.o dev.o



.PHONY: all
all: oslo beirut munich pamplona


oslo: osl.ld $(OBJ) osl.o
	$(LD) -gc-sections -N -o $@ -T $^

beirut: beirut.ld $(OBJ) beirut.o
	$(LD) -gc-sections -N -o $@ -T $^

munich: munich.ld $(OBJ) boot_linux.o asm_pamplona.o munich.o
	$(LD) -gc-sections -N -o $@ -T $^

pamplona: beirut.ld $(OBJ) asm_pamplona.o pamplona.o
	$(LD) -gc-sections -N -o $@ -T $^


util.o:  include/asm.h include/util.h
sha.o:   include/asm.h include/util.h include/sha.h
elf.o:   include/asm.h include/util.h include/elf.h
mp.o::   include/asm.h include/util.h include/mp.h
tis.o:   include/asm.h include/util.h include/tis.h
tpm.o:   include/asm.h include/util.h include/tis.h include/tpm.h
osl.o:   include/version.h			    \
	 include/asm.h include/util.h include/sha.h \
	 include/elf.h include/tis.h  include/tpm.h \
	 include/mbi.h include/mp.h   include/osl.h
beirut.o: include/version.h include/asm.h include/util.h include/sha.h \
	  include/elf.h include/tis.h include/tpm.h include/mbi.h

munich.o: include/version.h include/asm.h include/util.h      \
	  include/boot_linux.h include/mbi.h include/elf.h    \
	  include/munich.h

pamplona.o: include/version.h include/asm.h include/util.h    \
	    include/mbi.h include/elf.h include/dev.h         \
	    include/pamplona.h

.PHONY: clean
clean:
	$(VERBOSE) rm -f oslo beirut munich pamplona $(OBJ) osl.o beirut.o munich.o pamplona.o boot_linux.o asm_pamplona.o

%.o: %.c
	$(VERBOSE) $(CC) $(CCFLAGS) -c $<
%.o: %.S
	$(VERBOSE) $(CC) $(CCFLAGS) -c $<
