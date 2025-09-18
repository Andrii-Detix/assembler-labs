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
	extrn VarAExtrn:QWORD, VarBExtrn:QWORD, DenominatorDQ:QWORD, DenominatorDT:TBYTE, Two:QWORD
	public CalculateDenominator
;========================
.code

CalculateDenominator proc

	fld VarAExtrn
	fld VarBExtrn
	fild Two
	fmul
	fsubr
	;--------------------
	fst DenominatorDQ
	fstp DenominatorDT
	;--------------------
	ret

CalculateDenominator endp
end