BITS 64

global _start

section .data
	NO_ARGUMENTS db 'No arguments supplied'
	NMBER dq 4216742

section .text
	_start:

		xor rcx, rcx
		mov rdx, qword [rsp]

		; _loop_3:
		; 	inc rcx

		; 	lea rax, [rsp + 8 * rcx]
		; 	mov rsi, [rax]

		; 	call _print_string

		; 	cmp rcx, rdx
		; 	jnz _loop_3

		sub rsp, 100

		mov rsi, rsp
		mov rax, 100500

		call _itoa

		call _reverse

		call _print_string

		add rsp, 100

		call _exit

	_reverse:
		push rax
		push rcx
		push rdx
		push rdi
		push rsi

		mov rdi, rsi ; Source string

		xor rax, rax
		xor rcx, rcx
		not rcx
		repne scasb
		not rcx
		dec rcx

		shr rcx, 1
		dec rdi
		dec rdi

		_loop_2:
			mov dl, byte [rsi]
			mov al, byte [rdi]
			mov byte [rsi], al
			mov byte [rdi], dl

			inc rsi
			dec rdi

			cmp rsi, rdi
			jbe _loop_2

		pop rsi
		pop rdi
		pop rdx
		pop rcx
		pop rax

		ret

	; rax -- number
	; rsi -- output string
	_itoa:
		push rax
		push rcx
		push rdx
		push rdi
		push rsi

		mov rcx, 10

		_loop_1:
			mov rdx, 0
			div rcx
			add dl, 0x30
			mov byte [rsi], dl

			inc rsi
			cmp rax, 0
			jnz _loop_1

		mov byte [rsi], 0x00

		pop rsi
		pop rdi
		pop rdx
		pop rcx
		pop rax

		ret

	; rsi -- pointer to string
	_print_string:
		push rax
		push rcx
		push rdx
		push rdi

		mov rdi, rsi ; Source string

		xor rax, rax
		xor rcx, rcx
		not rcx
		repne scasb
		not rcx
		dec rcx

		push rcx

		mov rax, 1   ; Syscall number
		mov rdx, rcx ; String length
		mov rdi, 1   ; fb number (output)
		syscall

		pop rcx

		mov di, word [rsi]
		push di
		mov word [rsi], 0x000a

		mov rax, 1   ; Syscall number
		mov rdx, rcx ; String length
		mov rdi, 1   ; fb number (output)
		mov rdx, 2
		syscall

		pop di
		mov word [rsi], di


		pop rdi
		pop rdx
		pop rcx
		pop rax

		ret

	_exit:

		mov rax, 0x3C
		syscall