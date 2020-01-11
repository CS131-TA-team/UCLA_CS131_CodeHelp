	.file ""
	.data
	.globl	_camlCurrying__data_begin
_camlCurrying__data_begin:
	.text
	.globl	_camlCurrying__code_begin
_camlCurrying__code_begin:
	nop
	.data
	.align	3
	.quad	1792
	.globl	_camlCurrying
_camlCurrying:
	.quad	1
	.data
	.align	3
	.globl	_camlCurrying__gc_roots
_camlCurrying__gc_roots:
	.quad	_camlCurrying
	.quad	0
	.text
	.align	4
	.globl	_camlCurrying__plus_80
_camlCurrying__plus_80:
	.cfi_startproc
L100:
	leaq	-1(%rax,%rbx), %rax
	ret
	.cfi_endproc
	.data
	.align	3
	.quad	4087
_camlCurrying__1:
	.quad	_caml_curry2
	.quad	5
	.quad	_camlCurrying__plus_80
	.text
	.align	4
	.globl	_camlCurrying__entry
_camlCurrying__entry:
	.cfi_startproc
L101:
	leaq	_camlCurrying__1(%rip), %rax
	movq	%rax, _camlCurrying(%rip)
	movq	$1, %rax
	ret
	.cfi_endproc
	.data
	.align	3
	.text
	nop
	.globl	_camlCurrying__code_end
_camlCurrying__code_end:
	.data
				/* relocation table start */
	.align	3
				/* relocation table end */
	.data
	.quad	0
	.globl	_camlCurrying__data_end
_camlCurrying__data_end:
	.quad	0
	.align	3
	.globl	_camlCurrying__frametable
_camlCurrying__frametable:
	.quad	0
