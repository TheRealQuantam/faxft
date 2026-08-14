.macpack common

.include "constants.inc"

.segment "ZEROPAGE"      :size $0100 :mem $0000 :zp
.segment "BHOP_ZEROPAGE" :size $0006 :mem $002c :zp
.segment "BHOP_ZEROPAGE_COPY" :size $0006 :mem $002c :zp
.segment "RAM"           :size $0700 :mem $0100
.segment "HIRAM"         :size $2000 :mem $6000

.segment "FT_HIRAM" :load "HIRAM"
.segment "MMC3_HIRAM" :load "HIRAM"
.segment "BHOP_RAM" :load "HIRAM"

.segment "HEADER" :size $0010 :mem $0000 :out

.segment "BANK0"  :bank $00 :size $4000 :mem $8000 :out
.segment "BANK1"  :bank $01 :size $4000 :mem $8000 :out
.segment "BANK2"  :bank $02 :size $4000 :mem $8000 :out
.segment "BANK3"  :bank $03 :size $4000 :mem $8000 :out
.segment "BANK4"  :bank $04 :size $4000 :mem $8000 :out
.segment "BANK5"  :bank $05 :size $4000 :mem $8000 :out
.segment "BANK6"  :bank $06 :size $4000 :mem $8000 :out
.segment "BANK7"  :bank $07 :size $4000 :mem $8000 :out
.segment "BANK8"  :bank $08 :size $4000 :mem $8000 :out
.segment "BANK9"  :bank $09 :size $4000 :mem $8000 :out
.segment "BANKA"  :bank $0a :size $4000 :mem $8000 :out
.segment "BANKB"  :bank $0b :size $4000 :mem $8000 :out
.segment "BANKC"  :bank $0c :size $4000 :mem $8000 :out
.segment "BANKD"  :bank $0d :size $4000 :mem $8000 :out
.segment "BANKE"  :bank $0e :size $4000 :mem $8000 :out

.ifdef ROM_512KB

.segment "BANK1E" :bank $1e :size $2000 :mem $8000 :out :fill $00
.segment "BANK1F" :bank $1f :size $2000 :mem $8000 :out :fill $00
.segment "BANK20" :bank $20 :size $2000 :mem $8000 :out :fill $00
.segment "BANK21" :bank $21 :size $2000 :mem $8000 :out :fill $00
.segment "BANK22" :bank $22 :size $2000 :mem $8000 :out :fill $00
.segment "BANK23" :bank $23 :size $2000 :mem $8000 :out :fill $00
.segment "BANK24" :bank $24 :size $2000 :mem $8000 :out :fill $00
.segment "BANK25" :bank $25 :size $2000 :mem $8000 :out :fill $00
.segment "BANK26" :bank $26 :size $2000 :mem $8000 :out :fill $00
.segment "BANK27" :bank $27 :size $2000 :mem $8000 :out :fill $00
.segment "BANK28" :bank $28 :size $2000 :mem $8000 :out :fill $00
.segment "BANK29" :bank $29 :size $2000 :mem $8000 :out :fill $00
.segment "BANK2A" :bank $2a :size $2000 :mem $8000 :out :fill $00
.segment "BANK2B" :bank $2b :size $2000 :mem $8000 :out :fill $00
.segment "BANK2C" :bank $2c :size $2000 :mem $8000 :out :fill $00
.segment "BANK2D" :bank $2d :size $2000 :mem $8000 :out :fill $00
.segment "BANK2E" :bank $2e :size $2000 :mem $8000 :out :fill $00
.segment "BANK2F" :bank $2f :size $2000 :mem $8000 :out :fill $00
.segment "BANK30" :bank $30 :size $2000 :mem $8000 :out :fill $00
.segment "BANK31" :bank $31 :size $2000 :mem $8000 :out :fill $00
.segment "BANK32" :bank $32 :size $2000 :mem $8000 :out :fill $00
.segment "BANK33" :bank $33 :size $2000 :mem $8000 :out :fill $00
.segment "BANK34" :bank $34 :size $2000 :mem $8000 :out :fill $00
.segment "BANK35" :bank $35 :size $2000 :mem $8000 :out :fill $00
.segment "BANK36" :bank $36 :size $2000 :mem $8000 :out :fill $00
.segment "BANK37" :bank $37 :size $2000 :mem $8000 :out :fill $00
.segment "BANK38" :bank $38 :size $2000 :mem $8000 :out :fill $00
.segment "BANK39" :bank $39 :size $2000 :mem $8000 :out :fill $00
.segment "BANK3A" :bank $3a :size $2000 :mem $8000 :out :fill $00
.segment "BANK3B" :bank $3b :size $2000 :mem $8000 :out :fill $00
.segment "BANK3C" :bank $3c :size $2000 :mem $8000 :out :fill $00
.segment "BANK3D" :bank $3d :size $2000 :mem $8000 :out :fill $00

.endif ; defined(ROM_512KB)

.segment "BANKF"  :bank $0f :size $4000 :mem $c000 :out

FREE "BANK3" [$a246, $c000)
FREE "BANK5" [$8000 + NAT_SOUND_CODE_SIZE, $c000)
FREE "BANKF" [$fccd, $ffd7)

.segment "TRACK_MAP" :load "BANK5"

.segment "FT_CODE_TABLES" :load "BANK1E"
.segment "FT_CODE" :load "BANK1E"
.segment "BHOP_PRG" :load "BANK1E"

