.486
.model flat, stdcall
option casemap: none
;========================
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\dialogs.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
;========================
.const

	MAX_INPUT_LENGTH	= 128
	;--------------------
	STATIC_TEXT			= 1000
	EDIT 				= 1010
	CONFIRM 			= 1020
;========================
.data

	MessageBoxSuccessTitle 			db	"Success password - Not Encrypted", NULL
	MessageBoxSuccessInformation 	db 	"Ivanchyshyn Andrii", 13, 10,
										"Variant: 8", NULL
	;--------------------
	MessageBoxWrongTitle 			db	"Wrong password - Not Encrypted", NULL
	MessageBoxWrongInformation		db	"Input password is incorrect!", NULL
	;--------------------
	Password						db 	"Detix", NULL
;========================
.data?

	InputMessage					db MAX_INPUT_LENGTH dup(?)
;========================
.code

ShowMessageBox proc pInformation:DWORD, pTitle:DWORD

	invoke MessageBox, NULL, pInformation, pTitle, MB_OK
	;--------------------
	invoke ExitProcess, NULL
	
ShowMessageBox endp
;------------------------
ShowSuccessMessageBox proc
	invoke ShowMessageBox, offset MessageBoxSuccessInformation, offset MessageBoxSuccessTitle
ShowSuccessMessageBox endp
;------------------------
ShowWrongMessageBox proc
	invoke ShowMessageBox, offset MessageBoxWrongInformation, offset MessageBoxWrongTitle
ShowWrongMessageBox endp
;------------------------
CheckPassword proc input:DWORD

	invoke lstrcmp, input, offset Password
	jz correct
	jnz wrong
	;--------------------
correct:
	call ShowSuccessMessageBox
	;--------------------
wrong:
	call ShowWrongMessageBox
	
CheckPassword endp
;------------------------
DlgProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD 

	mov eax, uMsg
	cmp eax, WM_COMMAND
	jne notCommand 
	;--------------------
	mov eax, wParam
	cmp eax, CONFIRM
	jne done 
	;--------------------
	invoke GetDlgItemText, hWin, EDIT, addr InputMessage, MAX_INPUT_LENGTH
	invoke CheckPassword, addr InputMessage
	;--------------------
notCommand:
	mov eax, uMsg
	cmp eax, WM_CLOSE
	jne done
	;-------------------- 
	invoke ExitProcess, NULL
	;--------------------
done:
	xor eax, eax
	xor ebx, ebx
	;--------------------
	ret

DlgProc endp
;------------------------
RunPasswordDialog proc

	Dialog "Lab 3 - Password Not Encrypted", \
	"Times New Roman", 20, \
	WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU or DS_CENTER, 3, \
	0, 0, 150, 100, \
	1024
	;--------------------
	DlgStatic "Enter your password", SS_CENTER or SS_SUNKEN, 0, 20, 150, 10, STATIC_TEXT
	DlgEdit ES_CENTER, 0, 40, 150, 20, EDIT
	DlgButton "Confirm", BS_CENTER or BS_PUSHBUTTON or BS_DEFPUSHBUTTON, 10, 70, 130, 20, CONFIRM
	;--------------------
	CallModalDialog 0, 0, DlgProc, NULL
	;--------------------
	ret
	
RunPasswordDialog endp
;------------------------
main:	
	
	call RunPasswordDialog
	;--------------------
	invoke ExitProcess, NULL
	
end main
 