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
	MessageBoxTitle db			"Lab 1 - masm32", NULL
	MessageBoxInformation db 	"ПІБ: Іванчишин Андрій Олександрович", 13, 10,
								"Заліковка: відсутня", 13, 10,
								"Номер в списку групи: 8", NULL

.code
main:

	invoke MessageBox, NULL, offset MessageBoxInformation, offset MessageBoxTitle, MB_OK
	;--------------------
	invoke ExitProcess, NULL

end main