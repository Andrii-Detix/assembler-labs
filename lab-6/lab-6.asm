.486
.model flat, stdcall
option casemap: none
;========================
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
;========================
.data

	ErrorTitle 						db 	"Calculation %d with error", NULL
	SuccessTitle 					db 	"Calculation %d is successful", NULL
	Variables						db	"Variable a: %s", 13, 10,
										"Variable b: %s", 13, 10,
										"Variable c: %s", 13, 10,
										"Variable d: %s", NULL
	Expression						db	"Expression: (tg(%s) - %s * 23) / (2 * %s - %s)", NULL
	TgIsInvalidErrorMessage 		db 	"Variant 8: (tg(c) - d * 23) / (2 * b - a)", 13, 10,
										"%s", 13, 10,
										"%s", 13, 10,
										"ERROR: Variable c is PI/2 + PI*k. tg is invalid", NULL
	DenominatorIsZeroErrorMessage 	db 	"Variant 8: (tg(c) - d * 23) / (2 * b - a)", 13, 10,
										"%s", 13, 10,
										"%s", 13, 10,
										"Numerator is equal: %s", 13, 10,
										"Denominator is equal: 0", 13, 10,
										"ERROR: Denominator is equal 0. You must enter correct variables!", NULL
	SuccessMessage					db	"Variant 8: (tg(c) - d * 23) / (2 * b - a)", 13, 10,
										"%s", 13, 10,
										"%s", 13, 10,
										"Numerator is equal: %s", 13, 10,
										"Denominator is equal: %s", 13, 10,
										"Result: %s", NULL
	;--------------------
	Epsilon							dq	0.000001
	;--------------------
	Separator						db	".", NULL
	;--------------------
	TwentyThree						dq	23
	Two								dq	2
	;--------------------
	NumOfCalculations 				dd 	6
	ArrayOfVarA 					dq	-2.34, 5.67, -4.89, 10.11, 4.68, 4.68
	ArrayOfVarB						dq	3.41, -2.78, 6.23, -2.34, 2.34, 2.56
	ArrayOfVarC						dq	1.56, 0.79, 2.36, 2.64, 1.05, 1.5707963
	ArrayOfVarD						dq	2.56, -3.12, 2.45, 5.67, 1.34, 4.66
;========================
.data?

	VarAString	db 32 dup(?)
	VarBString	db 32 dup(?)
	VarCString	db 32 dup(?)
	VarDString	db 32 dup(?)
	NumerString	db 32 dup(?)
	DenomString db 32 dup(?)
	ResString	db 32 dup(?)
	;--------------------
	floor dd ?
	;--------------------
	ExpressionBuffer db 64 dup(?)
	VariablesBuffer db 128 dup(?)
	TitleBuffer db 512 dup(?)
	MessageBuffer db 512 dup(?)
;========================
.code

GetWithDecimalPlaces proc string:dword, decimal: dword

    local counter: dword
    local mem: dword
    local rega: dword
    local regb: dword
    ;--------------------
    mov rega, esi
    mov regb, ebx
    ;--------------------
    mov ebx, string
    mov mem, ebx
    ;--------------------
startLoop:
    mov ebx, mem
    mov dh, byte ptr [ebx]
    cmp dh, NULL
    je final
    cmp dh, byte ptr [Separator]
    je setNull
    inc ebx
    mov mem, ebx
    jmp startLoop
    ;--------------------
setNull:
    inc ebx
    mov esi, decimal
    add ebx, esi
    mov byte ptr [ebx], NULL
    ;--------------------
final:
    mov ebx, regb
    mov esi, rega
    ret

GetWithDecimalPlaces endp
;------------------------
ShowTgIsInvalid proc num:DWORD, aVar:QWORD, bVar:QWORD, cVar:QWORD, dVar:QWORD

	local reg: DWORD
	mov reg, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset ErrorTitle, num
	;--------------------
	invoke FloatToStr2, aVar, offset VarAString
	invoke FloatToStr2, bVar, offset VarBString
	invoke FloatToStr2, cVar, offset VarCString
	invoke FloatToStr2, dVar, offset VarDString
	;---------------------
	invoke wsprintf, offset ExpressionBuffer, offset Expression,
	offset VarCString, offset VarDString, offset VarBString, offset VarAString	
	;---------------------
	invoke wsprintf, offset VariablesBuffer, offset Variables,
	offset VarAString, offset VarBString, offset VarCString, offset VarDString		
	;---------------------
	invoke wsprintf, offset MessageBuffer, offset TgIsInvalidErrorMessage, 
	offset VariablesBuffer, offset ExpressionBuffer
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret

