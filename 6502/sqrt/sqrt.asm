    .PROCESSOR 6502
    .ORG $8000

    .INCLUDE "utils/utils.asm"

zpnuml=$0000
zpnumh=zpnuml+1
zpaccuml=$0010
zpaccumh=zpaccuml+1
zpdtl=$0020
zpdth=zpdtl+1
zpret=$0030
zpphase=$0040

    ldx #$FF
    txs

    setphase #$11
    setnum #0, #0
    jsr sqrt
    assert zpret, #0

    setphase #$22
    setnum #0, #1
    jsr sqrt
    assert zpret, #1

    setphase #$33
    setnum #0, #2
    jsr sqrt
    assert zpret, #1

    setphase #$44
    setnum #0, #3
    jsr sqrt
    assert zpret, #1

    setphase #$55
    setnum #0, #4
    jsr sqrt
    assert zpret, #2

    setphase #$66
    setnum #0, #255
    jsr sqrt
    assert zpret, #15

    setphase #$77
    setnum #1, #0
    jsr sqrt
    assert zpret, #16

    setphase #$88
    setnum #$FF, #$FF
    jsr sqrt
    assert zpret, #255

    termin

;======================================
    .MACRO setphase ; (imm)
        lda #{1}
        sta zpphase
    .ENDM
;======================================

;======================================
    .MACRO setnum ; (#hi,#lo)
        lda {1}
        sta zpnumh
        lda {2}
        sta zpnuml
    .ENDM
;======================================

;======================================
sqrt: ; (zpnum) -> zpret | <A,X,Y,P>
;======================================
; https://en.wikipedia.org/wiki/Integer_square_root#Linear_search_using_addition
    .SUBROUTINE

    ldx #1
    stx zpaccuml
    ldx #3
    stx zpdtl
    ldx #0
    stx zpaccumh
    stx zpdth

.cmphigh:
    lda zpaccumh
    cmp zpnumh
    bpl .ret
    bmi .add

    lda zpaccuml
    cmp zpnuml
    bpl .ret

.add:
    lda zpaccuml
    clc
    adc zpdtl
    sta zpaccuml
    lda zpaccumh
    adc zpdth
    sta zpaccumh

    lda zpdtl
    clc
    adc #2
    sta zpdtl
    lda zpdth
    adc #0
    sta zpdth
    
    inx

    nop
    nop
    nop
    nop
    nop

    jmp .cmphigh

.ret:
    stx zpret

    rts
;======================================

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000