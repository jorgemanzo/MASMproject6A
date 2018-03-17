TITLE Project 6A     (project6a.asm)

; Author:	Jorge Manzo
; Course / Project ID  Project 6a     Date: Sunday of Finals Week
; Description: gets 10 valid integers from the user and stores the numeric values in an
; array.  The program then displays the integers, their sum, and their average.

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

prepReadVal MACRO gimmieNext, originalStringInput, holdByte, howLongIsTheirInput, X, errorFlag
	pushad
	push	OFFSET gimmieNext
	push	OFFSET originalStringInput
	push	OFFSET holdByte
	push	OFFSET howLongIsTheirInput
	push	OFFSET X
	push	OFFSET errorFlag
	call	ReadVal
	popad
ENDM

mGetString	MACRO originalStringInput,	howLongIsTheirInput, gimmieNext
	mWriteStringNoOffset gimmieNext
	mov		ECX,12
	mov		EDX,originalStringInput
	call	ReadString
	mov		EBX,howLongIsTheirInput
	mov		[EBX],EAX
ENDM


;Offset of errorFlag, Offset of X, Offset of howLongIsTheirInput, Offset of holdByte, Offset of  originalStringInput, Offset of gimmieNext
mVerify		MACRO errorFlag, X, howLongIsTheirInput, holdByte, originalStringInput
	pushad
	push	originalStringInput
	push	holdByte
	push	howLongIsTheirInput
	push	X
	push	errorFlag
	call	Verify
	popad
ENDM

;mConvert	[EBP+16],[EBP+8],[EBP+4]
mConvert MACRO holdByte, X, errorFlag
	pushad
	push	errorFlag
	push	holdByte
	push	X
	call	Convert
	popad
ENDM

mClearX		MACRO	X
	pushad
	push	OFFSET X
	call	ClearX
	popad
ENDM

mClearStringLitSize  MACRO originalStringInput, SizeOfMyString
	pushad
	push	OFFSET	originalStringInput
	push	SizeOfMyString
	call	ClearStringLitSize
	popad
ENDM

mClearStringLitSizeNoOFFSET  MACRO originalStringInput, SizeOfMyString
	pushad
	push	originalStringInput
	push	SizeOfMyString
	call	ClearStringLitSize
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


mGetMyLength	MACRO	myNumber, numberLength
	pushad
	push	myNumber
	push	numberLength
	call	howLongAmI
	popad
ENDM

mPrintArray	MACRO	numberArray, outString, numberLength
	pushad
	push	OFFSET	outString
	push	OFFSET	numberLength
	push	OFFSET	numberArray
	call	PrintUs
	popad
ENDM

prepWriteVal MACRO	myNumber, outString, lengthOfMyNum
	pushad
	push	lengthOfMyNum
	push	myNumber
	push	outString
	call	WriteVal
	popad
ENDM

mSumMyArray	MACRO	numberArray, numberLength, superSum
	pushad
	push	OFFSET numberArray
	push	OFFSET numberLength
	push	OFFSET superSum
	call	sumMeUp
	popad
ENDM

mGetAverage	MACRO	myNumber,	DivideBy, OutNum
	pushad	
	push	myNumber
	push	DivideBy
	push	OFFSET OutNum
	call	DivideMeBy
	popad
ENDM

.data
greetings	BYTE	"Hey. Give me 10 numbers, then Ill find some averages.",0

isYourInputBad	BYTE	"Is your input bad?:",0

yourInputIsBad	BYTE	"Please try giving input again. Your previous response was unacceptable",0

hereAreYourNums	BYTE	"Here are the numbers you gave me:",0

hereIsSum		BYTE	"Here is the sum of those numbers:",0

hereIsAverage	BYTE	"Here is your average:",0

gimmieNext			BYTE	"Please enter another number:",0
originalStringInput	BYTE	11	DUP(?)
holdByte			DWORD	0
howLongIsTheirInput	DWORD	0
X					DWORD	0
errorFlag			DWORD	0

index				DWORD	0
numberArray			DWORD	10	DUP(0)	;Array of numbers which we will sum later

numberLength		DWORD	0	;used to count how many characters make up a number
outString			BYTE	11	DUP(0)

averageOutString	BYTE	11	DUP(0)

