	.arch armv8-a
	.file	"test_prog.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"Writer: shared_data set to %d\n"
	.align	3
.LC1:
	.string	"Writer: flag set to 1 (release)"
	.text
	.align	2
	.p2align 4,,11
	.global	writer_thread
	.type	writer_thread, %function
writer_thread:
.LFB52:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	w0, 1
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	bl	sleep
	adrp	x0, .LANCHOR0
	mov	w2, 42
	add	x19, x0, :lo12:.LANCHOR0
	adrp	x1, .LC0
	str	w2, [x0, #:lo12:.LANCHOR0]
	add	x1, x1, :lo12:.LC0
	mov	w0, 2
	bl	__printf_chk
	mov	w0, 1
	add	x19, x19, 4
	stlr	w0, [x19]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
	ldr	x19, [sp, 16]
	mov	x0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE52:
	.size	writer_thread, .-writer_thread
	.section	.rodata.str1.8
	.align	3
.LC2:
	.string	"Reader: detected flag = 1 (acquire)"
	.align	3
.LC3:
	.string	"Reader: shared_data read as %d\n"
	.text
	.align	2
	.p2align 4,,11
	.global	reader_thread
	.type	reader_thread, %function
reader_thread:
.LFB53:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	adrp	x19, .LANCHOR0
	add	x1, x19, :lo12:.LANCHOR0
	add	x1, x1, 4
	.p2align 3,,7
.L5:
	ldar	w0, [x1]
	cbz	w0, .L5
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	puts
	ldr	w2, [x19, #:lo12:.LANCHOR0]
	adrp	x1, .LC3
	mov	w0, 2
	add	x1, x1, :lo12:.LC3
	bl	__printf_chk
	ldr	x19, [sp, 16]
	mov	x0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE53:
	.size	reader_thread, .-reader_thread
	.section	.rodata.str1.8
	.align	3
.LC4:
	.string	"Failed to create reader thread"
	.align	3
.LC5:
	.string	"Failed to create writer thread"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB54:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	adrp	x2, reader_thread
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x2, x2, :lo12:reader_thread
	stp	x29, x30, [sp, 32]
	mov	x3, 0
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 32
	ldr	x1, [x0]
	str	x1, [sp, 24]
	mov	x1, 0
	add	x0, sp, 16
	bl	pthread_create
	cbnz	w0, .L14
	adrp	x2, writer_thread
	add	x0, sp, 8
	add	x2, x2, :lo12:writer_thread
	mov	x3, 0
	mov	x1, 0
	bl	pthread_create
	cbnz	w0, .L15
	ldr	x0, [sp, 8]
	mov	x1, 0
	bl	pthread_join
	ldr	x0, [sp, 16]
	mov	x1, 0
	bl	pthread_join
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 24]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L16
	ldp	x29, x30, [sp, 32]
	mov	w0, 0
	add	sp, sp, 48
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
.L16:
	.cfi_restore_state
	bl	__stack_chk_fail
.L15:
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	perror
	mov	w0, 1
	bl	exit
.L14:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	perror
	mov	w0, 1
	bl	exit
	.cfi_endproc
.LFE54:
	.size	main, .-main
	.global	flag
	.global	shared_data
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	shared_data, %object
	.size	shared_data, 4
shared_data:
	.zero	4
	.type	flag, %object
	.size	flag, 4
flag:
	.zero	4
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
