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

mWriteStringNoOffset	MACRO	myString
	pushad
	mov		EDX,myString
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


prepReadVal MACRO myString, sizeOfMyString, X, check, gimmieNext
	pushad
	push	OFFSET	gimmieNext
	push	OFFSET	check
	push	OFFSET	X
	push	OFFSET	myString
	push	OFFSET	sizeOfMyString
	call	ReadVal
	popad
ENDM

mGetString	MACRO myString,	sizeOfMyString, gimmieNext
	mWriteStringNoOffset gimmieNext
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

mPrepWriteVal	MACRO	myNum	;TO DO Write this Macro Wrapper for the yet to be written WriteVal Proc
	;pushad
	;push	
ENDM

mSumMyArray	MACRO	storedNumbers, sizeOfStored, superSum
	pushad
	push	OFFSET storedNumbers
	push	OFFSET sizeOfStored
	push	OFFSET superSum
	call	sumMeUp
	popad
ENDM

prepWriteVal MACRO	myNumber, outString
	pushad
	push	myNumber
	push	OFFSET	outString
	call	WriteVal
	popad
ENDM

.data
myString	BYTE	11	DUP(?)
tempString	BYTE	11	DUP(0)
outString	BYTE	11	DUP(0)
greetings	BYTE	"Hey. Give me 10 numbers, then Ill find some averages.",0
badInput	BYTE	"OH. MY. GOD. HOW COULD YOU GIVE ME BAD INPUT?? OVO Rethink and try again.",0
gimmieNext	BYTE	"Okay, give me a number:",0
yourInput	BYTE	"You entered the following numbers:",0
yourSumIs	BYTE	"Your sum is:",0
storedNumbers	DWORD 10 DUP(0)
sizeOfStored	DWORD 0
sizeOfMyString	DWORD 0
zeroToSize		DWORD 0
X				DWORD 0
superSum		DWORD 0
check			DWORD 0


.code
main PROC
	mWriteString greetings
	TryAgain:

	prepReadVal  myString, sizeOfMyString, X, check, gimmieNext
	

	push	EBX
	mov	EBX,check
	cmp	EBX,0
	JE	inputValid


	;examine the check variable. 1 = Error in input, 0 means its good.
	pop		EBX
	mWriteString badInput
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

	mWriteString yourInput

	mPrintArray	storedNumbers

	mSumMyArray storedNumbers, sizeOfStored, superSum

	mWriteString yourSumIs

	mWriteDec superSum

	prepWriteVal 123, outString


	exit
main ENDP

writeVal	PROC
	mov	EBP,ESP

	mov	EBX,[EBP+4]
	ADD	EBX,10
	mov	EDI,EBX
	mov	ECX,10
	mov	EAX,[EBP+8]
	CLD
	forEveryCharInNum:
		xor	EDX,EDX
		DIV	ECX
		ADD	EDX,48
		push	EAX
		xor	EAX,EAX
		mov	AL,DL
		STOSB
		xor	EAX,EAX
		pop	EAX
		CMP	EAX,0
		JG	forEveryCharInNum
		

	mWriteStringNoOffset [EBP+4]
	ret	8
writeVal	ENDP

sumMeUp	PROC
	mov	EBP,ESP

	mov	EBX,[EBP+8]	;OFFSET of SizeOfStored in EBX
	mov	EDX,[EBX]	;De-ref OFFSET and store what lives there in EDX

	xor	EBX,EBX
	mov	EBX,[EBP+4]	;OFFSET of Supersum now lives in EBX
	mov	EAX,[EBX]	;De-ref OFFSET and store what lives there in EAX

	xor	EBX,EBX
	mov	EBX,[EBP+12] ;OFFSET of storedNumbers in EBX
	
	xor	ECX,ECX
	forEveryNum:
		ADD	EAX,[EBX+ECX*4]
		INC	ECX
		CMP	ECX,EDX
		JL	forEveryNum

	push	EBX
	mov		EBX,[EBP+4]
	mov		[EBX],EAX
	pop		EBX

	ret	12
sumMeUp	ENDP

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
	mGetString	[EBP+8],[EBP+4],[EBP+20] ; @myString, @sizeOfMyString, @gimmieNext
	mVerify		[EBP+8],[EBP+4],[EBP+12],[EBP+16]	;
	mov	EBX,[EBP+16]
	mov	EBX,[EBX]
	CMP	EBX,1
	ret 20
ReadVal	ENDP

END main