superSum			DWORD	0	;sum of the numbers in the array
average				DWORD	0
.code
main proc
	mWriteString greetings
	mov	ECX,0		;We Will use this to keep track of the insertion indicie in our numberArray
	CollectTenNums:
		prepReadVal gimmieNext, originalStringInput, holdByte, howLongIsTheirInput, X, errorFlag
		;mWriteString	isYourInputBad
		;mWriteDec		errorFlag

		push	EBX
		mov	EBX,errorFlag
		cmp	EBX,0
		JE	inputGood

		pop	EBX
		mWriteString	yourInputIsBad
		mClearStringLitSize originalStringInput, howLongIsTheirInput

		push	EAX
		mov	EAX,0
		mov	howLongIsTheirInput,EAX
		pop	EAX

		mClearX	X
		mClearX	errorFlag
		JMP	CollectTenNums

		inputGood:
			pop	EBX
			mov	index,ECX
			mAppendNum	numberArray, X, index

			mClearStringLitSize originalStringInput, howLongIsTheirInput
			mClearX	X

			push	EAX
			mov	EAX,0
			mov	howLongIsTheirInput,EAX
			pop	EAX

			INC	ECX
			CMP	ECX,10
			JL	CollectTenNums

	mWriteString	hereAreYourNums

	mPrintArray	numberArray, outString, numberLength


	mWriteString	hereIsSum

	mSumMyArray numberArray, numberLength, superSum


	mClearX	numberLength

	mGetMyLength	superSum, OFFSET numberLength

	prepWriteVal	superSum, OFFSET outString, numberLength

	mWriteString	hereIsAverage

	mGetAverage	superSum,	10,	average

	;mWriteDec	Average

	mClearX	numberLength

	mGetMyLength	average, OFFSET numberLength

	prepWriteVal	average, OFFSET averageOutString, numberLength

	exit
main endp

DivideMeBy	PROC
	mov	EBP,ESP
	xor	EAX,EAX
	xor	EDX,EDX
	xor	ECX,ECX
	xor	EDI,EDI
	mov	EAX,[EBP+12]
	mov	ECX,[EBP+8]
	mov	EDI,[EBP+4]

	DIV	ECX
	mov	[EDI],EAX
	ret	12
DivideMeBy	ENDP

sumMeUp	PROC
	mov	EBP,ESP


	xor	EBX,EBX
	mov	EBX,[EBP+4]	;OFFSET of Supersum now lives in EBX
	mov	EAX,[EBX]	;De-ref OFFSET and store what lives there in EAX

	xor	EBX,EBX
	mov	EBX,[EBP+12] ;OFFSET of storedNumbers in EBX
	
	xor	ECX,ECX
	mov	ECX,0
	forEveryNum:
		ADD	EAX,[EBX+ECX*4]
		INC	ECX
		CMP	ECX,10
		JL	forEveryNum

	push	EBX
	xor		EBX,EBX
	mov		EBX,[EBP+4]
	mov		[EBX],EAX
	xor		EBX,EBX
	pop		EBX

	ret	12
sumMeUp	ENDP

writeVal	PROC
	mov	EBP,ESP

	mov	EBX,[EBP+12]


	mov	EAX,[EBP+4]

	xor	EDI,EDI
	ADD	EAX,EBX
	DEC	EAX
	mov	EDI,EAX

	xor	EAX,EAX
	xor	EBX,EBX

	mov	ECX,10
	mov	EAX,[EBP+8]
	STD
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
	ret	12
writeVal	ENDP

PrintUs	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+4]
	mov	ECX,0

	forEveryChar:
		mov	EAX,[EBX+ECX*4]
		;mWriteDec EAX
		xor	EDX,EDX
		mov	EDX,[EBP+12]
		xor	EDI,EDI
		
		
		mGetMyLength	EAX,[EBP+8]
		mov	EDI,[EBP+8]

		;prepWriteVal EAX (non offset), EDX (offset of outstring, [EDI+ECX*4] (non offset)
		mClearStringLitSizeNoOFFSET [EBP+12], 11
		;mWriteDec [EDI+ECX*4]

		prepWriteVal EAX, EDX, [EDI]
		INC	ECX
		CMP	ECX,10
		JL	forEveryChar

	ret 8
PrintUs	ENDP

howLongAmI	PROC
	mov	EBP,ESP
	xor	ECX,ECX
	xor	EAX,EAX
	xor	EDX,EDX
	xor	EBX,EBX
	mov	ECX,0
	mov	EAX,[EBP+8]
	mov	EBX,10
	UntilQuotientZero:
		xor	EDX,EDX
		DIV	EBX
		INC	ECX
		CMP	EAX,0
		JG	UntilQuotientZero

	xor	EAX,EAX
	xor	EDX,EDX
	mov	EAX,[EBP+4]
	mov	[EAX],ECX
	ret	8
howLongAmI	ENDP

AppendNumber	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+8]
	mov	EDX,EBX ;EDX Has Offset of myArray exactly

	xor	EBX,EBX

	mov	EBX,[EBP+12]
	mov	EAX,[EBX]	;Index now lives in EAX

	xor	EBX,EBX

	mov	EBX,[EBP+4]
	mov	ECX,[EBX]	;MyNum now lives in ECX

	mov	[EDX+EAX*4],ECX
	;mWriteDec [EDX+EAX*4]
		
	ret	12
