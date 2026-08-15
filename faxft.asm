.macpack common

.include "build.inc"
.include "nes.inc"
.include "mmc3.inc"
.include "bhop.inc"
.include "constants.inc"
.include "vars.inc"
.include "data_tables.inc"

.segment "HEADER"

.org 4
	.byte $20 ; Number of 16 KB banks
	

.segment "BANKF"

.reloc

CallUpdateSound: ; 1d bytes
	ldx #NAT_SOUND_BANK
	jsr Switch16kBankNmi
	
	jsr UpdateSoundPart1
	
	;ldx CurNatBank
	;jsr SwitchBankANmi
	
	jsr UpdateNativeMusic
	jsr UpdateNativeSfx
	
	ldx #<.bank(UpdateSoundPart2)
	jsr SwitchBank8Nmi
	
	jsr UpdateSoundPart2
	
	rts
	
.org $dd9f
	; In Game_SpawnInTemple: Set the current (outside) and target (inside) zones and music when respawning from death or password
	; Okay to clobber A and X
	
	; LDA #$0e
	; STA a:ZoneMusicIdx <-
	jsr +
	
.reloc
+:
	ldx #<.bank(SetRespawnZonesAndMusic)
	jsr SaveAndSwitchBank8
	
	jsr SetRespawnZonesAndMusic
	
	jmp RestoreSavedBank8
	
.org $dde6
	; In EndGame_MoveToKingsRoom: Set the zone and music indices
	; Okay to clobber A and X
	
	; LDA #$0d
	; STA a:ZoneMusicIdx <-
	jsr +
	
.reloc
+:
	ldx #<.bank(SetEndingZoneAndMusic)
	jsr SaveAndSwitchBank8
	
	jsr SetEndingZoneAndMusic
	
	jmp RestoreSavedBank8
	
.org $de0b ; 5 bytes
	; In Game_EnterBuilding: Save the zone and outdoor music indices when entering a building and start the new track if different
	
	; LDA a:ZoneMusicIdx
	; STA MusicIdx
	jsr +
	nop
	nop
	
.reloc
+:
	lda ZoneIdx
	sta OutsideZoneIdx
	
	lda TgtZoneIdx
	sta ZoneIdx
	
PlayIndoorTrackIfDifferent:
	LDA ZoneMusicIdx
	cmp OutsideMusicIdx
	beq +
	
	sta MusicIdx
	
+:
	rts
	
.org $de6c
	; In Game_ExitBuilding: Start the music track if different
	; NOTE: For the check to work the indoor and outdoor music indices must have been swapped previously.
	
	; LDA a:ZoneMusicIdx
	; STA MusicIdx
	jsr PlayIndoorTrackIfDifferent
	nop
	nop
	
.org $dee6
	; In Game_LoadFirstLevel: Set the initial area and zone
	; Should preserve X as AreaIdx ??
	
	; LDA a:AREA_TO_MUSIC_TABLE,X
	jsr +
	
.reloc
+:
	ldx #<.bank(SetInitialZoneAndMusicIdx)
	jsr SaveAndSwitchBank8
	
	jsr SetInitialZoneAndMusicIdx
	
	jsr RestoreSavedBank8
	
	ldx AreaIdx
	lda TgtZoneTrackIdx
	
	rts
	
.org $df29
	; In Game_LoadCurrentArea: Set the music track when transitioning between worlds. Set zone while we're at it.
	
	; LDA a:AREA_TO_MUSIC_TABLE,X
	jsr SetZoneAndLoadMusicIdx
	; STA MusicIdx
	
.reloc

SetZoneAndLoadMusicIdx:
	lda TgtZoneIdx
	sta ZoneIdx
	
	lda TgtZoneTrackIdx
	
	rts
	
.org $df81
	; In Game_EnterAreaHandler: Set the music track when performing a non-door transition
	; ZoneIdx is already set
	
	; LDA a:AREA_TO_MUSIC_TABLE,X
	lda a:TgtZoneTrackIdx
	; STA MusicIdx
	; STA a:ZoneMusicIdx
	
.org $e556 ; 5 bytes
	; In Player_CheckHandleEnterDoor: Set the music track when entering a same world door. Set zone while we're at it.
	; Eliminate the skip so zone is always set and music is always checked
	
	; BMI @_enterScreen
	; LDA a:Music_ARRAY_PRG15_MIRROR__e570,X
	nop
	nop
	jsr SetZoneAndLoadMusicIdx
	
.org $e597
	; In Player_EnterDoorToInside: Set the music track when entering a building
	
	; LDA a:BUILDING_MUSIC,X
	lda a:TgtZoneTrackIdx
	; STA ZoneMusicIdx
	
