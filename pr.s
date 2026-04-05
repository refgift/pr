# pr (C)Copyright Larry B. Daniel Atlanta, Ga.
# Prayer Rejection

#define REJECT 94

#define ABUSEPRAYER 173
#define MISUSEPRAYER 204

	.data
real:	.quad 0

bang:	.ascii	"!"
dot:	.ascii 	"."
one:	.ascii	"1"
two:	.ascii  "2"
three:	.ascii	"3"

title:	.asciz  "Prayer Rejecter\n"
	.set	titlel, .-title

	.file "pr.s"
	
	.text
	.global main
main:
        # Title of Program
        mov     $2,%rdi         # fd
        mov     $title,%rsi     # *buf
        mov     $titlel,%edx    # size
        call write

first:
	call 	pdot
	rdrand	%rax 	
	jnc	first
	call	reduce
	cmp	$1, %rax
	je	second
	call	sched_yield
#	call	pone
	jmp	first

second:
	rdrand 	%rax
	jnc	second
	call	reduce
	cmp	$7, %rax
	je	third
	call	sched_yield
#	call	ptwo
	jmp	second

third:
	rdrand 	%rax
	call	reduce
	cmp	$3, %rax
	je	apply
	call	sched_yield
	call	pthree
	jmp	third

apply:	call	doapply
	jmp	done

done:	call 	sched_yield
	jmp	first

doapply:
	call	pbang
	movq	$0,real
	call	perfect
	movq 	$94,real
	call	humble
	movq 	$0,real
	call	perfect	
	movq	$0,real
	call	perfect
	movq 	$94,real
	call	humble
	movq 	$0,real
	call	perfect	
	movq	$0,real
	call	perfect
	movq 	$94,real
	call	humble
	movq 	$0,real
	call	perfect	
	ret	

reduce:
# if n is 0 then 0
# n = n modulo 9
# if n is 0 then 9
# n
	cmp	$0,%rax
	je	reduced
	mov	$0,%rdx
	mov	$9,%rcx
	div	%rcx
	mov	%rdx,%rax
	cmp 	$0,%rax
	jne	reduced
	mov	$9,%rax
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

pone:	mov	$2,%rdi
	mov	$one,%rsi
	mov	$1,%edx
	call	write
	ret

ptwo:	mov	$2,%rdi
	mov	$two,%rsi
	mov	$1,%edx
	call	write
	ret

pthree:	mov	$3,%rdi
	mov	$three,%rsi
	mov	$1,%edx
	call	write
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

