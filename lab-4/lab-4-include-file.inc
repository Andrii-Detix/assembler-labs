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