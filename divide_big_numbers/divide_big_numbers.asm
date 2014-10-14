BITS 64

%include "../lib/strings.inc"

global _start

section .data
	ERR_NOT_ENOUGH_ARGUMENTS db 'Not enough arguments supplied', 0x0
	ERR_BAD_FORAMT_NUMBER db 'Failed to parse number: bad format', 0x0
	ERR_NON_POSITIVE_DENOMINTATOR db 'Non positive denominator is not allowed', 0x0

	HELP_MESSAGE db 'Usage: program <really_big_number> <not_so_big_number>', 0x0

section .text
	_start:
		mov rbp, rsp

		mov rdx, qword [rbp] ; argc

		cmp rdx, 3
		jb _not_enough_aruments

		mov rsi, [rbp + 2 * 8 + 8]
		call _atoi

		cmp rax, 0
		jle _non_positive_denominator

		xchg rax, rcx

		mov rsi, [rbp + 1 * 8 + 8]
		call _strlen
		inc rax

		sub rsp, rax
		lea rdi, [rsp]

		xor rax, rax

		.loop:
			mov dl, [rsi]
			inc rsi

			test dl, dl
			jz _start.print_result

			cmp dl, '9'
			ja _bad_format_number
			sub dl, '0'
			jb _bad_format_number

			push rdx
			mov rdx, 10
			mul rdx
			pop rdx
			and rdx, 0xff
			add rax, rdx

			cqo
			div rcx
			xchg rdx, rax

			add dl, '0'
			mov [rdi], dl
			inc rdi

			jmp _start.loop

		.print_result:
		mov byte [rdi], 0x0

		mov rsi, [rbp + 1 * 8 + 8]
		call _strlen
		inc rax

		lea rdi, [rsp]
		.loop2:
			cmp byte [rdi], '0'
			jnz _start.finish
			cmp rax, 2
			jbe _start.finish
			inc rdi
			dec rax
			jmp _start.loop2

		.finish:
		xchg rdi, rsi
		call _print_string

		mov  rsp, rbp
		call _exit

	_non_positive_denominator:
		mov rsi, ERR_NON_POSITIVE_DENOMINTATOR
		call _print_string
		mov rsi, HELP_MESSAGE
		call _print_string
		call _exit

	_not_enough_aruments:
		mov rsi, ERR_NOT_ENOUGH_ARGUMENTS
		call _print_string
		mov rsi, HELP_MESSAGE
		call _print_string
		call _exit

	_bad_format_number:
		mov rsi, ERR_BAD_FORAMT_NUMBER
		call _print_string
		mov rsi, HELP_MESSAGE
		call _print_string
		call _exit

	_atoi_safe:
		call _atoi

		cmp rcx, 0
		jnz _bad_format_number

		ret

	_exit:

		mov rax, 0x3C
		syscall