.ifndef MMC3_INC
.define MMC3_INC

BankCtrlReg = $9ffc
BankReg = $9ffd
MirrorReg = $bffc
PrgRamProtectReg = $bffd
IrqCounterReg = $dffc
IrqReloadReg = $dffd
IrqDisableReg = $fffc
IrqEnableReg = $fffd

SWITCH_BANK_8 = 6
SWITCH_BANK_A = 7

MIRROR_VERTICAL = 0
MIRROR_HORIZONTAL = 1

DISABLE_PRG_RAM_PROTECTION = $80

.globalzp Saved16kBank, CurBankCtrl, CurBank8, CurBankA
.global Cur16kBank, Saved8kBank

.global Switch16kBank, Restore16kBank
.global SaveAndSwitchBank8, SwitchBank8, RestoreSavedBank8
.global SaveAndSwitchBankA, SwitchBankA, RestoreSavedBankA
.global Switch16kBankNmi, SwitchBank8Nmi, SwitchBankANmi
.global CallUpdateSound

.endif ; .ifndef MMC3_INC
