	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 15	sdk_version 10, 15
	.globl	_f                      ## -- Begin function f
	.p2align	4, 0x90
_f:                                     ## @f
	.cfi_startproc
## %bb.0:
	pushq	%rbp   ; Preserve RBP
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp  ; Save Stack Pointer in RBP
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp   ; Allocate memory for guard, i, n, etc. But not including arr
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	%edi, -12(%rbp)  ; Memory for n
	movl	-12(%rbp), %edi
	movl	%edi, %eax
	movq	%rsp, %rcx
	movq	%rcx, -24(%rbp)  ; Preserve modified Stack Pointer
	leaq	15(,%rax,4), %rcx  ; Calculate sizeof(arr) = n * 4
	andq	$-16, %rcx       ; Alignment by 16B
	movq	%rax, -40(%rbp)         ## 8-byte Spill
	movq	%rcx, %rax
	callq	____chkstk_darwin
	subq	%rax, %rsp       ; Allocate memory for arr by RSP -= 4*n
	movq	%rsp, %rax       ; RAX = RSP, which is &a[0]
	movq	-40(%rbp), %rcx         ## 8-byte Reload
	movq	%rcx, -32(%rbp)
	movl	$1, 4(%rax)      ; a[1] = 1
	movl	$1, (%rax)       ; a[0] = 1
	movl	$2, -16(%rbp)    ; i = 2
	movq	%rax, -48(%rbp)         ## 8-byte Spill
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB0_4           ; if i>= n, goto LBB0_4
## %bb.2:                               ##   in Loop: Header=BB0_1 Depth=1
	movl	-16(%rbp), %eax
	subl	$1, %eax
	movslq	%eax, %rcx       ; RCX = i - 1
	movq	-48(%rbp), %rdx         ## 8-byte Reload
	movl	(%rdx,%rcx,4), %eax  ; EAX = *(a+4*RCX)
	movl	-16(%rbp), %esi
	subl	$2, %esi
	movslq	%esi, %rcx           ; RCX = i - 2
	addl	(%rdx,%rcx,4), %eax  ; EAX += *(a+4*RCX)
	movslq	-16(%rbp), %rcx
	movl	%eax, (%rdx,%rcx,4)
## %bb.3:                               ##   in Loop: Header=BB0_1 Depth=1
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)      ; i += 1
	jmp	LBB0_1
LBB0_4:
	movl	-12(%rbp), %eax
	subl	$1, %eax
	movslq	%eax, %rcx          ; RCX = N - 1
	movq	-48(%rbp), %rdx         ## 8-byte Reload
	movl	(%rdx,%rcx,4), %esi ; ESI = *(a+4*RCX)
	leaq	L_.str(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsp
	movq	___stack_chk_guard@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rcx
	movq	-8(%rbp), %rdx
	cmpq	%rdx, %rcx
	movl	%eax, -52(%rbp)         ## 4-byte Spill
	jne	LBB0_6
## %bb.5:
	movq	%rbp, %rsp
	popq	%rbp
	retq
LBB0_6:
	callq	___stack_chk_fail
	ud2
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	leaq	L_.str.1(%rip), %rdi
	leaq	-8(%rbp), %rsi
	movb	$0, %al
	callq	_scanf
	movl	-8(%rbp), %edi
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	callq	_f
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"

L_.str.1:                               ## @.str.1
	.asciz	"%d"


.subsections_via_symbols
