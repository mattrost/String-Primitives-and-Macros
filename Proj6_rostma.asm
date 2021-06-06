TITLE String Primitives and Macros    (Proj6_rostma.asm)

; Author: Matthew Rost
; Last Modified: 6/5/2021
; OSU email address: rostma@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:                 Due Date: 6/6/2021
; Description: This is the portfolio project file for CS 271. This file
;              is a program that implements macros for string processing.
;			   It also uses procedures for signed integers which use
;			   string primitive isntructions. This will get a user string
;			   input and convert the ascii digits to its numeric value.
;			   The program will get 10 valid integers from the user and
;			   store them into an array. It will then display the integers,
;			   their sum, and their average.

INCLUDE Irvine32.inc

; (insert macro definitions here)
mGetString MACRO prompt, user_input, input_length

	PUSH		EDX
	PUSH		ECX
	PUSH		EAX

	MOV			EDX, prompt
	CALL		WriteString

	MOV			EDX, user_input
	MOV			ECX, 10

	CALL		ReadString
	MOV			input_length, EAX

	POP			EAX
	POP			ECX
	POP			EDX
ENDM

; mMakeString

; mDisplayString based off of MacroDemo.asm from Module 8 - Exploration 2
mDisplayString MACRO string
	PUSH		EDX

	MOV			EDX, string
	CALL		WriteString

	POP			EDX

ENDM

HI = 32
NUMBER = 3 ; Number of integers to store

.data

	assignment			BYTE		"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
	author				BYTE		"Written By: Matthew Rost", 0
	instruction_1		BYTE		"Please provide 10 signed decimal integers.", 0
	instruction_2		BYTE		"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the", 0
	instruction_3		BYTE		"raw numbers, this will display a list of the integers, their sum, and their average value.", 0
	input_prompt		BYTE		"Please enter a signed number: ", 0
	input_bad			BYTE		"ERROR: You did not enter a signed number or your number was too big.", 0
	input_try_again		BYTE		"Please try again: ", 0
	integers			SDWORD		NUMBER DUP(?)
	string				BYTE		32 DUP(0)
	string_output		BYTE		32 DUP(0)
	string_count		DWORD		?
	count				DWORD		?
	output_string		BYTE		"You entered the following numbers: ", 0
	comma				BYTE		", ", 0
	average				DWORD		?
	sum_string			BYTE		"The sum of these numbers is: ", 0
	sum					DWORD		?
	rounded_string		BYTE		"The rounded average is: ", 0
	goodbye				BYTE		"Thanks for playing!", 0

.code
main PROC
	
	; Display Introduction and Prompt
	PUSH					OFFSET instruction_3
	PUSH					OFFSET instruction_2
	PUSH					OFFSET instruction_1
	PUSH					OFFSET author
	PUSH					OFFSET assignment
	CALL					Introduction

	MOV						ECX, NUMBER
	MOV						EAX, 0
	MOV						count, EAX

	_getValidStrings:
		; Loop to get valid integers
		; call ReadVal
		PUSH					OFFSET string_count
		PUSH					OFFSET count
		PUSH					OFFSET string
		PUSH					OFFSET integers
		PUSH					OFFSET input_try_again
		PUSH					OFFSET input_bad
		PUSH					OFFSET input_prompt
		CALL					ReadVal
		ADD						count, 4
		LOOP					_getValidStrings

	PUSH					OFFSET integers
	PUSH					OFFSET sum
	PUSH					OFFSET average
	CALL					Calculate

	Call					Crlf
	mDisplayString			OFFSET output_string
	Call					Crlf

	MOV						EAX, 0
	MOV						count, EAX
	MOV						ECX, NUMBER

	_enteredNumbers:
		MOV						string_output, 0
		PUSH					OFFSET count
		PUSH					OFFSET string_output
		PUSH					OFFSET integers
		CALL					WriteVal
		ADD						count, 4
		CMP						ECX, 1
		JE						_enteredNumbersNoComma
		mDisplayString			OFFSET comma
		LOOP					_enteredNumbers

	_enteredNumbersNoComma:
		LOOP					_enteredNumbersNoComma
		

	MOV						string_output, 0
	MOV						count, EAX
	Call					Crlf
	mDisplayString			OFFSET sum_string

	PUSH					OFFSET count
	PUSH					OFFSET string_output
	PUSH					OFFSET sum
	CALL					WriteVal

	MOV						string_output, 0
	Call					Crlf
	mDisplayString			OFFSET rounded_string		

	PUSH					OFFSET count
	PUSH					OFFSET string_output
	PUSH					OFFSET average
	CALL					WriteVal

	Call					Crlf
	Call					Crlf
	mDisplayString			OFFSET goodbye

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -----------------------------
; Name: Introduction
;
; FILL THIS OUT
;	
; Preconditions:
;	FILL THIS OUT
;
; Receives:
;	[ebp+8]			= assignment array
;	[ebp+12]		= author array
;	[ebp+16]		= instruction_1 array
;	[ebp+20]		= instruction_2 array
;	[ebp+24]		= instruction_3 array
;
; Returns:
;	NONE
; -----------------------------
Introduction PROC
	PUSH					EBP
	MOV						EBP, ESP
	PUSH					EDX

	; Call macro to display the introduction and prompt strings
	mDisplayString			[EBP+8]
	CALL					Crlf
	mDisplayString			[EBP+12]
	CALL					Crlf
	CALL					Crlf
	mDisplayString			[EBP+16]
	CALL					Crlf
	mDisplayString			[EBP+20]
	CALL					Crlf
	mDisplayString			[EBP+24]
	CALL					Crlf
	CALL					Crlf

	POP						EDX
	POP						EBP
	RET						20

Introduction ENDP

; -----------------------------
; Name: ReadVal
;
; FILL THIS OUT
;	
; Preconditions:
;	FILL THIS OUT
;
; Receives:
;	[ebp+8]			=  input_prompt string BYTE array
;	[ebp+12]		=  input_bad string BYTE array
;	[ebp+16]		=  input_try_again string BYTE array
;	[ebp+20]		=  integers DWORD array
;	[ebp+24]		=  string (user string input) BYTE array
;	[ebp+28]		=  count DWORD
;	[ebp+32]		=  string_count (length of string input) DWORD
;
; Returns:
;	NONE
; -----------------------------
ReadVal PROC
	PUSH					EBP
	MOV						EBP, ESP
	PUSH					EAX
	PUSH					EBX
	PUSH					ECX
	PUSH					EDX
	PUSH					EDI
	PUSH					ESI

	MOV						EDI, [EBP+20]
	MOV						EAX, [EBP+28]
	ADD						EDI, [EAX]		; Set to end of array of integers
	MOV						EAX, 0
	MOV						EBX, 0

	; Call macro to display the introduction and prompt strings

	_getString:
		mGetString				[EBP+8], [EBP+24], [EBP+32]

		; Quick check to see if the user entered any characters
		MOV						EAX, [EBP+32]
		CMP						EAX, 1
		JL						_badString
		MOV						ESI, [EBP+24]
		MOV						ECX, [EBP+32]
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX
		JMP						_verifyFirst 	; string contains >0 characters, time to verify if it has a + or - sign

	_badString:

		mDisplayString			[EBP+12]
		CALL					Crlf

		mGetString				[EBP+16], [EBP+24], [EBP+32]
		MOV						EAX, [EBP+32]
		CMP						EAX, 1
		JL						_badString
		MOV						ESI, [EBP+24]
		MOV						ECX, [EBP+32]
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX

		MOV						EAX, [EDI]
		MOV						EAX, 0
		MOV						[EDI], EAX

		JMP						_verifyFirst

	_verifyFirst:
		LODSB
		CMP						AL, 45
		JE						_negative
		CMP						AL, 43
		JE						_positive
		MOV						ESI, [EBP+24]
		JMP						_verifyString

	_negative:
		SUB						ECX, 1
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX
		JMP						_verifyStringNegative

	_positive:
		SUB						ECX, 1
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX
		JMP						_verifyString

	_verifyString:
		LODSB
		CMP						AL, 48
		JL						_badString
		CMP						AL, 57
		JG						_badString
		SUB						EAX, 48

		PUSH					ECX
		MOV						ECX, [EBP+32]
		CMP						ECX, 0
		JG						_multiply
		JMP						_addDigit

	_multiply:
		MOV						EBX, 10
		MUL						EBX
		JO						_overflow
		LOOP					_multiply
		JMP						_addDigit

	_verifyStringNegative:
		LODSB
		CMP						AL, 48
		JL						_badString
		CMP						AL, 57
		JG						_badString
		SUB						EAX, 48

		PUSH					ECX
		MOV						ECX, [EBP+32]
		CMP						ECX, 0
		JG						_multiplyNegative
		JMP						_addDigitNegative

	_multiplyNegative:
		MOV						EBX, 10
		MUL						EBX
		JO						_badString
		LOOP					_multiplyNegative
		JMP						_addDigitNegative

	_addDigit:
		MOV						EBX, [EDI]
		ADD						EAX, EBX
		JO						_overflow
		MOV						[EDI], EAX
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX
		POP						ECX
		LOOP					_verifyString
		JMP						_end

	_addDigitNegative:
		MOV						EBX, [EDI]
		ADD						EAX, EBX
		JO						_overflow
		MOV						[EDI], EAX
		MOV						EAX, [EBP+32]
		SUB						EAX, 1
		MOV						[EBP+32], EAX
		POP						ECX
		LOOP					_verifyStringNegative

		MOV						EBX, [EDI]
		NEG						EBX
		MOV						[EDI], EBX

		JMP						_end

	_overflow:
		POP						ECX
		JMP						_badString

		; check for any non number chars (except for minus and plus at start)

		
	_end:

	POP						ESI
	POP						EDI
	POP						EDX
	POP						ECX
	POP						EBP
	POP						EAX
	POP						EBP
	RET						28

ReadVal ENDP


; -----------------------------
; Name: WriteVal
;
; FILL THIS OUT
;	
; Preconditions:
;	FILL THIS OUT
;
; Receives:
;	[ebp+8]			= assignment array
;	[ebp+12]		= author array
;	[ebp+16]		= instruction_1 array
;	[ebp+20]		= instruction_2 array
;	[ebp+24]		= instruction_3 array
;
; Returns:
;	NONE
; -----------------------------
WriteVal PROC
	PUSH					EBP
	MOV						EBP, ESP
	PUSH					ESI
	PUSH					EDI
	PUSH					EAX
	PUSH					ECX
	PUSH					EDX

	MOV						ECX, 0
	MOV						ESI, [EBP+8]
	MOV						EDI, [EBP+12]
	MOV						EAX, [EBP+16]
	ADD						ESI, [EAX]
	MOV						EAX, [ESI]
	JS						_printArrayPositive



	_printArrayPositive:
		MOV						EBX, 10
		MOV						EDX, 0
		DIV						EBX
		INC						ECX
		PUSH					EDX
		CMP						EAX, 0
		JE						_popStack
		JMP						_printArrayPositive


	_printArrayNegative:


	_popStack:
		POP						EDX	
		MOV						EAX, EDX
		ADD						EAX, 48
		STOSB
		LOOP					_popStack
		mDisplayString			[EBP+12]

		
	POP						EDX
	POP						ECX
	POP						EAX
	POP						EDI
	POP						ESI
	POP						EBP
	RET						12

WriteVal ENDP


; -----------------------------
; Name: Calculate
;
; FILL THIS OUT
;	
; Preconditions:
;	FILL THIS OUT
;
; Receives:
;	[ebp+8]			= assignment array
;	[ebp+12]		= author array
;	[ebp+16]		= instruction_1 array
;	[ebp+20]		= instruction_2 array
;	[ebp+24]		= instruction_3 array
;
; Returns:
;	NONE
; -----------------------------
Calculate PROC
	PUSH					EBP
	MOV						EBP, ESP
	PUSH					EAX
	PUSH					EBX
	PUSH					ECX
	PUSH					EDX
	PUSH					EDI

	MOV						ESI, [EBP+16]
	MOV						ECX, NUMBER
	MOV						EDX, 0					; Counts the amount of digits
	MOV						EDI, [EBP+12]

	_sum:
		MOV						EAX, [EDI]
		MOV						EBX, [ESI]
		ADD						EAX, EBX
		MOV						[EDI], EAX
		ADD						ESI, 4
		ADD						EDX, 1
		LOOP					_sum

	MOV						ESI, [EBP+12]
	MOV						EAX, [ESI]
	MOV						EBX, EDX
	MOV						EDX, 0
	CDQ
	IDIV					EBX
	MOV						EDI, [EBP+8]
	MOV						[EDI], EAX

	POP						ESI
	POP						EDX
	POP						ECX
	POP						EBX
	POP						EAX
	POP						EBP
	RET						12

Calculate ENDP

END main
