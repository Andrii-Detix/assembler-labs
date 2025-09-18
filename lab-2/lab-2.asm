.386
.model flat, stdcall
option casemap: none
;========================
include \masm32\include\masm32rt.inc
;========================
.data
	MessageBoxTitle db		"Lab 2 - Ivanchyshyn Andrii", NULL
	MessageBoxInformation db 	"Birthday:   %s", 13, 10,
								"Positive A: %d", 13, 10,
								"Negative A: %d", 13, 10,
								"Positive B: %d", 13, 10,
								"Negative B: %d", 13, 10,
								"Positive C: %d", 13, 10,
								"Negative C: %d", 13, 10,
								"Positive D: %s ( %s )", 13, 10,
								"Negative D: %s ( %s )", 13, 10,
								"Positive E: %s", 13, 10,
								"Negative E: %s", 13, 10,
								"Positive F: %s", 13, 10,
								"Negative F: %s", NULL
	;--------------------
	BirthdayString db "01122005", NULL
	;--------------------
	ADbPositive db 1
	ADwPositive dw 1
	ADdPositive dd 1
	ADqPositive dq 1
	;--------------------
	ADbNegative db -1
	ADwNegative dw -1
	ADdNegative dd -1
	ADqNegative dq -1
	;--------------------
	BDwPositive dw 112
	BDdPositive dd 112
	BDqPositive dq 112
	;--------------------
	BDwNegative dw -112
	BDdNegative dd -112
	BDqNegative dq -112
	;--------------------
	CDdPositive dd 1122005
	CDqPositive dq 1122005
	;--------------------
	CDdNegative dd -1122005
	CdqNegative dq -1122005
	;--------------------
	DDdPositive dd 0.000
	DDqPositive dq 0.000
	DPositiveString db "0.000", NULL
	;--------------------
	DDdNegative dd -0.000
	DDqNegative dq -0.000
	DNegativeString db "-0.000", NULL
	;--------------------
	EDqPositive dq 0.024
	EDqNegative dq -0.024
	;--------------------
	FDtPositive dt 243.227
	FDqPositive dq 243.227
	;--------------------
	FDtNegative dt -243.227
	FDqNegative dq -243.227
	
.data?
	StringBuffer db 256 dup(?)
	;--------------------
	PositiveDBuffer db 64 dup(?)
	NegativeDBuffer db 64 dup(?)
	;--------------------
	PositiveEBuffer db 64 dup(?)
	NegativeEBuffer db 64 dup(?)
	;--------------------
	PositiveFBuffer db 64 dup(?)
	NegativeFBuffer db 64 dup(?)

.code
main:

	invoke FloatToStr2, DDqPositive, offset PositiveDBuffer
	invoke FloatToStr2, DDqNegative, offset NegativeDBuffer
	invoke FloatToStr2, EDqPositive, offset PositiveEBuffer
	invoke FloatToStr2, EDqNegative, offset NegativeEBuffer
	invoke FloatToStr2, FDqPositive, offset PositiveFBuffer
	invoke FloatToStr2, FDqNegative, offset NegativeFBuffer
	;--------------------
	invoke wsprintf, offset StringBuffer, offset MessageBoxInformation,
						offset BirthdayString, 
						ADdPositive,
						ADdNegative, 
						BDdPositive,
						BDdNegative,
						CDdPositive,
						CDdNegative,
						offset PositiveDBuffer, offset DPositiveString,
						offset NegativeDBuffer, offset DNegativeString,
						offset PositiveEBuffer,
						offset NegativeEBuffer,
						offset PositiveFBuffer,
						offset NegativeFBuffer
	;--------------------
	invoke MessageBox, NULL, offset StringBuffer, offset MessageBoxTitle, MB_OK
	;--------------------
	invoke ExitProcess, NULL

end main
