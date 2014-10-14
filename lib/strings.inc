BITS 64

section .text

	; rsi -- pointer to string
	_print_string:
		push rax
		push rcx
		push rdx
		push rdi

		call _strlen

		mov rdx, rax ; String length

		mov byte [rsi + rdx], 0x0a
		inc rdx

		mov rax, 1   ; Syscall number
		mov rdi, 1   ; fb number (output)
					 ; rsi -- string address
		syscall

		dec rdx
		mov byte [rsi + rdx], 0x00

		pop rdi
		pop rdx
		pop rcx
		pop rax

		ret

	; rsi -- pointer to string
	; out rax -- length
	_strlen:
		push rdi
		push rcx

		mov rdi, rsi
		xor rax, rax
		xor rcx, rcx
		not rcx
		repne scasb
		not rcx
		dec rcx

		mov rax, rcx

		pop rcx
		pop rdi

		ret

	; rsi -- first string
	; rdi -- second string
	; out rax -- result
	_strcmp:
		push rsi
		push rdi
		push rdx

		xor rdx, rdx

		.loop:
			lodsb
			cmp al, [rdi]
			jnz _strcmp.fail
			inc rdi
			cmp byte [rsi], 0
			jnz _strcmp.loop
		jmp .success

		.fail:
		inc rdx
		.success:
		xchg rdx, rax

		pop rdx
		pop rdi
		pop rsi

		ret

	; rax -- number
	; rsi -- output string buffer
	_hex:
		push rsi
		push rdi
		push rdx

		.loop:
			mov dl, al
			and dl, 0xF
			cmp dl, 0xa
			jb _hex.digit
			sub dl, 0xa
			add dl, 'a'
			jmp _hex.print

			.digit:
			add dl, '0'

			.print:
			mov [rsi], dl
			inc rsi

			shr rax, 4
			test rax, rax
			jnz _hex.loop

		mov byte [rsi], 'x'
		mov byte [rsi + 1], '0'
		mov byte [rsi + 2], 0x0

		pop rdx
		pop rdi
		pop rsi

		call _reverse

		ret

	; rax -- number
	; rsi -- output string buffer
	_itoa:
		push rax
		push rcx
		push rdx
		push rsi
		push rdi

		mov rcx, 10
		mov rdi, rax

		cqo
		xor rax, rdx
		sub rax, rdx

		.loop:
			cqo
			idiv rcx
			add dl, '0'
			mov byte [rsi], dl

			inc rsi
			cmp rax, 0
			jnz _itoa.loop

		cmp rdi, 0
		jge _itoa.skip_sign
		mov byte [rsi], '-'
		inc rsi

		.skip_sign:
		mov byte [rsi], 0x0

		pop rdi
		pop rsi
		pop rdx
		pop rcx
		pop rax

		call _reverse

		ret

	; rsi -- pointer to string
	; rax -- resulted number
	; rcx -- error
	_atoi:
		push rdx
		push rsi
		push rdi

		mov rdi, 1
		cmp byte [rsi], '-'
		jnz _atoi.skip_sign
		neg rdi
		inc rsi

		.skip_sign:

		xor rax, rax
		xor rcx, rcx

		.loop:
		mov cl, byte [rsi]

		cmp cl, '0'
		jb _atoi.error
		cmp cl, '9'
		ja _atoi.error

		sub cl, '0'

		mov rdx, 10
		mul rdx
		add rax, rcx

		inc rsi
		cmp byte [rsi], 0x0
		jnz _atoi.loop

		cqo
		imul rdi
		xor rcx, rcx
		.exit:

		pop rdi
		pop rsi
		pop rdx

		ret

		.error:
		mov rcx, -1
		jmp _atoi.exit

	; rsi -- pointer to string
	_reverse:
		push rax
		push rdx
		push rdi
		push rsi

		call _strlen

		lea rdi, [rsi + rax - 1]

		.loop:
			mov al, [rsi]
			mov dl, [rdi]
			mov [rsi], dl
			mov [rdi], al

			inc rsi
			dec rdi

			cmp rsi, rdi
			jbe _reverse.loop

		pop rsi
		pop rdi
		pop rdx
		pop rax

		ret