.org $e84f
	; In Area_SetStateFromDoorDestination: Finish up after door has been found

	; JMP @_restoreBankAndReturn [e866]
	jmp +
	
FREE_UNTIL $e852

.reloc
+:
	; Just found a matching door. Need to generate TgtZoneIdx.
	; $2 is the current door entry pointer. Okay to clobber X, use $6a as temp.
	
	ldx #<.bank(SetTgtZoneFromDoor)
	jsr SwitchBank8
	
	jmp SetTgtZoneFromDoor
	
.org $ea59
	; In Game_BeginExitBuilding: Restore the outdoor zone and music when leaving a building.
	
	; LDA a:OutsideMusicIdx
	; STA a:ZoneMusicIdx <-
	jsr +
	
.reloc
+:
	; Need to be able to subsequently determine whether the outdoor music is the same as the indoor music. So instead of just setting the current music to the outdoor music, swap them.
	pha
	lda ZoneMusicIdx
	sta OutsideMusicIdx
	pla
	
	sta ZoneMusicIdx

	lda OutsideZoneIdx
	sta ZoneIdx
	
	rts
	
.org $ea6c
	; In Player_CheckSwitchScreen_SwitchAreaHoriz
	; At the initialization of the transition list scan
	
	; LDA a:AREA_TOWN_TRANSITIONS_DATA+1,Y
	jsr +
	; STA Temp_Addr_U
	
FREE_UNTIL $ea6f

.reloc
+:
	lda #$0
	sta GameTemp ; List index
	
	LDA $ea9c+1,Y ; AREA_TOWN_TRANSITIONS_DATA
	
	rts
	
.org $ea7d
	; In Player_CheckSwitchScreen_SwitchAreaHoriz
	; Found the transition and starting to perform it
	
	; INY
	; LDA (TempPtr),Y
	jsr +
	
.reloc
+:
	; Get the target zone
	txa
	pha
	
	ldx #<.bank(SetZoneFromTrans)
	jsr SaveAndSwitchBank8
	
	jsr SetZoneFromTrans
	
	jsr RestoreSavedBank8

	pla
	tax
	
	INY
	LDA (TempPtr),Y
	
	rts
	
.org $ea94; 4 bytes
	; In Player_CheckSwitchScreen_SwitchAreaHoriz
	; Advancing after the current transition entry didn't match
	
	; TYA
	; CLC
	; ADC #$05
	jsr +
	nop
	
.reloc
+:
	inc GameTemp
	
	TYA
	CLC
	ADC #$05
	
	rts

	
.segment "BANK5"

.org $8018
	; Ensure native music only plays when playing native music
	
	; JMP UpdatePlayingNativeMusic
	jmp CheckForNativeMusic
	
.org $802a ; 4 bytes available
	; Hook initialization
	
	; STA $0121
	; RTS
	
	jmp InitializeCont
	
FREE_UNTIL $802e

.org $807f ; 12 bytes
	; Load the channel data pointers from NmiTempPtr passed from UpdateSoundPart1 rather than from the track channels table directly.
	; Can clobber A, but X must be 0 at the end

	; e bytes
	ldy #$7

-:
	lda (NmiTempPtr), y
	sta $f2, y
	
	dey
	bpl -
	
	ldx #$0
	beq +
	
FREE_UNTIL $8092

+:

.reloc

UpdateSoundPart1:
	;;; TODO: Support pause and restore?
	lda MusicIdx
	bmi @Done
	bne @BeginTrack
	
@IsStop:
	lda CurState
	beq @Done
	
	cmp #PLAYING_NAT
	beq @Stop
	
@StopFt:
	;lda #NO_FT_TRACK_TO_PLAY
	;sta PrevFtTrack
	;sta SavedFtTrack
	
@Stop:
	lda #NOT_PLAYING
	sta CurState
	
@Done:
	rts
	
@BeginTrack:
	asl a
	tax
	
	ldy TrackMap + 1, x
	bpl @NotStopTrack
	
@IsStopTrack:
	lda #$0
	sta MusicIdx
	
	beq @Stop
	
@NotStopTrack:
	lda TrackAddrMap, x
	sta NmiTempPtr
	lda TrackAddrMap + 1, x
	sta NmiTempPtr + 1
	
	lda TrackMap, x
	bmi @IsFtTrack
	
@IsNatTrack:
	cpy #$0
	beq @IsStopTrack
	
	sty MusicIdx
	
	lda #PLAYING_NAT
	sta CurState
	
	rts
	
@IsFtTrack:
	eor #$ff
	sta TrackBankToPlay
	sty FtTrackToPlay
	
	; Playback has started
	lda MusicIdx
	ora #$80
	sta MusicIdx
	
	lda #PLAYING_FT
	sta CurState
	
	rts
	
