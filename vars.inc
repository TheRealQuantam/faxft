.segment "ZEROPAGE" : zp

.org $2
TempPtr: .word 0

.org $24
AreaIdx: .byte 0 ; The current area/world

.org $8d
AreaDoorLocationsPtr: .word 0

.org $9c ; 1 byte available
GameTemp: .byte 0 ; Temporary used outside interrupts

.org $fa
; These have the format piii iiii where i is the index and p indicates whether playback has begun. p is NOT used when n = 0 (no music/SFX), causing ambiguity.
MusicIdx: .byte 0
SfxIdx: .byte 0


.segment "BHOP_ZEROPAGE_COPY" : zp
; Temporaries used in NMI
NmiTempPtr: .word 0
NmiTemp: .byte 0


.segment "RAM"

.org $120
IsPaused: .byte 0

.org $3d1
ZoneMusicIdx: .byte 0 ; The current sone's music
OutsideMusicIdx: .byte 0 ; Saved music when in a building

.org $439
SpawnPointIdx: .byte 0 ; The current spawn point index


.segment "FT_HIRAM"

ZoneIdx: .byte 0 ; Zone the player is currently in
OutsideZoneIdx: .byte 0 ; Saved when entering a town building
TgtZoneIdx: .byte 0 ; Temporary set when a transition might occur
TgtZoneTrackIdx: .byte 0 ; Temporary music track of TgtZoneIdx

CurState: .byte 0
CurFtBank: .byte 0 ; Bank of the currently playing FT track, if any
PrevSfxChans: .byte 0 ; Mask of channels that were in use by SFX the previous frame, in ApuStatus_4015 order.

; Parameters for a new FT track to play, passed between update phases
FtTrackToPlay: .byte 0 ; Negative if none
TrackBankToPlay: .byte 0

; PrevFtTrack: .byte 0 ; Negative if none
; SavedFtTrack: .byte 0 ; Negative if none
; SavedFtBank: .byte 0

; FtSaveBuff: .res FT_SAVE_BUFF_SIZE
