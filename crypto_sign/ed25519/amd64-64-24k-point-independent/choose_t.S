
# qhasm: int64 tp
# qhasm: int64 pos
# qhasm: int64 b
# qhasm: int64 basep
# qhasm: input tp
# qhasm: input pos
# qhasm: input b
# qhasm: input basep
# qhasm: int64 mask
# qhasm: int64 u
# qhasm: int64 tysubx0
# qhasm: int64 tysubx1
# qhasm: int64 tysubx2
# qhasm: int64 tysubx3
# qhasm: int64 txaddy0
# qhasm: int64 txaddy1
# qhasm: int64 txaddy2
# qhasm: int64 txaddy3
# qhasm: int64 tt2d0
# qhasm: int64 tt2d1
# qhasm: int64 tt2d2
# qhasm: int64 tt2d3
# qhasm: int64 tt0
# qhasm: int64 tt1
# qhasm: int64 tt2
# qhasm: int64 tt3
# qhasm: int64 subt0
# qhasm: int64 subt1
# qhasm: int64 t
# qhasm: stack64 tp_stack
# qhasm:   int64 caller1
# qhasm:   int64 caller2
# qhasm:   int64 caller3
# qhasm:   int64 caller4
# qhasm:   int64 caller5
# qhasm:   int64 caller6
# qhasm:   int64 caller7
# qhasm:   caller caller1
# qhasm:   caller caller2
# qhasm:   caller caller3
# qhasm:   caller caller4
# qhasm:   caller caller5
# qhasm:   caller caller6
# qhasm:   caller caller7
# qhasm:   stack64 caller1_stack
# qhasm:   stack64 caller2_stack
# qhasm:   stack64 caller3_stack
# qhasm:   stack64 caller4_stack
# qhasm:   stack64 caller5_stack
# qhasm:   stack64 caller6_stack
# qhasm:   stack64 caller7_stack
# qhasm: enter CRYPTO_NAMESPACE(choose_t)
.text
.p2align 5
.globl _CRYPTO_NAMESPACE(choose_t)
.globl CRYPTO_NAMESPACE(choose_t)
_CRYPTO_NAMESPACE(choose_t):
CRYPTO_NAMESPACE(choose_t):
mov %rsp,%r11
and $31,%r11
add $64,%r11
sub %r11,%rsp
movq %r11,0(%rsp)
movq %r12,8(%rsp)
movq %r13,16(%rsp)
movq %r14,24(%rsp)
movq %r15,32(%rsp)
movq %rbx,40(%rsp)
movq %rbp,48(%rsp)
movq %rdi,56(%rsp)
imulq  $768,%rsi,%rdi
mov  %rdx,%rsi
sar  $7,%rsi
mov  %rdx,%r8
add  %rsi,%r8
xor  %rsi,%r8
mov  $1,%rsi
mov  $0,%r9
mov  $0,%rax
mov  $0,%r10
mov  $1,%r11
mov  $0,%r12
mov  $0,%r13
mov  $0,%r14
cmp  $1,%r8
movq   0(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   8(%rcx,%rdi),%r15
cmove %r15,%r9
movq   16(%rcx,%rdi),%r15
cmove %r15,%rax
movq   24(%rcx,%rdi),%r15
cmove %r15,%r10
movq   32(%rcx,%rdi),%r15
cmove %r15,%r11
movq   40(%rcx,%rdi),%r15
cmove %r15,%r12
movq   48(%rcx,%rdi),%r15
cmove %r15,%r13
movq   56(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $2,%r8
movq   96(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   104(%rcx,%rdi),%r15
cmove %r15,%r9
movq   112(%rcx,%rdi),%r15
cmove %r15,%rax
movq   120(%rcx,%rdi),%r15
cmove %r15,%r10
movq   128(%rcx,%rdi),%r15
cmove %r15,%r11
movq   136(%rcx,%rdi),%r15
cmove %r15,%r12
movq   144(%rcx,%rdi),%r15
cmove %r15,%r13
movq   152(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $3,%r8
movq   192(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   200(%rcx,%rdi),%r15
cmove %r15,%r9
movq   208(%rcx,%rdi),%r15
cmove %r15,%rax
movq   216(%rcx,%rdi),%r15
cmove %r15,%r10
movq   224(%rcx,%rdi),%r15
cmove %r15,%r11
movq   232(%rcx,%rdi),%r15
cmove %r15,%r12
movq   240(%rcx,%rdi),%r15
cmove %r15,%r13
movq   248(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $4,%r8
movq   288(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   296(%rcx,%rdi),%r15
cmove %r15,%r9
movq   304(%rcx,%rdi),%r15
cmove %r15,%rax
movq   312(%rcx,%rdi),%r15
cmove %r15,%r10
movq   320(%rcx,%rdi),%r15
cmove %r15,%r11
movq   328(%rcx,%rdi),%r15
cmove %r15,%r12
movq   336(%rcx,%rdi),%r15
cmove %r15,%r13
movq   344(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $5,%r8
movq   384(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   392(%rcx,%rdi),%r15
cmove %r15,%r9
movq   400(%rcx,%rdi),%r15
cmove %r15,%rax
movq   408(%rcx,%rdi),%r15
cmove %r15,%r10
movq   416(%rcx,%rdi),%r15
cmove %r15,%r11
movq   424(%rcx,%rdi),%r15
cmove %r15,%r12
movq   432(%rcx,%rdi),%r15
cmove %r15,%r13
movq   440(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $6,%r8
movq   480(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   488(%rcx,%rdi),%r15
cmove %r15,%r9
movq   496(%rcx,%rdi),%r15
cmove %r15,%rax
movq   504(%rcx,%rdi),%r15
cmove %r15,%r10
movq   512(%rcx,%rdi),%r15
cmove %r15,%r11
movq   520(%rcx,%rdi),%r15
cmove %r15,%r12
movq   528(%rcx,%rdi),%r15
cmove %r15,%r13
movq   536(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $7,%r8
movq   576(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   584(%rcx,%rdi),%r15
cmove %r15,%r9
movq   592(%rcx,%rdi),%r15
cmove %r15,%rax
movq   600(%rcx,%rdi),%r15
cmove %r15,%r10
movq   608(%rcx,%rdi),%r15
cmove %r15,%r11
movq   616(%rcx,%rdi),%r15
cmove %r15,%r12
movq   624(%rcx,%rdi),%r15
cmove %r15,%r13
movq   632(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $8,%r8
movq   672(%rcx,%rdi),%r15
cmove %r15,%rsi
movq   680(%rcx,%rdi),%r15
cmove %r15,%r9
movq   688(%rcx,%rdi),%r15
cmove %r15,%rax
movq   696(%rcx,%rdi),%r15
cmove %r15,%r10
movq   704(%rcx,%rdi),%r15
cmove %r15,%r11
movq   712(%rcx,%rdi),%r15
cmove %r15,%r12
movq   720(%rcx,%rdi),%r15
cmove %r15,%r13
movq   728(%rcx,%rdi),%r15
cmove %r15,%r14
cmp  $0,%rdx
mov  %rsi,%r15
cmovl %r11,%rsi
cmovl %r15,%r11
mov  %r9,%r15
cmovl %r12,%r9
cmovl %r15,%r12
mov  %rax,%r15
cmovl %r13,%rax
cmovl %r15,%r13
mov  %r10,%r15
cmovl %r14,%r10
cmovl %r15,%r14
movq 56(%rsp),%r15
movq   %rsi,0(%r15)
movq   %r9,8(%r15)
movq   %rax,16(%r15)
movq   %r10,24(%r15)
movq   %r11,32(%r15)
movq   %r12,40(%r15)
movq   %r13,48(%r15)
movq   %r14,56(%r15)
mov  $0,%rsi
mov  $0,%r9
mov  $0,%rax
mov  $0,%r10
cmp  $1,%r8
movq   64(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   72(%rcx,%rdi),%r11
cmove %r11,%r9
movq   80(%rcx,%rdi),%r11
cmove %r11,%rax
movq   88(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $2,%r8
movq   160(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   168(%rcx,%rdi),%r11
cmove %r11,%r9
movq   176(%rcx,%rdi),%r11
cmove %r11,%rax
movq   184(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $3,%r8
movq   256(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   264(%rcx,%rdi),%r11
cmove %r11,%r9
movq   272(%rcx,%rdi),%r11
cmove %r11,%rax
movq   280(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $4,%r8
movq   352(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   360(%rcx,%rdi),%r11
cmove %r11,%r9
movq   368(%rcx,%rdi),%r11
cmove %r11,%rax
movq   376(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $5,%r8
movq   448(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   456(%rcx,%rdi),%r11
cmove %r11,%r9
movq   464(%rcx,%rdi),%r11
cmove %r11,%rax
movq   472(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $6,%r8
movq   544(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   552(%rcx,%rdi),%r11
cmove %r11,%r9
movq   560(%rcx,%rdi),%r11
cmove %r11,%rax
movq   568(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $7,%r8
movq   640(%rcx,%rdi),%r11
cmove %r11,%rsi
movq   648(%rcx,%rdi),%r11
cmove %r11,%r9
movq   656(%rcx,%rdi),%r11
cmove %r11,%rax
movq   664(%rcx,%rdi),%r11
cmove %r11,%r10
cmp  $8,%r8
movq   736(%rcx,%rdi),%r8
cmove %r8,%rsi
movq   744(%rcx,%rdi),%r8
cmove %r8,%r9
movq   752(%rcx,%rdi),%r8
cmove %r8,%rax
movq   760(%rcx,%rdi),%rdi
cmove %rdi,%r10
mov  $0,%rdi
mov  $0,%rcx
mov  $0,%r8
mov  $0,%r11
sub  %rsi,%rdi
sbb  %r9,%rcx
sbb  %rax,%r8
sbb  %r10,%r11
mov  $0,%r12
mov  $38,%r13
cmovae %r12,%r13
sub  %r13,%rdi
sbb  %r12,%rcx
sbb  %r12,%r8
sbb  %r12,%r11
cmovc %r13,%r12
sub  %r12,%rdi
cmp  $0,%rdx
cmovl %rdi,%rsi
cmovl %rcx,%r9
cmovl %r8,%rax
cmovl %r11,%r10
movq   %rsi,64(%r15)
movq   %r9,72(%r15)
movq   %rax,80(%r15)
movq   %r10,88(%r15)
movq 0(%rsp),%r11
movq 8(%rsp),%r12
movq 16(%rsp),%r13
movq 24(%rsp),%r14
movq 32(%rsp),%r15
movq 40(%rsp),%rbx
movq 48(%rsp),%rbp
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret

.type _CRYPTO_NAMESPACE(choose_t), @function
.size _CRYPTO_NAMESPACE(choose_t), . - _CRYPTO_NAMESPACE(choose_t)
.type CRYPTO_NAMESPACE(choose_t), @function
.size CRYPTO_NAMESPACE(choose_t), . - CRYPTO_NAMESPACE(choose_t)

.section	.note.GNU-stack,"",@progbits