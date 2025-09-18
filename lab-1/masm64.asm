option casemap: none
;===================
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
include \masm64\include\user32.inc

includelib \masm64\lib\kernel32.lib
includelib \masm64\lib\user32.lib
;===================
.data
	MessageBoxTitle db			"Lab 1 - masm64", NULL
	MessageBoxInformation db 	"ПІБ: Іванчишин Андрій Олександрович", 13, 10,
								"Заліковка: відсутня", 13, 10,
								"Номер в списку групи: 8", NULL

.code
Main proc

    sub rsp, 8h
    ;---------------
    mov rcx, NULL                    
    lea rdx, MessageBoxInformation            
    lea r8,  MessageBoxTitle        
    mov r9d, MB_OK                    
    ;---------------
    call     MessageBox                
    ;---------------
    mov rcx, NULL    
    ;---------------
    call     ExitProcess     
    
Main endp
end
