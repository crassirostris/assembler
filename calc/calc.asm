BITS 64

%include "../lib/strings.inc"

global _start

section .data
	ERR_NOT_ENOUGH_ARGUMENTS db 'Not enough arguments supplied', 0x0
	ERR_BAD_FORAMT_NUMBER db 'Failed to parse number: bad format', 0x0
	ERR_UNKNOWN_OPERATION db 'Unknown operation', 0x0
	ERR_DIVISION_BY_ZERO db 'Cannot divide by zero', 0x0

	HELP_MESSAGE db 'Usage: program <first_arg> <operation> <second_arg>', 0x0

section .text
	_start:
		mov rbp, rsp
		sub rsp, 0x100

		mov rdx, qword [rbp] ; argc

		cmp rdx, 4
		jb _not_enough_aruments

		mov rsi, [rbp + 1 * 8 + 8]
		call _atoi_safe
		push rax

		mov rsi, [rbp + 3 * 8 + 8]
		call _atoi_safe
		push rax

		mov rsi, [rbp + 2 * 8 + 8]

		cmp byte [rsi], '+'
		jz _start.addition
		cmp byte [rsi], '-'
		jz _start.substraction
		cmp byte [rsi], '*'
		jz _start.multiplitcation
		cmp byte [rsi], '/'
		jz _start.division
		jmp _unknown_operation


		.addition:
		pop rcx
		pop rax
		add rax, rcx
		jmp _start.print_result

		.substraction:
		pop rcx
		pop rax
		sub rax, rcx
		jmp _start.print_result

		.multiplitcation:
		pop rcx
		pop rax
		cqo
		imul rcx
		jmp _start.print_result

		.division:
		pop rcx
		pop rax
		cmp rcx, 0
		jz _cannot_divide_by_zero
		cqo
		idiv rcx
		jmp _start.print_result


		.print_result:
		lea rsi, [rbp - 0x100]
		call _itoa
		call _print_string

		add rsp, 0x100
		call _exit

	_unknown_operation:
		mov rsi, ERR_UNKNOWN_OPERATION
		call _print_string
		mov rsi, HELP_MESSAGE
		call _print_string
		call _exit

	_cannot_divide_by_zero:
		mov rsi, ERR_DIVISION_BY_ZERO
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