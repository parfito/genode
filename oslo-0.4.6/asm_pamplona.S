/*
 * \brief   ASM fixup functions.
 * \date    2006-10-20
 * \author  Bernhard Kauer <kauer@tudos.org>
 */
/*
 * Copyright (C) 2006,2007,2010  Bernhard Kauer <kauer@tudos.org>
 * Technische Universitaet Dresden, Operating Systems Research Group
 *
 * This file is part of the OSLO package, which is distributed under
 * the  terms  of the  GNU General Public Licence 2.  Please see the
 * COPYING file for details.
 */


.macro	FUNCTION name
	.section .text.\name
	.globl \name
	\name:
.endm

/**
 * Fixup the state of the application processors after skint. This
 * should be done in the linux kernel...
 */
FUNCTION smp_init_start
	.code16

	// Note: we could test here, whether the AP processor also
	// supports SVM, this is currently unneeded since only SVM
	// enabled processors could be on one board

	// enable svm
	mov     $0xc0000080, %ecx
	rdmsr
	or	$0x10, %ah
	wrmsr

	// clear VM_CR
	movl $0xc0010114, %ecx
	rdmsr
	and  $0xf8, %al
	wrmsr


	// enable GIF - the instruction is only recognized in protected mode
	mov	$1, %ax
	lmsw	%ax
	cli
	stgi

	// halt CPU
	hlt
	.code32
	.global smp_init_end
smp_init_end:
