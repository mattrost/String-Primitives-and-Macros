TITLE String Primitives and Macros    (Proj6_rostma.asm)

; Author: Matthew Rost
; Last Modified: 6/1/2021
; OSU email address: rostma@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:                 Due Date:
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

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
