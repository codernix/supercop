##########################################################################################
#	Assembler implementation of one round of Cheetah-512					
#	Author: Ivica Nikolic, University of Luxembourg					
##########################################################################################

.section .text
.type Cheetah51264, @function
.globl Cheetah51264
Cheetah51264:

  # Save the registers
  push %rbx
  push %rbp
  push %rdi
  push %rsi
  push %rsp
  push %r12
  push %r13
  push %r14
  push %r15

  # Save the address of the 8x32 tables
  movq %rdi,tbl32

  # The register rbp holds the begining of the 8-64 lookup tables.
  movq %rsi,%rbp
  movq %rsi,tbl64

  # Save the state addresses
  movq %rdx,statel

  # The register %rsi holds the addres of the message. Save the address of the current message array.
  movq %rcx,message
  movq %rcx,%rsi

  # Save the length of the message
  movq %r8,length

  # Set up the block counter
  movq $0,blccntr




start128:

  movq tbl64,%rbp
  movq message,%rsi



  # First produce the message expanstion (with 8x16) and write it into the memory.
  # The registers XMM0-XMM7, r8-r15 hold the 8x16 state

################################################################# FIRST ROUND 8x16 #########################################

  ############################################# s0 ######################################
  # Put (message+0) into rax
  movq (%rsi),%rax
  # Get (message+0)&0xff
  movzbl %al,%ecx
  # Put s8=Tb3((message+0) & 0xff)
  movq	6144(%rbp,%rcx,8),%r8
  # Get ((message+0)>>8)&0xff
  movzbl %ah,%ebx
  # Put s9=Tb2( ((message+0)>>8)&0xff )
  movq  4096(%rbp,%rbx,8),%r9
  # Get ((message+0)>>16)&0xff
  shr $16,%rax
  movzbl %al,%ecx
  # Put s10=Tb1( ((message+0)>>16)&0xff )
  movq	2048(%rbp,%rcx,8),%r10
  # Get ((message+0)>>24)&0xff
  movzbl %ah,%ebx
  # Put s11=Tb0( ((message+0)>>24)&0xff )
  movq  (%rbp,%rbx,8),%r11
  # Get ((message+0)>>32)&0xff
  shr $16,%rax
  movzbl %al,%ecx
  # Put s13=Tb7( ((message+0)>>32)&0xff )
  movq	14336(%rbp,%rcx,8),%r13
  # Get ((message+0)>>40)&0xff
  movzbl %ah,%ebx
  # Put s14=Tb6( ((message+0)>>40)&0xff )
  movq  12288(%rbp,%rbx,8),%r14
  # Get ((message+0)>>48)&0xff
  shr $16,%rax
  movzbl %al,%ecx
  # Put s15=Tb5( ((message+0)>>48)&0xff )
  movq	10240(%rbp,%rcx,8),%r15
  # Get ((message+0)>>56)&0xff
  movzbl %ah,%ebx
  # Put s0=Tb6( ((message+0)>>56)&0xff )
  movq  8192(%rbp,%rbx,8),%xmm0

  movq const1,%xmm8
  pxor %xmm8,%xmm0

  ############################################# s1 ######################################
  # Put (message+8) into rax
  movq 8(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r15
  shr $16,%rax
  movzbl %al,%ecx
  # xor with xmm0
  movq	10240(%rbp,%rcx,8),%xmm8
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm1
  pxor %xmm8,%xmm0

  ############################################# s2 ######################################
  # Put (message+16) into rax
  movq 16(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm9
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm2
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1


  ############################################# s3 ######################################
  # Put (message+24) into rax
  movq 24(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r14
  shr $16,%rax
  #xor with xmm0
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm10
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm3
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2

 ############################################# s4 ######################################
  movq 32(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r15
  shr $16,%rax
  #xor with xmm1
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm11
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm4
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3


 ############################################# s5 ######################################
  movq 40(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm8
  shr $16,%rax
  #xor with xmm2
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm12
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm5
  pxor %xmm8,%xmm0
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4

 ############################################# s6 ######################################
  movq 48(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r15
  # xor with xmm0
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm9
  shr $16,%rax
  #xor with xmm3
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm13
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm6
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5

 ############################################# s7 ######################################
  movq 56(%rsi),%rax

  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm10
  shr $16,%rax
  #xor with xmm4
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm14
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm7
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s8 ######################################
  movq 64(%rsi),%rax

  # xor with xmm0
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm11
  shr $16,%rax
  #xor with xmm5
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r8
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s9 ######################################
  movq 72(%rsi),%rax

  # xor with xmm1
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm12
  shr $16,%rax
  #xor with xmm6
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r9
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s10 ######################################
  movq 80(%rsi),%rax

  # xor with xmm2
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm13
  shr $16,%rax
  #xor with xmm7
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r10
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm15,%xmm7

 ############################################# s11 ######################################
  movq 88(%rsi),%rax

  # xor with xmm3
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r11
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s12 ######################################
  movq 96(%rsi),%rax

  # xor with xmm4
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r12
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s13 ######################################
  movq 104(%rsi),%rax

  # xor with xmm5
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r13
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s14 ######################################
  movq 112(%rsi),%rax

  # xor with xmm6
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r14
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s15 ######################################
  movq 120(%rsi),%rax

  # xor with xmm7
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r15
  pxor %xmm15,%xmm7

  # Save the values of the state
  movq $expnd,%rdi
  movq %r8,64(%rdi)
  movq %xmm0,(%rdi)
  movq %r9,72(%rdi)
  movq %xmm1,8(%rdi)
  movq %r10,80(%rdi)
  movq %xmm2,16(%rdi)
  movq %r11,88(%rdi)
  movq %xmm3,24(%rdi)
  movq %r12,96(%rdi)
  movq %xmm4,32(%rdi)
  movq %r13,104(%rdi)
  movq %xmm5,40(%rdi)
  movq %r14,112(%rdi)
  movq %xmm6,48(%rdi)
  movq %r15,120(%rdi)
  movq %xmm7,56(%rdi)

############################################################################################################################

################################################################# SECOND ROUND 8x16 ###########################################################

  # The register %rsi holds the addres of the previous state
  movq %rdi,%rsi

  ############################################# s0 ######################################
  movq (%rsi),%rax
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%r15
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm0

  movq const2,%xmm8
  pxor %xmm8,%xmm0

  ############################################# s1 ######################################
  movq 8(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r15
  shr $16,%rax
  movzbl %al,%ecx
  # xor with xmm0
  movq	10240(%rbp,%rcx,8),%xmm8
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm1
  pxor %xmm8,%xmm0

  ############################################# s2 ######################################
  movq 16(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm9
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm2
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1


  ############################################# s3 ######################################
  movq 24(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r14
  shr $16,%rax
  #xor with xmm0
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm10
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm3
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2

 ############################################# s4 ######################################
  movq 32(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r15
  shr $16,%rax
  #xor with xmm1
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm11
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm4
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3


 ############################################# s5 ######################################
  movq 40(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm8
  shr $16,%rax
  #xor with xmm2
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm12
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm5
  pxor %xmm8,%xmm0
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4

 ############################################# s6 ######################################
  movq 48(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r15
  # xor with xmm0
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm9
  shr $16,%rax
  #xor with xmm3
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm13
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm6
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5

 ############################################# s7 ######################################
  movq 56(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm10
  shr $16,%rax
  #xor with xmm4
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm14
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm7
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s8 ######################################
  movq 64(%rsi),%rax
  # xor with xmm0
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm11
  shr $16,%rax
  #xor with xmm5
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r8
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s9 ######################################
  movq 72(%rsi),%rax
  # xor with xmm1
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm12
  shr $16,%rax
  #xor with xmm6
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r9
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s10 ######################################
  movq 80(%rsi),%rax
  # xor with xmm2
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm13
  shr $16,%rax
  #xor with xmm7
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r10
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm15,%xmm7

 ############################################# s11 ######################################
  movq 88(%rsi),%rax
  # xor with xmm3
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r11
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s12 ######################################
  movq 96(%rsi),%rax
  # xor with xmm4
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r12
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s13 ######################################
  movq 104(%rsi),%rax
  # xor with xmm5
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r13
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s14 ######################################
  movq 112(%rsi),%rax
  # xor with xmm6
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r14
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s15 ######################################
  movq 120(%rsi),%rax
  # xor with xmm7
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r15
  pxor %xmm15,%xmm7


  # Save the values of the state
  movq %rsi,%rdi
  add $128,%rdi
  movq %r8,64(%rdi)
  movq %xmm0,(%rdi)
  movq %r9,72(%rdi)
  movq %xmm1,8(%rdi)
  movq %r10,80(%rdi)
  movq %xmm2,16(%rdi)
  movq %r11,88(%rdi)
  movq %xmm3,24(%rdi)
  movq %r12,96(%rdi)
  movq %xmm4,32(%rdi)
  movq %r13,104(%rdi)
  movq %xmm5,40(%rdi)
  movq %r14,112(%rdi)
  movq %xmm6,48(%rdi)
  movq %r15,120(%rdi)
  movq %xmm7,56(%rdi)

############################################################################################################################

################################################################# THIRD ROUND 8x16 ##########################################

  # The register %rsi holds the addres of the previous state
  movq %rdi,%rsi

  ############################################# s0 ######################################
  movq (%rsi),%rax
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%r15
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm0

  movq const3,%xmm8
  pxor %xmm8,%xmm0

  ############################################# s1 ######################################
  movq 8(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r15
  shr $16,%rax
  movzbl %al,%ecx
  # xor with xmm0
  movq	10240(%rbp,%rcx,8),%xmm8
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm1
  pxor %xmm8,%xmm0

  ############################################# s2 ######################################
  movq 16(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm9
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm2
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1


  ############################################# s3 ######################################
  movq 24(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r14
  shr $16,%rax
  #xor with xmm0
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm10
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm3
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2

 ############################################# s4 ######################################
  movq 32(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r15
  shr $16,%rax
  #xor with xmm1
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm11
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm4
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3


 ############################################# s5 ######################################
  movq 40(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm8
  shr $16,%rax
  #xor with xmm2
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm12
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm5
  pxor %xmm8,%xmm0
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4

 ############################################# s6 ######################################
  movq 48(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r15
  # xor with xmm0
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm9
  shr $16,%rax
  #xor with xmm3
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm13
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm6
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5

 ############################################# s7 ######################################
  movq 56(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm10
  shr $16,%rax
  #xor with xmm4
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm14
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm7
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s8 ######################################
  movq 64(%rsi),%rax
  # xor with xmm0
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm11
  shr $16,%rax
  #xor with xmm5
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r8
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s9 ######################################
  movq 72(%rsi),%rax
  # xor with xmm1
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm12
  shr $16,%rax
  #xor with xmm6
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r9
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s10 ######################################
  movq 80(%rsi),%rax
  # xor with xmm2
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm13
  shr $16,%rax
  #xor with xmm7
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r10
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm15,%xmm7

 ############################################# s11 ######################################
  movq 88(%rsi),%rax
  # xor with xmm3
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r11
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s12 ######################################
  movq 96(%rsi),%rax
  # xor with xmm4
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r12
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s13 ######################################
  movq 104(%rsi),%rax
  # xor with xmm5
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r13
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s14 ######################################
  movq 112(%rsi),%rax
  # xor with xmm6
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r14
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s15 ######################################
  movq 120(%rsi),%rax
  # xor with xmm7
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r15
  pxor %xmm15,%xmm7


  # Save the values of the state
  movq %rsi,%rdi
  add $128,%rdi
  movq %r8,64(%rdi)
  movq %xmm0,(%rdi)
  movq %r9,72(%rdi)
  movq %xmm1,8(%rdi)
  movq %r10,80(%rdi)
  movq %xmm2,16(%rdi)
  movq %r11,88(%rdi)
  movq %xmm3,24(%rdi)
  movq %r12,96(%rdi)
  movq %xmm4,32(%rdi)
  movq %r13,104(%rdi)
  movq %xmm5,40(%rdi)
  movq %r14,112(%rdi)
  movq %xmm6,48(%rdi)
  movq %r15,120(%rdi)
  movq %xmm7,56(%rdi)


################################################################# FOURTH ROUND 8x16 ##########################################

  # The register %rsi holds the addres of the previous state
  movq %rdi,%rsi

  ############################################# s0 ######################################
  movq (%rsi),%rax
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%r15
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm0

  movq const4,%xmm8
  pxor %xmm8,%xmm0

  ############################################# s1 ######################################
  movq 8(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r15
  shr $16,%rax
  movzbl %al,%ecx
  # xor with xmm0
  movq	10240(%rbp,%rcx,8),%xmm8
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm1
  pxor %xmm8,%xmm0

  ############################################# s2 ######################################
  movq 16(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm9
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm2
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1


  ############################################# s3 ######################################
  movq 24(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r14
  shr $16,%rax
  #xor with xmm0
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm10
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm3
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2

 ############################################# s4 ######################################
  movq 32(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r15
  shr $16,%rax
  #xor with xmm1
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm11
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm4
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3


 ############################################# s5 ######################################
  movq 40(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm8
  shr $16,%rax
  #xor with xmm2
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm12
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm5
  pxor %xmm8,%xmm0
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4

 ############################################# s6 ######################################
  movq 48(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r15
  # xor with xmm0
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm9
  shr $16,%rax
  #xor with xmm3
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm13
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm6
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5

 ############################################# s7 ######################################
  movq 56(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm10
  shr $16,%rax
  #xor with xmm4
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm14
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm7
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s8 ######################################
  movq 64(%rsi),%rax
  # xor with xmm0
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm11
  shr $16,%rax
  #xor with xmm5
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r8
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s9 ######################################
  movq 72(%rsi),%rax
  # xor with xmm1
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm12
  shr $16,%rax
  #xor with xmm6
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r9
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s10 ######################################
  movq 80(%rsi),%rax
  # xor with xmm2
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm13
  shr $16,%rax
  #xor with xmm7
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r10
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm15,%xmm7

 ############################################# s11 ######################################
  movq 88(%rsi),%rax
  # xor with xmm3
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r11
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s12 ######################################
  movq 96(%rsi),%rax
  # xor with xmm4
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r12
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s13 ######################################
  movq 104(%rsi),%rax
  # xor with xmm5
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r13
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s14 ######################################
  movq 112(%rsi),%rax
  # xor with xmm6
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r14
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s15 ######################################
  movq 120(%rsi),%rax
  # xor with xmm7
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r15
  pxor %xmm15,%xmm7


  # Save the values of the state
  movq %rsi,%rdi
  add $128,%rdi
  movq %r8,64(%rdi)
  movq %xmm0,(%rdi)
  movq %r9,72(%rdi)
  movq %xmm1,8(%rdi)
  movq %r10,80(%rdi)
  movq %xmm2,16(%rdi)
  movq %r11,88(%rdi)
  movq %xmm3,24(%rdi)
  movq %r12,96(%rdi)
  movq %xmm4,32(%rdi)
  movq %r13,104(%rdi)
  movq %xmm5,40(%rdi)
  movq %r14,112(%rdi)
  movq %xmm6,48(%rdi)
  movq %r15,120(%rdi)
  movq %xmm7,56(%rdi)


################################################################# FIFTH ROUND 8x16 ##########################################

  # The register %rsi holds the addres of the previous state
  movq %rdi,%rsi

  ############################################# s0 ######################################
  movq (%rsi),%rax
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%r15
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm0

  movq const5,%xmm8
  pxor %xmm8,%xmm0

  ############################################# s1 ######################################
  movq 8(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r15
  shr $16,%rax
  movzbl %al,%ecx
  # xor with xmm0
  movq	10240(%rbp,%rcx,8),%xmm8
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm1
  pxor %xmm8,%xmm0

  ############################################# s2 ######################################
  movq 16(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm9
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm2
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1


  ############################################# s3 ######################################
  movq 24(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r14
  shr $16,%rax
  #xor with xmm0
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm10
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm3
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2

 ############################################# s4 ######################################
  movq 32(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r15
  shr $16,%rax
  #xor with xmm1
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm11
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm4
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3


 ############################################# s5 ######################################
  movq 40(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm8
  shr $16,%rax
  #xor with xmm2
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm12
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm5
  pxor %xmm8,%xmm0
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4

 ############################################# s6 ######################################
  movq 48(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r15
  # xor with xmm0
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm9
  shr $16,%rax
  #xor with xmm3
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm13
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm6
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5

 ############################################# s7 ######################################
  movq 56(%rsi),%rax
  movzbl %al,%ecx
  xorq	6144(%rbp,%rcx,8),%r15
  # xor with xmm0
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm8
  # xor with xmm1
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm10
  shr $16,%rax
  #xor with xmm4
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm14
  movzbl %ah,%ebx
  movq  8192(%rbp,%rbx,8),%xmm7
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s8 ######################################
  movq 64(%rsi),%rax
  # xor with xmm0
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm8
  # xor with xmm1
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm9
  # xor with xmm2
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm11
  shr $16,%rax
  #xor with xmm5
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	10240(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r8
  pxor %xmm8,%xmm0
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s9 ######################################
  movq 72(%rsi),%rax
  # xor with xmm1
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm9
  # xor with xmm2
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm10
  # xor with xmm3
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm12
  shr $16,%rax
  #xor with xmm6
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  12288(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r9
  pxor %xmm9,%xmm1
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s10 ######################################
  movq 80(%rsi),%rax
  # xor with xmm2
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm10
  # xor with xmm3
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm11
  # xor with xmm4
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm13
  shr $16,%rax
  #xor with xmm7
  movzbl %al,%ecx
  movq	14336(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r10
  pxor %xmm10,%xmm2
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm15,%xmm7

 ############################################# s11 ######################################
  movq 88(%rsi),%rax
  # xor with xmm3
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm11
  # xor with xmm4
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm12
  # xor with xmm5
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm14
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r11
  pxor %xmm11,%xmm3
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6

 ############################################# s12 ######################################
  movq 96(%rsi),%rax
  # xor with xmm4
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm12
  # xor with xmm5
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm13
  # xor with xmm6
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  (%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r12
  pxor %xmm12,%xmm4
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s13 ######################################
  movq 104(%rsi),%rax
  # xor with xmm5
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm13
  # xor with xmm6
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm14
  # xor with xmm7
  shr $16,%rax
  movzbl %al,%ecx
  movq	2048(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r10
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r11
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r13
  pxor %xmm13,%xmm5
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s14 ######################################
  movq 112(%rsi),%rax
  # xor with xmm6
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm14
  # xor with xmm7
  movzbl %ah,%ebx
  movq  4096(%rbp,%rbx,8),%xmm15
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r8
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r9
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r11
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r12
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r13
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r14
  pxor %xmm14,%xmm6
  pxor %xmm15,%xmm7

 ############################################# s15 ######################################
  movq 120(%rsi),%rax
  # xor with xmm7
  movzbl %al,%ecx
  movq	6144(%rbp,%rcx,8),%xmm15
  movzbl %ah,%ebx
  xorq  4096(%rbp,%rbx,8),%r8
  shr $16,%rax
  movzbl %al,%ecx
  xorq	2048(%rbp,%rcx,8),%r9
  movzbl %ah,%ebx
  xorq  (%rbp,%rbx,8),%r10
  shr $16,%rax
  movzbl %al,%ecx
  xorq	14336(%rbp,%rcx,8),%r12
  movzbl %ah,%ebx
  xorq  12288(%rbp,%rbx,8),%r13
  shr $16,%rax
  movzbl %al,%ecx
  xorq	10240(%rbp,%rcx,8),%r14
  movzbl %ah,%ebx
  xorq  8192(%rbp,%rbx,8),%r15
  pxor %xmm15,%xmm7


  # Save the values of the state
  movq %rsi,%rdi
  add $128,%rdi
  movq %r8,64(%rdi)
  movq %xmm0,(%rdi)
  movq %r9,72(%rdi)
  movq %xmm1,8(%rdi)
  movq %r10,80(%rdi)
  movq %xmm2,16(%rdi)
  movq %r11,88(%rdi)
  movq %xmm3,24(%rdi)
  movq %r12,96(%rdi)
  movq %xmm4,32(%rdi)
  movq %r13,104(%rdi)
  movq %xmm5,40(%rdi)
  movq %r14,112(%rdi)
  movq %xmm6,48(%rdi)
  movq %r15,120(%rdi)
  movq %xmm7,56(%rdi)



############################################## START OF THE SECOND PHASE - 8X8 RIJNDAEL ###########################################

  # The registers r8-r15 hold the state
  # The register rbp holds the begining of the 8-32 lookup tables.
  movq tbl64,%rbp


  # Add the block counter
  #movq $0,blccntr
  movq blccntr,%rdx
  movq statel,%rsi
  xorq %rdx,(%rsi)
  addq $1,%rdx
  movq %rdx,blccntr

############################################################## 1 ###############################################################

  movq message,%rdi
  movq statel,%rsi
  movq (%rdi),%rax
  xorq (%rsi),%rax
  movq 8(%rdi),%rbx
  xorq 8(%rsi),%rbx
  movq 16(%rdi),%rcx
  xorq 16(%rsi),%rcx
  movq 24(%rdi),%rdx
  xorq 24(%rsi),%rdx

  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq message,%rdi
  movq statel,%rsi
  movq 32(%rdi),%rax
  xorq 32(%rsi),%rax
  movq 40(%rdi),%rbx
  xorq 40(%rsi),%rbx
  movq 48(%rdi),%rcx
  xorq 48(%rsi),%rcx
  movq 56(%rdi),%rdx
  xorq 56(%rsi),%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 1-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq message,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15

   # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 2-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 0(%rdi),%rax
  xorq 8(%rdi),%rbx
  xorq 16(%rdi),%rcx
  xorq 24(%rdi),%rdx

  movq 32(%rdi),%xmm8
  movq 40(%rdi),%xmm9
  movq 48(%rdi),%xmm10
  movq 56(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15


   # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 3-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15

  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15



############################################################ 4-st ROUND #################################################


  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $128,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 0(%rdi),%rax
  xorq 8(%rdi),%rbx
  xorq 16(%rdi),%rcx
  xorq 24(%rdi),%rdx

  movq 32(%rdi),%xmm8
  movq 40(%rdi),%xmm9
  movq 48(%rdi),%xmm10
  movq 56(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15

  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15

############################################################ 5-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $128,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15


  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15




############################################################ 6-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $256,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 0(%rdi),%rax
  xorq 8(%rdi),%rbx
  xorq 16(%rdi),%rcx
  xorq 24(%rdi),%rdx

  movq 32(%rdi),%xmm8
  movq 40(%rdi),%xmm9
  movq 48(%rdi),%xmm10
  movq 56(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15



  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 7-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $256,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15

    # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 8-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $384,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 0(%rdi),%rax
  xorq 8(%rdi),%rbx
  xorq 16(%rdi),%rcx
  xorq 24(%rdi),%rdx

  movq 32(%rdi),%xmm8
  movq 40(%rdi),%xmm9
  movq 48(%rdi),%xmm10
  movq 56(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15

    # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 9-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $384,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15


  # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 10-st ROUND #################################################

  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $512,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 0(%rdi),%rax
  xorq 8(%rdi),%rbx
  xorq 16(%rdi),%rcx
  xorq 24(%rdi),%rdx

  movq 32(%rdi),%xmm8
  movq 40(%rdi),%xmm9
  movq 48(%rdi),%xmm10
  movq 56(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15


    # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15


############################################################ 11-st ROUND #################################################


  # Save the previous state with feedforward from the message expansion
  movq $expnd,%rdi
  add $512,%rdi
  mov %r8,%rax
  mov %r9,%rbx
  mov %r10,%rcx
  mov %r11,%rdx
  xorq 64(%rdi),%rax
  xorq 72(%rdi),%rbx
  xorq 80(%rdi),%rcx
  xorq 88(%rdi),%rdx

  movq 96(%rdi),%xmm8
  movq 104(%rdi),%xmm9
  movq 112(%rdi),%xmm10
  movq 120(%rdi),%xmm11
  movq %r12,%xmm12
  movq %r13,%xmm13
  movq %r14,%xmm14
  movq %r15,%xmm15
  pxor %xmm8,%xmm12
  pxor %xmm9,%xmm13
  pxor %xmm10,%xmm14
  pxor %xmm11,%xmm15


   # One round of AES-256
  movzbl %al,%esi
  movq 14336(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  movq 12288(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  movq 10240(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  movq 8192(%rbp,%rdi,8),%r12
  shr $16, %rax
  movzbl %al,%esi
  movq 6144(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  movq 4096(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  movq 2048(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  movq (%rbp,%rdi,8),%r8

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r13
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r9

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r14
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r10

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r15
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r11

  movq %xmm12,%rax
  movq %xmm13,%rbx
  movq %xmm14,%rcx
  movq %xmm15,%rdx

  movzbl %al,%esi
  xorq 14336(%rbp,%rsi,8),%r13
  movzbl %ah,%edi
  xorq 12288(%rbp,%rdi,8),%r14
  shr $16, %rax
  movzbl %al,%esi
  xorq 10240(%rbp,%rsi,8),%r15
  movzbl %ah,%edi
  xorq 8192(%rbp,%rdi,8),%r8
  shr $16, %rax
  movzbl %al,%esi
  xorq 6144(%rbp,%rsi,8),%r9
  movzbl %ah,%edi
  xorq 4096(%rbp,%rdi,8),%r10
  shr $16, %rax
  movzbl %al,%esi
  xorq 2048(%rbp,%rsi,8),%r11
  movzbl %ah,%edi
  xorq (%rbp,%rdi,8),%r12

  movzbl %bl,%esi
  xorq 14336(%rbp,%rsi,8),%r14
  movzbl %bh,%edi
  xorq 12288(%rbp,%rdi,8),%r15
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 10240(%rbp,%rsi,8),%r8
  movzbl %bh,%edi
  xorq 8192(%rbp,%rdi,8),%r9
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 6144(%rbp,%rsi,8),%r10
  movzbl %bh,%edi
  xorq 4096(%rbp,%rdi,8),%r11
  shr $16, %rbx
  movzbl %bl,%esi
  xorq 2048(%rbp,%rsi,8),%r12
  movzbl %bh,%edi
  xorq (%rbp,%rdi,8),%r13

  movzbl %cl,%esi
  xorq 14336(%rbp,%rsi,8),%r15
  movzbl %ch,%edi
  xorq 12288(%rbp,%rdi,8),%r8
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 10240(%rbp,%rsi,8),%r9
  movzbl %ch,%edi
  xorq 8192(%rbp,%rdi,8),%r10
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 6144(%rbp,%rsi,8),%r11
  movzbl %ch,%edi
  xorq 4096(%rbp,%rdi,8),%r12
  shr $16, %rcx
  movzbl %cl,%esi
  xorq 2048(%rbp,%rsi,8),%r13
  movzbl %ch,%edi
  xorq (%rbp,%rdi,8),%r14

  movzbl %dl,%esi
  xorq 14336(%rbp,%rsi,8),%r8
  movzbl %dh,%edi
  xorq 12288(%rbp,%rdi,8),%r9
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 10240(%rbp,%rsi,8),%r10
  movzbl %dh,%edi
  xorq 8192(%rbp,%rdi,8),%r11
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 6144(%rbp,%rsi,8),%r12
  movzbl %dh,%edi
  xorq 4096(%rbp,%rdi,8),%r13
  shr $16, %rdx
  movzbl %dl,%esi
  xorq 2048(%rbp,%rsi,8),%r14
  movzbl %dh,%edi
  xorq (%rbp,%rdi,8),%r15



############################################################ 12-st ROUND #################################################



  # Feedforward
  movq statel,%rdi
  xorq %r8,(%rdi)
  xorq %r9,8(%rdi)
  xorq %r10,16(%rdi)
  xorq %r11,24(%rdi)
  xorq %r12,32(%rdi)
  xorq %r13,40(%rdi)
  xorq %r14,48(%rdi)
  xorq %r15,56(%rdi)



  movq message,%rcx
  add $128,%rcx
  movq %rcx, message
  movq length,%rax
  sub $128,%rax
  cmp $127,%rax
  movq %rax,length
  ja start128






  # Pop the old values for the registers
  pop %r15
  pop %r14
  pop %r13
  pop %r12
  pop %rsp
  pop %rsi
  pop %rdi
  pop %rbp
  pop %rbx



  ret


.section .data

message:
    .quad 0x0
length:
    .quad 0x0
statel:
    .quad 0x0
tbl32:
    .quad 0x0
tbl64:
    .quad 0x0
expnd:
    .fill 1024
blccntr:
    .quad 0x0
const1:
    .quad 0xf26b6fc500000000
const2:
    .quad 0x3001672b00000000
const3:
    .quad 0xfed7ab7600000000
const4:
    .quad 0xca82c97d00000000
const5:
    .quad 0xfa5947f000000000
core4:
    .quad 0x0
core5:
    .quad 0x0
core6:
    .quad 0x0
core7:
    .quad 0x
.section	.note.GNU-stack,"",@progbits
