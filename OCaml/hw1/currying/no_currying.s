	.file ""
	.data
	.globl	_camlNo_currying__data_begin
_camlNo_currying__data_begin:
	.text
	.globl	_camlNo_currying__code_begin
_camlNo_currying__code_begin:
	nop
	.data
	.align	3
	.quad	1792
	.globl	_camlNo_currying
_camlNo_currying:
	.quad	1
	.data
	.align	3
	.globl	_camlNo_currying__gc_roots
_camlNo_currying__gc_roots:
	.quad	_camlNo_currying
	.quad	0
	.text
	.align	4
	.globl	_camlNo_currying__plus_80
_camlNo_currying__plus_80:
	.cfi_startproc
L100:
	leaq	-1(%rax,%rbx), %rax
	ret
	.cfi_endproc
	.data
	.align	3
	.quad	4087
_camlNo_currying__1:
	.quad	_caml_tuplify2
	.quad	-3
	.quad	_camlNo_currying__plus_80
	.text
	.align	4
	.globl	_camlNo_currying__entry
_camlNo_currying__entry:
	.cfi_startproc
L101:
	leaq	_camlNo_currying__1(%rip), %rax
	movq	%rax, _camlNo_currying(%rip)
	movq	$1, %rax
	ret
	.cfi_endproc
	.data
	.align	3
	.text
	nop
	.globl	_camlNo_currying__code_end
_camlNo_currying__code_end:
	.data
				/* relocation table start */
	.align	3
				/* relocation table end */
	.data
	.quad	0
	.globl	_camlNo_currying__data_end
_camlNo_currying__data_end:
	.quad	0
	.align	3
	.globl	_camlNo_currying__frametable
_camlNo_currying__frametable:
	.quad	0
