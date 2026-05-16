# pr (C) Copyright Larry B. Daniel Atlanta, Ga.
# Prayer Rejection

#define MAPRAYER 89
#define REJECT 94

	.data
real:	.quad 0

bang:	.asciz	"!"
dot:	.asciz	"."
title:	.asciz  "Prayer Rejecter\n"
	.set	titlel, .-title

	.file "pr.s"
	
	.text
	.global main
main:
        # Set High Priority
        mov     $0,%rdi
        mov     $0,%rsi
        mov     $-20,%rdx
        call    setpriority

        # Title of Program
        mov     $2,%rdi         # fd
        mov     $title,%rsi     # *buf
        mov     $titlel,%edx    # size
        call write
       
        # Reduce Test
        mov     $123,%rax
        call    reduce
        cmp     $6,%rax
        je      first
        call    pdot
        call    pbang
        ret
first:
        call    sched_yield
	call	pdot
	rdrand 	%rax
	jnc	first
	call	reduce
	cmp	$8, %rax
	je	second
	jmp	first

second:
	rdrand 	%rax
	jnc	first
	call	reduce
	cmp	$9, %rax
	je	apply
	jmp	first

apply:
	call	pbang
	movq	$0,real
	movq 	$94,real
	movq 	$0,real
	jmp     first	

reduce:
# if n is 0 then 0
# n = n modulo 9
# if n is 0 then 9
# n
        cmp    $0,%rax
        je     reduced
        mov    $0,%rdx
        mov    $9,%rcx
        div    %rcx
        mov    %rdx,%rax
        cmp    $0,%rax
        jne    reduced
        mov    $9,%rax
reduced: ret

pdot: 
        mov     $2,%rdi         # fd
        mov     $dot,%rsi     # *buf
        mov     $1,%edx    # size
        call write
	ret
	
pbang:
        mov     $2,%rdi         # fd
        mov     $bang,%rsi     # *buf
        mov     $1,%edx    # size
        call write
	ret
	
perfect:
	mov	$496000,%rdi
	call	usleep
	ret	

humble:
	mov	$1100000,%rdi
	call	usleep
	ret
	#.data
	
	.size   main, .-main
        .ident  "GCC: (2023_08_10) 13.3.0"
        .section        .note.GNU-stack,"",@progbits

