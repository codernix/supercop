.text
.p2align 5
.globl _CRYPTO_NAMESPACE(sc25519_add)
.globl CRYPTO_NAMESPACE(sc25519_add)
_CRYPTO_NAMESPACE(sc25519_add):
CRYPTO_NAMESPACE(sc25519_add):
mov %rsp,%r11
and $31,%r11
add $32,%r11
sub %r11,%rsp
movq %r14,0(%rsp)
movq %r15,8(%rsp)
movq %rbx,16(%rsp)
movq   0(%rsi),%rcx
movq   8(%rsi),%r8
movq   16(%rsi),%r9
movq   24(%rsi),%rsi
addq 0(%rdx),%rcx
adcq 8(%rdx),%r8
adcq 16(%rdx),%r9
adcq 24(%rdx),%rsi
mov  %rcx,%rdx
mov  %r8,%rax
mov  %r9,%r10
mov  %rsi,%r14
sub  CRYPTO_NAMESPACE(ORDER0)(%rip),%rdx
sbb  CRYPTO_NAMESPACE(ORDER1)(%rip),%rax
sbb  CRYPTO_NAMESPACE(ORDER2)(%rip),%r10
sbb  CRYPTO_NAMESPACE(ORDER3)(%rip),%r14
cmovae %rdx,%rcx
cmovae %rax,%r8
cmovae %r10,%r9
cmovae %r14,%rsi
movq   %rcx,0(%rdi)
movq   %r8,8(%rdi)
movq   %r9,16(%rdi)
movq   %rsi,24(%rdi)
movq 0(%rsp),%r14
movq 8(%rsp),%r15
movq 16(%rsp),%rbx
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret

.type _CRYPTO_NAMESPACE(sc25519_add), @function
.size _CRYPTO_NAMESPACE(sc25519_add), . - _CRYPTO_NAMESPACE(sc25519_add)
.type CRYPTO_NAMESPACE(sc25519_add), @function
.size CRYPTO_NAMESPACE(sc25519_add), . - CRYPTO_NAMESPACE(sc25519_add)

.section	.note.GNU-stack,"",@progbits