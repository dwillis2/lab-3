.section .data

prompt1: .ascii "Enter first string: "
prompt1_len = . - prompt1

prompt2: .ascii "Enter second string: "
prompt2_len = . - prompt2

.section .bss
.lcomm input1, 256
.lcomm input2, 256

.section .text
.global _start

_start: 
    #Print prompt 1
    mov $1, %rax
    mov $1, %rdi
    mov $prompt1, %rsi
    mov $prompt1_len, %rdx
    syscall
    mov %rax, %rbx

    #Get input 1
    mov $0, %rax
    mov $0, %rdi
    mov $input1, %rsi
    mov $256, %rdx
    syscall
    mov %rax, %rcx

    #Print prompt 2
    mov $1, %rax
    mov $1, %rdi
    mov $prompt2, %rsi
    mov $prompt2_len, %rdx
    syscall

    #Get input 2
    mov $0, %rax
    mov $0, %rdi
    mov $input2, %rsi
    mov $256, %rdx
    syscall

    #compare lengths
    cmp %rcx, %rbx
    jl input1_loop
    jg input2_loop
    je input1_loop


input1_loop:
    
    mov $0, %r12             
    mov $0, %rdx             

input1_loop_body:
    cmp %rbx, %rdx           
    jge print_len            

    mov $input1, %rsi
    movzbq (%rsi, %rdx, 1), %rax

    mov $input2, %rsi
    movzbq (%rsi, %rdx, 1), %r8   

    xor %r8, %rax
    popcnt %rax, %rax
    add %rax, %r12

    inc %rdx                 
    jmp input1_loop_body

input2_loop:
    
    mov $0, %r12             
    mov $0, %rdx             

input2_loop_body:
    cmp %rcx, %rdx           
    jge print_len            

    mov $input1, %rsi
    movzbq (%rsi, %rdx, 1), %rax

    mov $input2, %rsi
    movzbq (%rsi, %rdx, 1), %r8

    xor %r8, %rax
    popcnt %rax, %rax
    add %rax, %r12

    inc %rdx                 
    jmp input2_loop_body

print_len: 
    mov %r12, %rax              
    dec %rsi
    movb $10, (%rsi)            

    mov $10, %r10           
    mov $1, %rcx                

convert_loop:
    mov $0, %rdx                
    div %rbx                    

    add $'0', %dl              
    dec %rsi                    
    movb %dl, (%rsi)            
    inc %rcx                    

    cmp $0, %rax                
    jne convert_loop            

   
    mov $1, %rax                
    mov $1, %rdi               
    
    mov %rcx, %rdx              
    syscall

    mov $60, %rax # exit
    mov $0, %rdi # status
    syscall
