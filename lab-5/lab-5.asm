.486
.model flat, stdcall
option casemap: none
;========================
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
;========================
.data

	ErrorTitle 						db 	"Calculation %d with error", NULL
	SuccessTitle 					db 	"Calculation %d is successful", NULL
	CIsZeroErrorMessage 			db 	"Variant 8: (4 * b / c - 1) / (12 * c + a - b)", 13, 10,
										"Variable a: %d", 13, 10,
										"Variable b: %d", 13, 10,
										"Variable c: %d", 13, 10,
										"Expression: (4 * %d / %d - 1) / (12 * %d + %d - %d)", 13, 10,
										"ERROR: Variable c is 0. You can't divide by 0", NULL
	DenominatorIsZeroErrorMessage 	db 	"Variant 8: (4 * b / c - 1) / (12 * c + a - b)", 13, 10,
										"Variable a: %d", 13, 10,
										"Variable b: %d", 13, 10,
										"Variable c: %d", 13, 10,
										"Expression: (4 * %d / %d - 1) / (12 * %d + %d - %d)", 13, 10,
										"Numerator is equal: %d", 13, 10,
										"Denominator is equal: 0", 13, 10,
										"Division: %d / 0", 13, 10,
										"ERROR: Denominator is equal 0. You must enter correct variables!", NULL
	SuccessMessage					db	"Variant 8: (4 * b / c - 1) / (12 * c + a - b)", 13, 10,
										"Variable a: %d", 13, 10,
										"Variable b: %d", 13, 10,
										"Variable c: %d", 13, 10,
										"Expression: (4 * %d / %d - 1) / (12 * %d + %d - %d)", 13, 10,
										"Numerator is equal: %d", 13, 10,
										"Denominator is equal: %d", 13, 10,
										"Division: %d / %d = %d", 13, 10,
										"Final result: %d", NULL
	;--------------------
	NumOfCalculations 				dd 	6
	ArrayOfVarA 					dw	-43, -43, -100, -252, -40, 15
	ArrayOfVarB						dw	3, 7, -6, -105, 20, -10
	ArrayOfVarC						dw	4, 4, 8, 12, 5, 0 
;========================
.data?

	TitleBuffer db 256 dup(?)
	MessageBuffer db 256 dup(?)
;========================
.code

ShowSuccessMessageBox proc num:DWORD, aVar:WORD, bVar:WORD, cVar:WORD, numerator:WORD, denominator:DWORD, divRes:DWORD, finRes:DWORD
	
	local aVarDd: DWORD
	local bVarDd: DWORD
	local cVarDd: DWORD
	local numeratorDd: DWORD
	;--------------------
	local reg: DWORD
	mov reg, edi
	;--------------------
	movsx edi, aVar
	mov aVarDd, edi
	movsx edi, bVar
	mov bVarDd, edi
	movsx edi, cVar
	mov cVarDd, edi
	movsx edi, numerator
	mov numeratorDd, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset SuccessTitle, num
	invoke wsprintf, offset MessageBuffer, offset SuccessMessage, 
		aVarDd, bVarDd, cVarDd, 
		bVarDd, cVarDd, cVarDd, aVarDd, bVarDd,
		numeratorDd, 
		denominator, 
		numeratorDd, denominator, divRes, 
		finRes
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret
	
ShowSuccessMessageBox endp
;-----------------------
ShowCIsZeroErrorMessage proc num:DWORD, aVar:WORD, bVar:WORD, cVar:WORD
	
	local aVarDd: DWORD
	local bVarDd: DWORD
	local cVarDd: DWORD
	;--------------------
	local reg: DWORD
	mov reg, edi
	;--------------------
	movsx edi, aVar
	mov aVarDd, edi
	movsx edi, bVar
	mov bVarDd, edi
	movsx edi, cVar
	mov cVarDd, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset ErrorTitle, num
	invoke wsprintf, offset MessageBuffer, offset CIsZeroErrorMessage, 
		aVarDd, bVarDd, cVarDd, 
		bVarDd, cVarDd, cVarDd, aVarDd, bVarDd
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret
	
