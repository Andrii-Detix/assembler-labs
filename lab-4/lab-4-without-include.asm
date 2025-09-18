.486
.model flat, stdcall
option casemap: none
.listall
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

	MessageBoxSuccessTitle 			db	"Success password - lab 4", NULL
	NameAndSurname				 	db 	"Name and Surname: Andrii Ivanchyshyn", NULL
	Variant							db	"Variant: 8", NULL
	;--------------------
	MessageBoxWrongTitle 			db	"Wrong password - lab 4", NULL
	MessageBoxWrongInformation		db	"Input password is incorrect!", NULL
	;--------------------
	KeyWord							db	"-P3*+", NULL
	EncryptedPassword				db	"i5GCS", NULL
;========================
.data?

	InputMessage					db MAX_INPUT_LENGTH dup(?)
	EncryptedInput					db MAX_INPUT_LENGTH dup(?)
;========================
.code

ShowData macro pData:=<NULL>, pTitle:req
;; This macros accept 2 parameters, first of them has default value
;--StartShowDataMessageBox-------
	invoke MessageBox, NULL, pData, pTitle, MB_OK ; Show Data
;--FinishShowDataMessageBox------
endm
;;===============================
Encrypt macro pEncryptedResult:req, pInput:req, pKey:req
;; All parameters are required
;--StartEncryptInputString-------
	mov ebp, pKey
	;--------------------
encryptCharacter: ; start of loop
	mov esi, pInput
	mov dh, byte ptr [esi]
	cmp dh, NULL
	je endInput
	;--------------------
	mov esi, pKey
	xor dh, byte ptr [esi]
	;--------------------
	mov esi, pEncryptedResult
	mov byte ptr [esi], dh
	;--------------------
	inc pInput
	inc pKey
	inc pEncryptedResult
	;--------------------
	mov esi, pKey
	mov dh, byte ptr [esi]
	cmp dh, NULL
	jne toStartLoop
	;--------------------
	mov esi, ebp
	mov pKey, esi 
	;--------------------
toStartLoop:
	jmp encryptCharacter ;; end of loop
	;--------------------
endInput:
	mov esi, pEncryptedResult
	mov byte ptr [esi], NULL
;---FinishEncryptInputString-----	
endm
;;===============================
CheckPassword macro boolResult:req, pInput:req, pPassword:req
;; boolResult is a result of comparison  
;-----StartCheckPassword---------
	local checkCharacter
	local checkInputEnding
	local correct
	local wrong
	local done
	;-------------------
checkCharacter:
	mov esi, pPassword
	mov dl, byte ptr [esi]
	cmp dl, NULL
	je checkInputEnding
	;--------------------
	mov esi, pInput
	mov dh, byte ptr [esi]
	cmp dh, NULL
	je wrong
	;--------------------
	cmp dl, dh ; comapre characters with same index in string
	jne wrong
	;--------------------
	inc pInput
	inc pPassword
	;--------------------
	jmp checkCharacter
	;--------------------
checkInputEnding:
	mov esi, pInput
	mov dh, byte ptr [esi]
	cmp dh, NULL
	je correct
	jne wrong
	;--------------------
correct:
	mov boolResult, 1
	jmp done
	;--------------------
wrong:
	mov boolResult, 0
	jmp done
	;--------------------
done: ;; end for borh correct and wrong variants
	;------FinishCheckPassword-------
endm
;-----------------------
Finish proc

	invoke ExitProcess, NULL
	
Finish endp
;-----------------------
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
	;--------------------
	lea ebx, EncryptedInput	
	lea ecx, InputMessage
	lea edi, KeyWord
    Encrypt ebx, ecx, edi
    ;---------------------
    lea ebx, EncryptedInput	
    lea edi, EncryptedPassword
    CheckPassword ch, ebx, edi
    cmp ch, 1
    je correctPassword
    jne wrongPassword
    ;---------------------
correctPassword:
	ShowData offset NameAndSurname, offset MessageBoxSuccessTitle
	ShowData offset Variant, offset MessageBoxSuccessTitle
	call Finish
	;--------------------
wrongPassword:
	ShowData offset MessageBoxWrongInformation, offset MessageBoxWrongTitle 
	call Finish
	;--------------------
notCommand:
	mov eax, uMsg
	cmp eax, WM_CLOSE
	jne done
	;-------------------- 
	call Finish
	;--------------------
done:
	xor eax, eax
	xor ebx, ebx
	;--------------------
	ret

DlgProc endp
;------------------------
RunPasswordDialog proc

	Dialog "Lab 4 - macros", \
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
	call Finish
	
end main