ShowTgIsInvalid endp
;-----------------------
ShowDenominatorIsZeroErrorMessage proc num:DWORD, aVar:QWORD, bVar:QWORD, cVar:QWORD, dVar:QWORD, numerator:QWORD

	local reg: DWORD
	mov reg, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset ErrorTitle, num
	;--------------------
	invoke FloatToStr2, aVar, offset VarAString
	invoke FloatToStr2, bVar, offset VarBString
	invoke FloatToStr2, cVar, offset VarCString
	invoke FloatToStr2, dVar, offset VarDString
	invoke FloatToStr2, numerator, offset NumerString
	invoke GetWithDecimalPlaces, offset NumerString, 6
	;---------------------
	invoke wsprintf, offset ExpressionBuffer, offset Expression,
	offset VarCString, offset VarDString, offset VarBString, offset VarAString	
	;---------------------
	invoke wsprintf, offset VariablesBuffer, offset Variables,
	offset VarAString, offset VarBString, offset VarCString, offset VarDString		
	;---------------------
	invoke wsprintf, offset MessageBuffer, offset DenominatorIsZeroErrorMessage, 
	offset VariablesBuffer, offset ExpressionBuffer, offset NumerString
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret

ShowDenominatorIsZeroErrorMessage endp
;-----------------------
ShowSuccessMessage proc num:DWORD, aVar:QWORD, bVar:QWORD, cVar:QWORD, dVar:QWORD, numerator:QWORD, denominator:QWORD, result:QWORD

	local reg: DWORD
	mov reg, edi
	;--------------------
	invoke wsprintf, offset TitleBuffer, offset SuccessTitle, num
	;--------------------
	invoke FloatToStr2, aVar, offset VarAString
	invoke FloatToStr2, bVar, offset VarBString
	invoke FloatToStr2, cVar, offset VarCString
	invoke FloatToStr2, dVar, offset VarDString
	invoke FloatToStr2, numerator, offset NumerString
	invoke GetWithDecimalPlaces, offset NumerString, 6
	invoke FloatToStr2, denominator, offset DenomString
	invoke GetWithDecimalPlaces, offset DenomString, 2
	invoke FloatToStr2, result, offset ResString
	invoke GetWithDecimalPlaces, offset ResString, 8
	;---------------------
	invoke wsprintf, offset ExpressionBuffer, offset Expression,
	offset VarCString, offset VarDString, offset VarBString, offset VarAString	
	;---------------------
	invoke wsprintf, offset VariablesBuffer, offset Variables,
	offset VarAString, offset VarBString, offset VarCString, offset VarDString		
	;---------------------
	invoke wsprintf, offset MessageBuffer, offset SuccessMessage, 
	offset VariablesBuffer, offset ExpressionBuffer,
	offset NumerString, offset DenomString, offset ResString
	;--------------------
	invoke MessageBox, NULL, offset MessageBuffer, offset TitleBuffer, MB_OK
	;--------------------
	mov edi, reg
	;--------------------
	ret

ShowSuccessMessage endp
;-----------------------
MeasureExpression proc index:DWORD

	local num: DWORD
	local aVar: QWORD
	local bVar: QWORD
	local cVar: QWORD
	local dVar: QWORD
	local numerator: QWORD
	local denominator: QWORD
	local result: QWORD
	local show: QWORD
	;-------------------
	local reg: DWORD
	mov reg, ebx
	;-------------------
	mov ebx, index
	inc ebx
	mov num, ebx
	;-------------------
	mov esi, index
	shl esi, 3
	;-------------------
	finit 
	;-------------------
	fld qword ptr [ArrayOfVarA + esi]
	fstp aVar
	fld qword ptr [ArrayOfVarB + esi]
	fstp bVar
	fld qword ptr [ArrayOfVarC + esi]
	fstp cVar
	fld qword ptr [ArrayOfVarD + esi]
	fstp dVar
	;-------------------
	fld cVar
	fldpi
	fdiv
	fist dword ptr [floor]
	fstp st(0)
	fild floor
	fld cVar
	fldpi
	fdiv
	fsub
	fldpi
	fmul
	fabs
	fldpi 
	fild Two
	fdiv
	fsub
	fabs
	fld Epsilon
	fcomp
	fstp st(0)
	fstsw ax
	sahf
	jb correctVarC
	;-------------------
	invoke ShowTgIsInvalid, num, aVar, bVar, cVar, dVar
	jmp exit
	;-------------------
correctVarC:
	fld cVar
	fptan
	fstp st(0)
	fld dVar
	fild TwentyThree
	fmul
	fsub
	fst numerator
	;-------------------
	fld aVar
	fld bVar
	fild Two
	fmul
	fsubr
	fst denominator
	;------------------- 
    fldz    
    fcomp   
    fstsw ax    
    sahf
	jne denominator_not_zero
	invoke ShowDenominatorIsZeroErrorMessage, num, aVar, bVar, cVar, dVar, numerator
	jmp exit
	;-------------------
denominator_not_zero:
	fdiv 
	fstp result
	;-------------------
	invoke ShowSuccessMessage, num, aVar, bVar, cVar, dVar, numerator, denominator, result
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
	