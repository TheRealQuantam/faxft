.include "constants.inc"

;.segment "TRACK_MAP"
.segment "BANK5"
.org $8000 + NAT_SOUND_CODE_SIZE ;;; TEMP

; Index 0 (stop playback) is included but not used
TrackMap:
.repeat NUM_NAT_TRACKS, i
	.byte NAT_SOUND_BANK * 2 + 1, i
.endrepeat

	.byte NAT_SOUND_BANK * 2 + 1, BOSS_TRACK_IDX

	.res (MAX_TRACKS - EXP_NUM_NAT_TRACKS) * 2, $ff

TrackAddrMap:
	.word 0
	
.repeat NUM_NAT_TRACKS - 1, i
	.word NativeTrackTable + i * 8
.endrepeat

	.word NativeTrackTable + (BOSS_TRACK_IDX - 1) * 8
	
.repeat MAX_TRACKS - EXP_NUM_NAT_TRACKS
	.word $a000
.endrepeat


.segment "FT_CODE_TABLES"

.res $20, 0

ZoneTrackMap:
	.byte TRACK_ID::EOLIS
	.byte TRACK_ID::EOLIS
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::THRONE_ROOM
	
	.byte TRACK_ID::TRUNK
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::TRUNK
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::TRUNK
	.byte TRACK_ID::TOWER
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::MIST
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::MIST
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::MIST
	.byte TRACK_ID::TOWER
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::BRANCH
	.byte TRACK_ID::BRANCH
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::BRANCH
	.byte TRACK_ID::BRANCH
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::BRANCH
	
	.byte TRACK_ID::DWARF
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::TOWER
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::TOWER
	
	.byte TRACK_ID::TOWN
	.byte TRACK_ID::CHURCH
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	.byte TRACK_ID::SHOP
	
	.byte TRACK_ID::ZENIS
	
	.res MAX_ZONES - ZONE_ID::NUM_ZONE_IDS - SPECIAL_ZONE_ID::NUM_SPECIAL_ZONE_IDS, TRACK_ID::SILENCE
	
	.byte TRACK_ID::EOLIS
	.byte TRACK_ID::THRONE_ROOM
	
DoorZoneMap:
	.byte <(@Eolis - DoorZoneMap)
	.byte <(@Trunk - DoorZoneMap)
	.byte <(@Mist - DoorZoneMap)
	.byte <(@Towns - DoorZoneMap)
	.byte <(@Buildings - DoorZoneMap)
	.byte <(@Branch - DoorZoneMap)
	.byte <(@Dwarf - DoorZoneMap)
	.byte <(@Zenis - DoorZoneMap)
	.res MAX_AREAS - NUM_AREAS, 0
	
@Eolis:
	.byte ZONE_ID::EOLIS
	.byte ZONE_ID::EOLIS_BUTCHER
	.byte ZONE_ID::EOLIS_HOUSE
	.byte ZONE_ID::EOLIS_CHURCH
	.byte ZONE_ID::EOLIS_LOCKSMITH
	.byte ZONE_ID::EOLIS_VENDOR
	.byte ZONE_ID::EOLIS_WIZARD
	.byte ZONE_ID::EOLIS_GYM
	.byte ZONE_ID::EOLIS_CASTLE
	.byte ZONE_ID::TRUNK_1
	
@Trunk:
	.byte ZONE_ID::MIST_1
	.byte ZONE_ID::TOWER_OF_TRUNK
	.byte ZONE_ID::TRUNK_2
	.byte ZONE_ID::TOWER_OF_FORTRESS
	.byte ZONE_ID::TRUNK_3
	.byte ZONE_ID::TOWER_OF_FIRST_SPRING
	.byte ZONE_ID::TRUNK_3
	.byte ZONE_ID::TRUNK_1_VENDOR
	.byte ZONE_ID::TOWER_OF_FORTRESS_CHURCH
	
