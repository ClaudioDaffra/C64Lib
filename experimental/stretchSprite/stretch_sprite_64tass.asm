
.cpu  '6502'
.enc  'none'

; [start address]
* = $0801
    ;           [line]
    .word  (+), 2022
    ;2022 [sys] [2069] :rem prg                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

program_entry_point


         lda #100        ; inizializzazione sprite
         sta $d000
         sta $d001

        ;   Il programma imposta la posizione dello sprite a X = 100.
        ;   Imposta il puntatore del pattern dello sprite a 2040 (10 in decimale).

         lda #11
         sta 2040

        ;   Caricamento del Pattern dello Sprite
        
         ldy #$00
-        lda tabSprite,y
         sta 704,y
         iny
         cpy #63
         bne -

        ; Abilitazione dello Sprite
        
         lda #$01
         sta $d015

         sei              ; disattivare l'interrupt, che disturba solamente

        ; Ingrandimento Verticale dello Sprite
        
         ldy #21          ; ingrandire di 21 linee

loop     lda #100         ; attendere sulla riga 100
-        cmp $d012
         bne -

         nop              ; Assicurati che il ciclo sia 16
         nop              ; equivale a due volte l'altezza
         nop
         nop

         lda #1           ; impostare il bit di espansione
         sta $d017        ; => doppia altezza

         ldx #9           ; attendere 52 cicli di clock
-        dex
         bne -
         nop
         nop
         nop

         lda #0           ; cancellare il bit di espansione e subito dopo impostarlo di nuovo
         sta $d017        ; impostare di nuovo
         lda #1           ; equivale a tre volte l'altezza
         sta $d017

         ldx #9           ; attendere 46 cicli di clock
-        dex
         bne -

         lda #0           ; Cancellare il bit di espansione e subito
         sta $d017        ; impostare di nuovo
         lda #1           ; equivale a quattro volte l'altezza
         sta $d017

            lda #255    ; Abilita l'espansione orizzontale per lo sprite 0
            sta $D01D   ; Scrive nel registro di espansione orizzontale

            lda #255    ; Abilita l'espansione orizzontale per lo sprite 0
            sta $D01D   ; Scrive nel registro di espansione orizzontale
            lda #255    ; Abilita l'espansione orizzontale per lo sprite 0
            sta $D017   ; Scrive nel registro di espansione orizzontale


         lda loop+1       ; Ripetere, fino a quando tutte le linee di
         clc
         adc #4
         sta loop+1

         dey              ; Ripetere fino a quando tutte le righe del
         bne loop         ; Gli sprite sono stati elaborati

        ;   - Il codice controlla il raster line (d012) per sincronizzarsi. 
        ;   - Utilizza `nop` (No Operation) per assicurarsi di essere nel ciclo giusto. 
        ;   - Aumenta l'altezza dello sprite in passi incrementali (doppio, triplo, quadruplo). 
        ;   - Ripete il processo fino a completare l'espansione di tutte le linee.

         lda #100         ; Inizializzare il ciclo per un nuovo passaggio
         sta loop+1
         jmp loop

tabSprite 
    .byte 0,127,0,1,255,192,3,255,224,3,231,224
    .byte 7,217,240,7,223,240,7,217,240,3,231,224
    .byte 3,255,224,3,255,224,2,255,160,1,127,64
    .byte 1,62,64,0,156,128,0,156,128,0,73,0,0,73,0
    .byte 0,62,0,0,62,0,0,62,0,0,28,0
