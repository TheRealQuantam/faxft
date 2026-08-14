.macpack common

.include "nes.inc"
.include "mmc3.inc"

NmiHandler := $c999
OriginalResetHandler := $c913


.segment "ZEROPAGE" : zp

.org $11
; The previous bank index when the game temporarily changes the bank
Saved16kBank: .byte 0

CurBankCtrl: .byte 0 ; Mirror of BankCtrlReg necessary for interrupt safety

.org $55 ; 2 bytes available
; The bank register mirrors necessary for interrupt safety
CurBank8: .byte 0
CurBankA: .byte 0


.segment "RAM"

.org $100
; Current 16 KB bank set by the game. May not actually be correct if custom code has modified the 8 KB banks individually, but it is used by the game to restore the bank after temporarily changing it.
Cur16kBank: .byte 0

.org $182 ; 8 bytes available
Saved8kBank: .byte 0 ; Saved bank number when temporarily switching one of the 8 KB banks in the game.


.segment "MMC3_HIRAM"

; Generated during NMI, applied during scanline IRQ
PlayfieldPpuCtrl: .byte 0
PlayfieldScrollX: .byte 0


.segment "HEADER"

.org 6
	.byte $40 ; MMC3


.segment "BANKF"

.org $c972 ; Inside NMI, 14 bytes available
	; 9 bytes
	jsr CallUpdateSound
	jsr RestoreBanksNmi
	
	jmp $c9d0
	
FREE_UNTIL $c989

.org $c9b7 ; Inside NMI, 14 bytes available
	; 9 bytes
	jsr CallUpdateSound
	jsr RestoreBanksNmi
	
	jmp PostUpdateMusic2
	
Switch16kBankNmi: ; a bytes
	txa
	asl a
	tax
	jsr SwitchBank8Nmi
	
	inx
	jmp SwitchBankANmi
	
FREE_UNTIL $c9cb

PostUpdateMusic2:

.org $ca02 ; f bytes available
SetupScanlineIrq:
	; The place where the original game waits for the status bar to be drawn and changes the scroll position
	; Okay to clobber X
	; 1e bytes
	lda PpuStatus_2002
	
	lda $d
	and #$1
	ora $a
	sta PlayfieldPpuCtrl
	
	jmp @Part2
	
FREE_UNTIL $ca11

.reloc
@Part2:
	lda $c
	sta PlayfieldScrollX
	
	lda #$20
	sta IrqDisableReg
	sta IrqCounterReg
	sta IrqReloadReg
	sta IrqEnableReg
	
	cli
	
	rts
	
.org $cbbf ; 56 bytes available

SetInitialBank: ; 28 bytes
	sta IrqDisableReg
	
	; Disable frame counter interrupt as it's never disabled before
	lda #$40
	sta Ctrl2_FrameCtr_4017
	lda ApuStatus_4015
	
	; Mode must have already been set up as the main function is in Cxxx bank
	; Set up the CHR banks
	ldx #(SWITCH_BANK_8 - 1)

-:
	stx BankCtrlReg
	lda @InitialChrBanks, x
	sta BankReg
	
	dex
	bpl -
	
	lda #MIRROR_VERTICAL
	sta MirrorReg
	
	lda #DISABLE_PRG_RAM_PROTECTION
	sta PrgRamProtectReg
	
	ldx #$e
	stx Saved16kBank
	
	cli

	jmp Switch16kBank
	
@InitialChrBanks:
	.byte 0, 2, 4, 5, 6, 7
	
.ifndef MMC3_NO_DEFINE_CALL_UPDATE_SOUND

CallUpdateSound:
	ldx #NAT_SOUND_BANK
	jsr Switch16kBankNmi
	
	jsr UpdateNativeMusic
	jsr UpdateNativeSfx
	
	rts

.endif ; .ifndef MMC3_NO_DEFINE_CALL_UPDATE_SOUND	

FREE_UNTIL $cc15

.org $cc1a ; 6b bytes available

Switch16kBank: ; 21 bytes
	; Must maintain x value
	stx Cur16kBank
	txa
	
	ldx #SWITCH_BANK_8
	stx CurBankCtrl
	stx BankCtrlReg
	
	asl a
	sta CurBank8
	sta BankReg
	
	inx
	stx CurBankCtrl
	stx BankCtrlReg
	
	ora #$1
	sta CurBankA
	sta BankReg
	
	; Some callers depend on this final state
	ldx Cur16kBank
	lda #$0
	
	rts
	
IrqHandler:
	sta IrqDisableReg
	
	pha
	txa
	pha
	tya
	pha
	

	ldx #$7

-
	dex
	bne -
	
	nop
	
	ldx PlayfieldPpuCtrl
	lda PlayfieldScrollX
	and #%11111000
	
	; Write coarse X position (deferred) with old fine X position (immediate) before hblank
	stx PpuCtrl_2000
	sta PpuScroll_2005
	lda PpuStatus_2002
	
	lda PlayfieldScrollX
	nop
	nop
	
	; Write fine X position (immediate) during hblank
	sta PpuScroll_2005
	lda PpuStatus_2002
	
	pla
	tay
	pla
	tax
	pla
	
	rti
	
FREE_UNTIL $cc85
	
.org $cc85 ; 62 byte hole

SwitchBank8Nmi: ; 9 bytes
	lda #SWITCH_BANK_8
	sta BankCtrlReg
	stx BankReg
	
	rts
	
SwitchBankANmi: ; 9 bytes
	lda #SWITCH_BANK_A
	sta BankCtrlReg
	stx BankReg
	
	rts
	
RestoreBanksNmi: ; 19 bytes
	ldx #SWITCH_BANK_8
	stx BankCtrlReg
	lda CurBank8
	sta BankReg
	
	inx
	stx BankCtrlReg
	lda CurBankA
	sta BankReg
	
	lda CurBankCtrl
	sta BankCtrlReg
	
	rts
	
SaveAndSwitchBank8: ; 5 bytes
	lda CurBank8
	sta Saved8kBank
	
SwitchBank8: ; d bytes
	lda #SWITCH_BANK_8
	sta CurBankCtrl
	sta BankCtrlReg
	
	stx CurBank8
	stx BankReg
	
	rts
	
RestoreSavedBank8: ; 6 bytes
	ldx Saved8kBank
	jmp SwitchBank8

SaveAndSwitchBankA: ; 5 bytes
	lda CurBankA
	sta Saved8kBank
	
SwitchBankA: ; d bytes
	lda #SWITCH_BANK_A
	sta CurBankCtrl
	sta BankCtrlReg
	
	stx CurBankA
	stx BankReg
	
	rts
	
RestoreSavedBankA: ; 6 bytes
	ldx Saved8kBank
	jmp SwitchBankA
	
FREE_UNTIL $cce7

.org $ffd7
NewResetHandler: ; 9 bytes
	sei
	lda #$0
	sta BankCtrlReg
	
	jmp OriginalResetHandler
	
.org $fffa
	.word NmiHandler, NewResetHandler, IrqHandler
	