.reloc
CheckForNativeMusic:
	; Okay to clobber A
	lda CurState
	cmp #PLAYING_FT
	bne @NotFt
	
	; Do not update music if playing FT
	rts
	
@NotFt:
	jmp UpdatePlayingNativeMusic
	
.reloc
InitializeCont:
	STA $0121

	;lda #NO_FT_TRACK_TO_PLAY
	sta FtTrackToPlay
	;sta PrevFtTrack
	;sta SavedFtBank
	;sta SavedFtTrack
	
	lda #NOT_PLAYING
	sta CurState
	
	;lda #(NAT_SOUND_BANK * 2 + 1)
	;sta CurNatBank
	
	lda #$0
	sta global_attenuation

	rts
	

.segment "BANKE"

.org $a003
	; In SpriteBehavior_ShadowEura: Load the last boss music index
	
	; LDA #$0a
	lda #LAST_BOSS_TRACK_IDX
	
	
.segment "FT_CODE"

UpdateSoundPart2:
	lda CurState
	cmp #PLAYING_FT
	beq @PlayingFt

	rts
	
@PlayingFt:
	lda FtTrackToPlay
	bmi @NoTrackToPlay
	
@BeginFtTrack:
	ldx TrackBankToPlay
	stx CurFtBank
	
	pha
	jsr SwitchBankANmi
	pla
	
	ldx NmiTempPtr
	ldy NmiTempPtr + 1
	
	jsr bhop_init
	
	ldx #$0
	stx PrevSfxChans
	
	dex
	stx FtTrackToPlay
	
@NoTrackToPlay:
	lda IsPaused
	beq @NotPaused
	
@IsPaused:
	lda PrevSfxChans
	eor #$f
	beq @AlreadyPaused
	
	jsr bhop_mute_channels

	lda #$f
	sta PrevSfxChans
	
@AlreadyPaused:
	rts
	
@NotPaused:
	; Assemble SFX channel mask
	lda #$0
	sta NmiTemp
	
.repeat 4, i
	lda $123 + 3 - i
	cmp #$1
	rol NmiTemp
.endrepeat

	lda NmiTemp
	cmp PrevSfxChans
	beq @DoneWithMuteCheck
	
	eor #$ff
	and PrevSfxChans
	beq @NoUnmuteChans
	
	jsr bhop_unmute_channels
	
@NoUnmuteChans:
	lda PrevSfxChans
	eor #$ff
	and NmiTemp
	beq @NoMuteChans
	
	jsr bhop_mute_channels
	
@NoMuteChans:
	lda NmiTemp
	sta PrevSfxChans
	
@DoneWithMuteCheck:
	ldx CurFtBank
	jsr SwitchBankANmi

	jsr bhop_play
	
	rts
	
SetInitialZoneAndMusicIdx:
	ldx #ZONE_ID::EOLIS_ENTRANCE
	stx ZoneIdx
	lda ZoneTrackMap, x
	sta TgtZoneTrackIdx
	
	rts

SetRespawnZonesAndMusic:
	lda SpawnPointIdx
	asl a
	tax

	lda SpawnZones, x ; Outdoor zone
	sta ZoneIdx
	lda SpawnZones + 1, x ; Indoor zone
	sta TgtZoneIdx
	
	tax
	lda ZoneTrackMap, x
	sta ZoneMusicIdx

	ldx ZoneIdx
	lda ZoneTrackMap, x
	sta OutsideMusicIdx
	
	rts
	
SetTgtZoneFromDoor:
	; Calculate door index in area from the current door pointer
	lda TempPtr
	sec
	sbc AreaDoorLocationsPtr
	lsr a
	lsr a
	
	; Find the target zone and track
	ldx AreaIdx
	clc
	adc DoorZoneMap, x
	tax
	lda DoorZoneMap, x
	sta TgtZoneIdx
	
	tax
	lda ZoneTrackMap, x
	sta TgtZoneTrackIdx
	
	jmp $e866
	
SetZoneFromTrans:
	lda GameTemp
	ldx AreaIdx
	clc
	adc TransZoneMap, x
	tax
	lda TransZoneMap, x
	sta ZoneIdx
	
	tax
	lda ZoneTrackMap, x
	sta TgtZoneTrackIdx ; Music gets set later

	rts

SetEndingZoneAndMusic:
	ldx #(MAX_ZONES - SPECIAL_ZONE_ID::NUM_SPECIAL_ZONE_IDS + SPECIAL_ZONE_ID::ENDING_THRONE_ROOM)
	stx TgtZoneIdx
	
	lda ZoneTrackMap, x
	sta ZoneMusicIdx
	
	rts
