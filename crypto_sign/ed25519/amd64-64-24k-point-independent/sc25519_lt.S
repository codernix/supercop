.text
.p2align 5
.globl _CRYPTO_NAMESPACE(sc25519_lt)
.globl CRYPTO_NAMESPACE(sc25519_lt)
_CRYPTO_NAMESPACE(sc25519_lt):
CRYPTO_NAMESPACE(sc25519_lt):
mov %rsp,%r11
and $31,%r11
add $0,%r11
sub %r11,%rsp
movq   0(%rdi),%rdx
movq   8(%rdi),%rcx
movq   16(%rdi),%r8
movq   24(%rdi),%rdi
subq 0(%rsi),%rdx
sbbq 8(%rsi),%rcx
sbbq 16(%rsi),%r8
sbbq 24(%rsi),%rdi
mov  $0,%rdi
mov  $1,%rsi
cmovc %rsi,%rdi
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret

.type _CRYPTO_NAMESPACE(sc25519_lt), @function
.size _CRYPTO_NAMESPACE(sc25519_lt), . - _CRYPTO_NAMESPACE(sc25519_lt)
.type CRYPTO_NAMESPACE(sc25519_lt), @function
.size CRYPTO_NAMESPACE(sc25519_lt), . - CRYPTO_NAMESPACE(sc25519_lt)

.section	.note.GNU-stack,"",@progbits