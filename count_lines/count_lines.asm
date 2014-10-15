BITS 64

%include "../lib/strings.inc"

global _start

section .data
	ERR_NOT_ENOUGH_ARGUMENTS db 'Not enough arguments supplied', 0x0
	ERR_FAILED_TO_OPEN_FILE db 'Filed to open file ', 0x0

	COLON db ': ', 0x0

	HELP_MESSAGE db 'Usage: count_lines <file1> [<file2> [...] ]', 0x0

	BUFFER_SIZE dq 1024

section .text
	_start:
		mov rbp, rsp

		mov rdx, qword [rbp] ; argc

		cmp rdx, 2
		jb _not_enough_aruments
		xor R9, R9
		inc R9

		sub rsp, [BUFFER_SIZE]

		.loop:
			mov rdi, [rbp + r9 * 8 + 8] ; filename
			xor rsi, rsi ; readonly
			xor rdx, rdx ; mode
			mov rax, 2
			syscall
			cmp rax, 0
			jle _start.no_such_file

			xchg rdi, rax ; fd

			xor R8, R8

			.read_file_loop:

				xor rax, rax
				lea rsi, [rsp]
				mov rdx, [BUFFER_SIZE]
				syscall

				test rax, rax
				jz _start.read_file_loop_end

				.count_lf_loop:
					cmp byte [rsi + rax - 1], 0xa
					jnz _start.dont_inc_counter
					inc R8
					.dont_inc_counter:
					dec rax
					test rax, rax
					jnz _start.count_lf_loop

				jmp _start.read_file_loop

			.read_file_loop_end:

			xchg R8, rax
			inc rax

			mov rsi, [rbp + r9 * 8 + 8]
			call _print_string
			mov rsi, COLON
			call _print_string
			lea rsi, [rsp]
			call _itoa
			call _print_string_ln


			jmp _start.loop_end

			.no_such_file:
				mov rsi, ERR_FAILED_TO_OPEN_FILE
				call _print_string
				mov rsi, [rbp + r9 * 8 + 8]
				call _print_string_ln
				jmp _start.loop_end

			.loop_end:
			inc R9
			cmp R9, qword [rbp]
			jnz _start.loop

		add rsp, [BUFFER_SIZE]

		call _exit

	_not_enough_aruments:
		mov rsi, ERR_NOT_ENOUGH_ARGUMENTS
		call _print_string_ln
		mov rsi, HELP_MESSAGE
		call _print_string_ln
		call _exit

	_exit:

		mov rax, 0x3C
		syscall