@Mist:
	.byte ZONE_ID::TOWER_OF_SUFFER
	.byte ZONE_ID::TOWER_OF_MIST
	.byte ZONE_ID::MIST_3_TOWER_OF_RED_POTION
	.byte ZONE_ID::MIST_1_TOWER_OF_RED_POTION
	.byte ZONE_ID::MIST_2
	.byte ZONE_ID::MIST_3
	.byte ZONE_ID::MIST_1
	.byte ZONE_ID::MIST_3
	.byte ZONE_ID::MIST_3_FIRE_MAGE
	.byte ZONE_ID::MIST_2_BAR
	.byte ZONE_ID::MIST_2_CHURCH
	.byte ZONE_ID::MIST_2_DOCTOR
	.byte ZONE_ID::MIST_2_VENDOR
	.byte ZONE_ID::MIST_2_HOUSE
	.byte ZONE_ID::MIST_3_HOUSE
	.byte ZONE_ID::TRUNK_3
	.byte ZONE_ID::BRANCH_1
	
@Towns:
	.byte ZONE_ID::APOLUNE_VENDOR
	.byte ZONE_ID::APOLUNE_LOCKSMITH
	.byte ZONE_ID::APOLUNE_BAR
	.byte ZONE_ID::APOLUNE_CHURCH
	.byte ZONE_ID::APOLUNE_DOCTOR
	.byte ZONE_ID::APOLUNE_HOUSE
	.byte ZONE_ID::FOREPAW_BUTCHER
	.byte ZONE_ID::FOREPAW_VENDOR
	.byte ZONE_ID::FOREPAW_CHURCH
	.byte ZONE_ID::FOREPAW_DOCTOR
	.byte ZONE_ID::FOREPAW_HOUSE
	.byte ZONE_ID::FOREPAW_LOCKSMITH
	.byte ZONE_ID::MASCON_BAR
	.byte ZONE_ID::MASCON_BUTCHER
	.byte ZONE_ID::MASCON_VENDOR
	.byte ZONE_ID::MASCON_LOCKSMITH
	.byte ZONE_ID::MASCON_HOUSE
	.byte ZONE_ID::MASCON_DOCTOR
	.byte ZONE_ID::VICTIM_CHURCH
	.byte ZONE_ID::VICTIM_DOCTOR
	.byte ZONE_ID::VICTIM_HOUSE
	.byte ZONE_ID::VICTIM_BUTCHER
	.byte ZONE_ID::VICTIM_LOCKSMITH
	.byte ZONE_ID::VICTIM_BAR
	.byte ZONE_ID::VICTIM_VENDOR
	.byte ZONE_ID::CONFLATE_HOUSE
	.byte ZONE_ID::CONFLATE_BUTCHER
	.byte ZONE_ID::CONFLATE_CHURCH
	.byte ZONE_ID::CONFLATE_DOCTOR
	.byte ZONE_ID::CONFLATE_VENDOR
	.byte ZONE_ID::CONFLATE_BAR
	.byte ZONE_ID::DAYBREAK_LOCKSMITH
	.byte ZONE_ID::DAYBREAK_VENDOR
	.byte ZONE_ID::DAYBREAK_BUTCHER
	.byte ZONE_ID::DAYBREAK_BAR
	.byte ZONE_ID::DAYBREAK_CHURCH
	.byte ZONE_ID::DAYBREAK_HOUSE
	.byte ZONE_ID::DARTMOOR_CHURCH
	.byte ZONE_ID::DARTMOOR_BAR
	.byte ZONE_ID::DARTMOOR_BUTCHER
	.byte ZONE_ID::DARTMOOR_DOCTOR
	.byte ZONE_ID::DARTMOOR_LOCKSMITH
	.byte ZONE_ID::DARTMOOR_VENDOR
	
@Buildings:

@Branch:
	.byte ZONE_ID::BRANCH_1B
	.byte ZONE_ID::BRANCH_1
	.byte ZONE_ID::BRANCH_2
	.byte ZONE_ID::BRANCH_1
	.byte ZONE_ID::BRANCH_3
	.byte ZONE_ID::BRANCH_2
	.byte ZONE_ID::BRANCH_3
	.byte ZONE_ID::BRANCH_2
	.byte ZONE_ID::MIST_3
	.byte ZONE_ID::DWARF
	
