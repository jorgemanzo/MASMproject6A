TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

mWriteString MACRO myString
	pushad
	mov		EDX,OFFSET myString
	call	WriteString
	call	CrLf
	popad
ENDM

mWriteDec	MACRO	myNum
	pushad
	mov		EAX,myNum
	call	WriteDec
	call	CrlF
	popad
ENDM


prepReadVal MACRO myString, sizeOfMyString, X, check
	pushad
	push	OFFSET	check
	push	OFFSET	X
	push	OFFSET	myString
	push	OFFSET	sizeOfMyString
	call	ReadVal
	popad
ENDM

mGetString	MACRO myString,	sizeOfMyString
	mov		ECX,10
	mov		EDX,myString
	call	ReadString
	mov		EBX,sizeOfMyString
	mov		[EBX],EAX
ENDM

mVerify		MACRO myString, SizeOfMyString, X, check
	pushad
	push	check
	push	X
	push	myString
	push	SizeOfMyString
	call	Verify
	popad
ENDM


mConvert MACRO myChar, X
	pushad
	push	myChar
	push	X
	call	Convert
	popad
ENDM

mClearString MACRO myString, SizeOfMyString
	pushad
	push	OFFSET	myString
	push	OFFSET	SizeOfMyString
	call	ClearString
	popad
ENDM

mClearX		MACRO	X
	pushad
	push	OFFSET X
	call	ClearX
	popad
ENDM

mClearCheck	MACRO	check
	pushad
	push	OFFSET	check
	call	ClearCheck
	popad
ENDM

mAppendNum	MACRO	myArray, myNum, location
	pushad
	push	OFFSET	location
	push	OFFSET	myArray
	push	OFFSET	myNum
	call	AppendNumber
	popad
ENDM

mPrintArray	MACRO	myArray
	pushad
	push	OFFSET	myArray
	call	PrintUs
	popad
ENDM

.data

myString	BYTE	11
greetings	BYTE	"Hey. Give me 10 numbers, then Ill find some averages.",0
storedNumbers	DWORD	10 DUP(0)
sizeOfStored	DWORD	0
sizeOfMyString	DWORD 0
X				DWORD 0
check			DWORD 0


.code
main PROC
	mWriteString greetings
	TryAgain:
	prepReadVal  myString, sizeOfMyString, X, check
	

	push	EBX
	mov	EBX,check
	cmp	EBX,0
	JE	inputValid


	;examine the check variable. 1 = Error in input, 0 means its good.
	pop		EBX
	mClearString myString, sizeOfMyString
	mClearX	X
	mClearCheck	check
	JMP TryAgain

	inputValid:
	pop		EBX
	mAppendNum	storedNumbers, X, sizeOfStored
	mClearString myString, sizeOfMyString
	mClearX	X
	INC	sizeOfStored
	push	EBX
	mov	EBX,10
	cmp	sizeOfStored,EBX
	pop		EBX
	JL	TryAgain

	mPrintArray	storedNumbers
	

	exit
main ENDP

PrintUs	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+4]
	mov	ECX,0

	forEveryChar:
		mov	EAX,[EBX+ECX*4]
		mWriteDec EAX
		INC	ECX
		CMP	ECX,10
		JL	forEveryChar

	ret 4
PrintUs	ENDP

AppendNumber	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+8]
	mov	EDX,EBX ;EDX Has Offset of myArray exactly

	xor	EBX,EBX

	mov	EBX,[EBP+12]
	mov	EAX,[EBX]	;Location now lives in EAX

	xor	EBX,EBX

	mov	EBX,[EBP+4]
	mov	ECX,[EBX]	;MyNum now lives in ECX

	mov	[EDX+EAX*4],ECX
		
	ret	12
APpendNumber	ENDP

ClearCheck	PROC
	mov	EBP,ESP
	mov	EAX,0
	mov	EBX,[EBP+4]
	mov	[EBX],EAX
	ret	4
ClearCHeck	ENDP

ClearX	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+4]
	mov	EAX,0
	mov	[EBX],EAX
	ret 4
ClearX	ENDP

ClearString PROC
	mov	EBP,ESP
	mov EBX,[EBP+4]
	mov	ECX,[EBX]

	mov	ESI,[EBP+8]
	xor EBX,EBX
	mov	EBX,0
	forEveryChar:
		mov	EAX,0
		mov [ESI+EBX],EAX
		INC	EBX
		DEC	ECX
		CMP	ECX,0
		JNE	forEveryChar

	ret 8
ClearString ENDP

Convert	PROC
	mov	EBP,ESP

	mov	AL,[EBP+8]
	SUB	AL,48
	mov	[EBP+8],AL

	mov	EBX,[EBP+4]
	mov	EAX,[EBX]
	mov	EDX,10
	MUL	EDX

	ADD EAX,[EBP+8]

	mov	[EBX],EAX

	ret 8
Convert	ENDP

Verify	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+4]
	mov	ECX,[EBX]		;size of the array now lives in ECX
	

	cld
	mov	ESI,[EBP+8]
	forEveryChar:
		LODSB
		CMP	AL,48
		JL	INVALID
		CMP	AL,57
		JG	INVALID
		mConvert	EAX,[EBP+12]
		DEC	ECX
		CMP	ECX,0
		JE	FINISH
		JMP forEveryChar

		INVALID:
			mov	EAX,1
			mov	EBX,[EBP+16]
			mov	[EBX],EAX
			JMP	FINISH
	FINISH:
	ret	16
Verify	ENDP

ReadVal	PROC
	mov	EBP,ESP
	mGetString	[EBP+8],[EBP+4] ; @myString, @sizeOfMyString
	mVerify		[EBP+8],[EBP+4],[EBP+12],[EBP+16]	;
	mov	EBX,[EBP+16]
	mov	EBX,[EBX]
	CMP	EBX,1
	ret 16
ReadVal	ENDP

END main