AppendNumber	ENDP

ClearX	PROC
	mov	EBP,ESP
	mov	EBX,[EBP+4]
	mov	EAX,0
	mov	[EBX],EAX
	ret 4
ClearX	ENDP


ClearStringLitSize  PROC
	mov	EBP,ESP
	mov ECX,[EBP+4]

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
ClearStringLitSize  ENDP


Convert	PROC
	mov	EBP,ESP
	xor	EBX,EBX
	mov	EBX,[EBP+8] ;Move offset of HoldByte into EBX
	mov	EAX,[EBX]		;Deref offset of hold byte into EAX

	SUB	AL,48
	mov	[EBX],EAX	;Move into the deref'ed offset of holdByte the contents of EAX

	xor	EBX,EBX
	xor	EAX,EAX
	xor	EDX,EDX
	xor ECX,ECX

	mov	EBX,[EBP+4]	;move offset of X into EBX
	mov	EAX,[EBX]	;Move the deref'ed offset of X into EAX
	mov	ECX,10
	MUL	ECX			;Multiply the value in EAX by 10
	JC	BADINPUT

	xor	EBX,EBX
	mov	EBX,[EBP+8]	;move OFFSET of HoldByte into EBX
	ADD	EAX,[EBX]	;Add onto EAX, X * 10, the value stored in the deref'ed offset of holdbyte. If the number is too huge, this should trigger the Carry flag

	JC	BADINPUT

	xor	EBX,EBX
	mov	EBX,[EBP+4]
	mov	[EBX],EAX	;Save our new 'X' into the de'ref'ed offset of X
	JMP	FINISH

	BADINPUT:
		xor	EBX,EBX
		mov	EBX,[EBP+12]
		
		xor	EAX,EAX
		mov	EAX,1
		mov	[EBX],EAX

	FINISH:
	ret 12
Convert	ENDP

Verify	PROC
	mov	EBP,ESP
	mov	ECX,[EBP+12]	;Move offset of howLongIsTheirInput into ECX
	mov	ECX,[ECX]		;Deref and store in ECX
	CMP	ECX,10			;If their input is Less than 10, we will check just however long the string is, however, if it is equal to 10, than we must check all 10 characters
	JG	CHECKALL
	JMP	CHECKREQ
	
	CHECKALL:
		mov	ECX,11
		JMP	CHECKREQ
	CHECKREQ:

	cld
	mov	ESI,[EBP+20] ;Offset of original String input is now in ESI
	forEveryChar:
		LODSB	;Load one char into EAX's AL
		CMP	AL,48
		JL	BADINPUT
		CMP	AL,57
		JG	BADINPUT
		mov	EBX,[EBP+16]	;Move the offset of HoldByte into EBX
		mov	[EBX],EAX		;Store out suspect BYTE in EBX
		mov	EBX,[EBX]
		mConvert	[EBP+16],[EBP+8],[EBP+4]


		;Check for a set ErrorFlag
		xor	EDX,EDX
		mov	EDX,[EBP+4]	;move offset of ErrorFlag into EDX
		mov	EDX,[EDX]	;Deref that to get its value, saving in EDX
		CMP	EDX,1		;If EDX is 1, that means error flag is set, so we can jump to finish
		JE	FINISH


		DEC	ECX
		CMP	ECX,0
		JE	FINISH
		JMP	forEveryChar

		BADINPUT:
			mov	EAX,1
			mov	EBX,[EBP+4]
			mov	[EBX],EAX	;Set errorFlag to 1
			JMP	FINISH

	FINISH:
	ret	20
Verify	ENDP

ReadVal	PROC
	mov	EBP,ESP
	mGetString [EBP+20],[EBP+12],[EBP+24] ; Offset of originalString Input, Offset of howLongIsTheirInput, Offset of gimmieNext
	mVerify		[EBP+4],[EBP+8],[EBP+12],[EBP+16],[EBP+20] ;Offset of errorFlag, Offset of X, Offset of howLongIsTheirInput, Offset of holdByte, Offset of  originalStringInput
	ret	24
ReadVal	ENDP
end main