@Dwarf:
	.byte ZONE_ID::CASTLE_OF_FRATERNAL
	.byte ZONE_ID::DWARF
	.byte ZONE_ID::CASTLE_OF_FRATERNAL_THRONE_ROOM
	.byte ZONE_ID::CASTLE_OF_FRATERNAL
	.byte ZONE_ID::DWARF
	.byte ZONE_ID::DWARF
	.byte ZONE_ID::DWARF_BUTCHER
	.byte ZONE_ID::DWARF_LOCKSMITH
	.byte ZONE_ID::DWARF_VENDOR
	.byte ZONE_ID::DWARF_HOUSE
	.byte ZONE_ID::DWARF_BAR
	.byte ZONE_ID::DWARF_REMOTE_HOUSE
	.byte ZONE_ID::CASTLE_OF_FRATERNAL_CHURCH
	.byte ZONE_ID::CASTLE_OF_FRATERNAL_VENDOR
	.byte ZONE_ID::BRANCH_4
	.byte ZONE_ID::ZENIS
	
@Zenis:
	; Last boss room must have the same music as Zenis or there will be a gap in playback
	.byte ZONE_ID::ZENIS
	.byte ZONE_ID::DWARF
	
	.res MAX_DOORS - (* - DoorZoneMap)
	
TransZoneMap:
	.byte <(@Eolis - TransZoneMap)
	.byte <(@Trunk - TransZoneMap)
	.byte <(@Mist - TransZoneMap)
	.byte <(@Towns - TransZoneMap)
	.byte <(@Buildings - TransZoneMap)
	.byte <(@Branch - TransZoneMap)
	.byte <(@Dwarf - TransZoneMap)
	.byte <(@Zenis - TransZoneMap)
	.res MAX_AREAS - NUM_AREAS, 0
	
@Eolis:

@Trunk:
	.byte ZONE_ID::FOREPAW
	.byte ZONE_ID::APOLUNE
	.byte ZONE_ID::APOLUNE
	.byte ZONE_ID::FOREPAW
	.byte ZONE_ID::FOREPAW
	
@Mist:
	.byte ZONE_ID::MASCON
	.byte ZONE_ID::MASCON
	.byte ZONE_ID::VICTIM
	.byte ZONE_ID::VICTIM
	
@Towns:
	.byte ZONE_ID::TRUNK_1
	.byte ZONE_ID::TRUNK_2
	.byte ZONE_ID::TRUNK_2
	.byte ZONE_ID::TRUNK_3
	.byte ZONE_ID::MIST_1
	.byte ZONE_ID::MIST_2
	.byte ZONE_ID::MIST_2
	.byte ZONE_ID::MIST_3
	.byte ZONE_ID::BRANCH_1
	.byte ZONE_ID::BRANCH_3
	.byte ZONE_ID::BRANCH_4
	.byte ZONE_ID::DWARF
	
@Buildings:

@Branch:
	.byte ZONE_ID::CONFLATE
	.byte ZONE_ID::DAYBREAK
	.byte ZONE_ID::DAYBREAK
	
@Dwarf:
	.byte ZONE_ID::DARTMOOR
	
@Zenis:

	.res MAX_TRANSITIONS - (* - TransZoneMap)

SpawnZones:
	; Outside zone, inside zone pairs
	.byte ZONE_ID::EOLIS, ZONE_ID::EOLIS_CHURCH
	.byte ZONE_ID::APOLUNE, ZONE_ID::APOLUNE_CHURCH
	.byte ZONE_ID::FOREPAW, ZONE_ID::FOREPAW_CHURCH
	.byte ZONE_ID::MIST_2, ZONE_ID::MIST_2_CHURCH
	.byte ZONE_ID::VICTIM, ZONE_ID::VICTIM_CHURCH
	.byte ZONE_ID::CONFLATE, ZONE_ID::CONFLATE_CHURCH
	.byte ZONE_ID::DAYBREAK, ZONE_ID::DAYBREAK_CHURCH
	.byte ZONE_ID::DARTMOOR, ZONE_ID::DARTMOOR_CHURCH
	
	.repeat MAX_RESPAWN_POINTS - NUM_RESPAWN_POINTS
	.byte ZONE_ID::EOLIS, ZONE_ID::EOLIS_CHURCH
	.endrepeat
	