ShowCIsZeroErrorMessage endp
;-----------------------
ShowDenominatorIsZeroErrorMessage proc num:DWORD, aVar:WORD, bVar:WORD, cVar:WORD, numerator:WORD

	local aVarDd: DWORD
	local bVarDd: DWORD
	local cVarDd: DWORD
	local numeratorDd: DWORD
	;--------------------
	local reg: DWORD
	mov reg, edi
	;--------------------
	movsx edi, aVar
	mov aVarDd, edi
	movsx edi, bVar
	mov bVarDd, edi
	movsx edi, cVar
	mov cVarDd, edi
	movsx edi, numerator
	mov numeratorDd, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset ErrorTitle, num
	invoke wsprintf, offset MessageBuffer, offset DenominatorIsZeroErrorMessage, 
		aVarDd, bVarDd, cVarDd, 
		bVarDd, cVarDd, cVarDd, aVarDd, bVarDd,
		numeratorDd, 
		numeratorDd
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret

ShowDenominatorIsZeroErrorMessage endp
;-----------------------
MeasureExpression proc index:DWORD

	local num: DWORD
	local aVar: WORD
	local bVar: WORD
	local cVar: WORD
	local numerator: WORD
	local denominator: DWORD
	local result: DWORD
	local final: DWORD
	;-------------------
	local reg: DWORD
	mov reg, ebx
	;-------------------
	mov ebx, index
	inc ebx
	mov num, ebx
	;-------------------
	mov esi, index
	shl esi, 1
	;-------------------
	mov di, word ptr [ArrayOfVarA + esi]
	mov aVar, di
	mov di, word ptr [ArrayOfVarB + esi]
	mov bVar, di
	mov di, word ptr [ArrayOfVarC + esi]
	mov cVar, di
	;-------------------
	mov ax, bVar
	mov dx, 4
	imul dx
	;-------------------
	cmp cVar, 0
	jne cont
	;-------------------
	invoke ShowCIsZeroErrorMessage, num, aVar, bVar, cVar
	jmp exit
	;-------------------
cont:
	idiv cVar
	sub ax, 1
	mov numerator, ax
	;-------------------
	mov ax, cVar
	mov dx, 12
	imul dx
	;-------------------
	mov bx, ax
	mov cx, dx
	;-------------------
	mov ax, aVar
	cwd
	;-------------------
	add bx, ax
	adc cx, dx
	;-------------------
	mov ax, bVar
	cwd
	;-------------------
	sub bx, ax
	sbb cx, dx
	;-------------------
	xor eax, eax
	mov ax, cx
	shl eax, 16
	mov ax, bx
	mov denominator, eax
	;-------------------
	cmp eax, 0
	jne division
	;-------------------
	invoke ShowDenominatorIsZeroErrorMessage, num, aVar, bVar, cVar, numerator
	jmp exit
	;-------------------
division:
	mov ax, numerator
	cwde
	cdq
	;-------------------
	mov ebx, denominator
	idiv ebx
	mov result, eax
	;-------------------
	mov eax, result
	cdq
	mov ebx, 2
	idiv ebx
	;-------------------
	cmp edx, 0
	jne oddNumber
	;-------------------
evenNumber:
	mov final, eax
	jmp showSuccess
	;-------------------
oddNumber:
	mov eax, result
	imul eax, 5
	mov final, eax
	;-------------------
showSuccess:
	invoke ShowSuccessMessageBox, num, aVar, bVar, cVar, numerator, denominator, result, final
	;-------------------
exit:
	mov ebx, reg
	ret

MeasureExpression endp
;-----------------------
main:	
	
	mov ebx, 0
	;-------------------
	.while ebx < NumOfCalculations
	;-------------------
	invoke MeasureExpression, ebx
	add ebx, 1
	;-------------------
	.endw
	;-------------------
	invoke ExitProcess, NULL
	
end main
	