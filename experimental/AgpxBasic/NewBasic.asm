;********************************************************************
; Idea:
;
; L'interprete basic legge, di volta in volta, il carattere/token
; puntato dalle locazioni $7a e $7b per interpretare ed eseguire le
; istruzioni. La routine che si occupa di questo (detta "BASIC instru-
; ction executor") è puntata dalle locazioni $0308/$0309 e di norma 
; è la $a7e4. L'idea è quella di dirottare questo vettore ad una
; routine nostra che, analizzando i caratteri puntati da $7a e $7b,
; riconosca le nostre istruzioni ed eventualmente le esegua. Nel
; caso non vengano riconosciute, il controllo passa alla normale
; routine ($a7e4).
;
;********************************************************************
;
; Uso:
;
; SYS 49152: NEW   (attiva il nuovo basic e libera la memoria)
;
; Istruzioni aggiunte:
;
; BORDER    n    : cambia    il colore del bordo
; BCKGND    n    : cambia    il colore dello sfondo
; SPRON     n    : accende   lo sprite #n (n in 0..7)
; SPROFF    n    : spegne    lo sprite #n (n in 0..7)
; SPRPTR    n,p  : setta     il puntatore dello sprite #n (n in 0..7, p in 0..255)
; SPRPOS    n,x,y: sposta    lo sprite #n nella coordinata (x, y) (n in 0..7, x in 0..65535, y in 0..255)
; SPRCOL    n,c  : cambia    il colore dello sprite #n (n in 0..7, c in 0..255)
; SPRMULON  n    : attiva    il multicolore per lo sprite #n (n in 0..7)
; SPRMULOFF n    : disattiva il multicolore per lo sprite #n (n in 0..7)
; SPRMULCOL n,c  : cambia    il multicolore #n (n in 0..1, c in 0..255)
; SPREXPX   n    : espande   lo sprite #n lungo l'asse x (n in 0..7)
; SPREXPY   n    : espande   lo sprite #n lungo l'asse y (n in 0..7)
; SPRSHKX   n    : riduce ("shrink") lo sprite #n lungo l'asse x (n in 0..7)
; SPRSHKY   n    : riduce ("shrink") lo sprite #n lungo l'asse y (n in 0..7)
;
; N.B.: sono possibili anche espressioni tipo: BORDER INT(15*RND(1))
;
;********************************************************************


chrgot     = $0079      ; legge il carattere/token corrente del programma basic
read_byte  = $b79e      ; routine che interpreta un byte e lo mette nel reg. x
read_comma = $aefd      ; legge una virgola, da errore in caso contrario
temp       = $02        ; variabile temporanea

*=$C000

      lda #<executor    ; dirotta il puntatore della routine "BASIC instruction executor"
      sta $0308         ; verso la nostra
      lda #>executor
      sta $0309
      rts

;********************************************************************
;
; Verifica se la prossima istruzione da eseguire corrisponde ad una
; di quelle presenti nella nostra tabella e nel caso eseguila.
; Altrimenti, passa l'esecuzione alla routine originale.
;
;********************************************************************

executor
      lda #<cmds        ; memorizza in $fb e $fc l'indirizzo della tabella
      sta $fb           ; delle nuove istruzioni
      lda #>cmds
      sta $fc

next_cmd
      ldy #0            ; preleva la lunghezza della prossima istruzione. Se è 0 abbiamo
      lda ($fb),y       ; raggiunto la fine e nessuna delle nostre istruzioni è stata trovata,
      beq not_found     ; pertanto ritorniamo alla routine originale del basic (che era puntata da $0308/$0309).
      tax               ; altrimenti, metti in x la lunghezza dell'istruzione corrente
      clc               ; aggiungi 3 a tale lunghezza (+1 = lunghezza istruzione, +2 = indirizzo
      adc #3            ; della routine associata) e memorizzala in temp (ci serve per sapere di quanto
      sta temp          ; muovere $fb e $fc in avanti per passare alla prossima istruzione)

next_char               ; il puntatore $7a e $7b punta all'ultimo carattere/token interpretato
      iny               ; prendiamo il prossimo (partendo quindi da y = 1)
      lda ($7a),y       ; e confrontiamolo con quello della nostra istruzione
      cmp ($fb),y
      beq char_match
      lda $fb           ; se non corrisponde, sposta $fb e $fc avanti del contenuto di temp 
      clc               ; calcolato prima e si ripete dalla prossima istruzione della tabella
      adc temp
      sta $fb
      bcc l1
      inc $fc
l1    jmp next_cmd

char_match
      dex               ; se il carattere corrispondeva, decrementa la lunghezza
      bne next_char     ; e se ci sono ancora altri caratteri da controllare, ripeti
      iny               ; a questo punto in y avremo la lunghezza dell'istruzione riconosciuta
      sty temp          ; (la stessa che abbiamo messo in x inizialmente) al quale aggiungiamo 1 e
      lda $7a           ; sommiamo il risultato al puntatore in $7a e $7b in modo da consumare l'istruzione
      clc               ; riconosciuta e far puntare $7a e $7b al prossimo carattere/token da interpretare
      adc temp
      sta $7a
      bcc l2
      inc $7b
l2    iny               ; preleva il byte alto della routine associata alla nostra istruzione
      lda ($fb),y
      pha               ; mettilo nello stack
      dey               ; preleva il byte basso della routine associata alla nostra istruzione
      lda ($fb),y
      pha               ; mettilo nello stack
      rts               ; esegui tale routine (viene prelevato l'indirizzo dallo stack attraverso 'rts')

not_found
      jmp $a7e4         ; se l'istruzione non è una delle nostre, esegui la routine originale che è in $a7e4
      
resume
      jsr chrgot        ; leggi il carattere corrente puntato da $7a e $7b (che è il prossimo da interpretare)
      jmp $a7e7         ; e passa il controllo all'interprete originale

;********************************************************************
;
; Istruzione: BORDER x
;
;********************************************************************

cmd_border
      jsr read_byte     ; interpreta un numero intero da 0 a 255 e mettilo in x (sempre da $7a e $7b)
      stx $d020         ; memorizzalo nel registro del bordo
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: BCKGND x
;
;********************************************************************

cmd_bckgnd
      jsr read_byte     ; interpreta un numero intero da 0 a 255 e mettilo in x (sempre da $7a e $7b)
      stx $d021         ; memorizzalo nel registro dello sfondo
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Interpreta un numero da 0 a 7 e mettilo nel registro x. In
; caso il numero sia fuori intervallo emetti un "illegal quantity".
;
;********************************************************************

read_sprnum
      jsr read_byte     ; interpreta un numero intero da 0 a 255 e mettilo in x
      cpx #8            ; verifica che sia < 8
      bcc ok
      jmp $b248         ; altrimenti emetti un "illegal quantity"
ok    rts

;********************************************************************
;
; Interpreta un numero a 16-bit e mettilo nelle locazioni $14 e $15.
;
;********************************************************************

read_word
      jsr $ad8a
      jmp $b7f7

;********************************************************************
;
; Istruzione: SPRON n  (n in 0..7)
;
;********************************************************************

cmd_spron
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d015         ; accendi il corrisponde bit nel registro del VIC-II
      ora power2,x
      sta $d015
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPROFF n  (n in 0..7)
;
;********************************************************************

cmd_sproff
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d015         ; spegni il corrisponde bit nel registro del VIC-II
      and invPwr2,x
      sta $d015
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRPTR n, p  (n in 0..7, p in 0..255)
;
;********************************************************************

cmd_sprptr
      jsr read_sprnum   ; leggi il numero dello sprite nel reg. x
      stx temp          ; memorizzalo in temp

      jsr read_comma    ; leggi una virgola
      
      jsr read_byte     ; leggi il puntatore
      txa               ; mettilo nel registro A

      ldy temp          ; carica nel reg. y il numero dello sprite
      sta $07F8,y       ; cambia il puntatore dello sprite
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRPOS n, x, y  (n in 0..7, x in 0..65535, y in 0..255)
;
;********************************************************************

cmd_sprpos
      jsr read_sprnum   ; leggi il numero dello sprite nel reg. x
      stx temp          ; salvalo in temp
      
      jsr read_comma    ; leggi una virgola
      
      jsr read_word     ; leggi la coordinata "x" e mettila in $14 e $15
      
      jsr read_comma    ; leggi una virgola
      
      jsr read_byte     ; leggi la coordinata "y" e mettila nel reg. x
      lda temp          ; prendi il num. dello sprite e moltiplicalo per 2
      asl
      tay               ; trasferiscilo nel reg. y (y = sprnum * 2)
      txa               ; metti nel reg. A la coordinata "y" dello sprite
      sta $d001,y       ; setta la coordinata "y" dello sprite
      lda $14           ; setta il byte basso della coordinata "x" dello sprite
      sta $d000,y
      
      ldx temp          ; mette nel reg. x il numero dello sprite
      
      lda $15           ; se il byte alto è 0, spegni il nono bit della
      beq off_9th       ; coordinata "x" dello sprite
      lda $d010         ; altrimenti, accendilo...
      ora power2,x
      sta $d010
      jmp resume        ; continua l'interpretazione

off_9th
      lda $d010
      and invPwr2,x
      sta $d010
      jmp resume

;********************************************************************
;
; Istruzione: SPRCOL n, c  (n in 0..7, c in 0..255)
;
;********************************************************************

cmd_sprcol
      jsr read_sprnum   ; leggi il numero dello sprite nel reg. x
      stx temp          ; memorizzalo in temp

      jsr read_comma    ; leggi una virgola
      
      jsr read_byte     ; leggi il colore
      txa               ; mettilo nel registro A
      
      ldy temp          ; carica nel reg. y il numero dello sprite
      sta $d027,y       ; cambia il colore dello sprite
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRMULON n  (n in 0..7)
;
;********************************************************************

cmd_sprmulon
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d01c         ; accendi il corrisponde bit nel registro del VIC-II
      ora power2,x
      sta $d01c
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRMULOFF n  (n in 0..7)
;
;********************************************************************

cmd_sprmuloff
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d01c         ; spegni il corrisponde bit nel registro del VIC-II
      and invPwr2,x
      sta $d01c
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRMULCOL n, c  (n in 0..1, c in 0..255)
;
;********************************************************************

cmd_sprmulcol
      jsr read_byte     ; interpreta un numero intero da 0 a 255 e mettilo in x
      cpx #2            ; verifica che sia < 2
      bcc cont
      jmp $b248         ; altrimenti emetti un "illegal quantity"
cont
      stx temp          ; memorizzalo in temp

      jsr read_comma    ; leggi una virgola
      
      jsr read_byte     ; leggi il colore
      txa               ; mettilo nel registro A
      
      ldy temp          ; carica nel reg. y il numero del registro multicolor
      sta $d025,y       ; setta il colore
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPREXPX n  (n in 0..7)
;
;********************************************************************

cmd_sprexpx
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d01d         ; accendi il corrisponde bit nel registro del VIC-II
      ora power2,x
      sta $d01d
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPREXPY n  (n in 0..7)
;
;********************************************************************

cmd_sprexpy
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d017         ; accendi il corrisponde bit nel registro del VIC-II
      ora power2,x
      sta $d017
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRSHKX n  (n in 0..7)
;
;********************************************************************

cmd_sprshkx
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d01d         ; spegni il corrisponde bit nel registro del VIC-II
      and invPwr2,x
      sta $d01d
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Istruzione: SPRSHKY n  (n in 0..7)
;
;********************************************************************

cmd_sprshky
      jsr read_sprnum   ; leggi il numero dello sprite in x
      lda $d017         ; spegni il corrisponde bit nel registro del VIC-II
      and invPwr2,x
      sta $d017
      jmp resume        ; continua l'interpretazione

;********************************************************************
;
; Look-up tables (LUT).
;
;********************************************************************

power2  !byte   1,   2,   4,   8,  16,  32,  64, 128
invPwr2 !byte 254, 253, 251, 247, 239, 223, 191, 127

;********************************************************************
;
; La seguente tabella memorizza le nuove istruzioni nel formato:
;
; lunghezza istruzione, caratteri istruzione, indirizzo routine - 1
;
;********************************************************************

cmds
      !pet 5, "b",$B0,"der"     ; $B0 è il token di OR, quindi l'istruzione è BORDER
      !word cmd_border-1

      !pet 6, "bckgnd"
      !word cmd_bckgnd-1
      
      !pet 4, "spr",$91         ; $91 è il token di ON, quindi l'istruzione è SPRON
      !word cmd_spron-1
      
      !pet 6, "sproff"
      !word cmd_sproff-1
      
      !pet 6, "sprptr"
      !word cmd_sprptr-1
      
      !pet 4, "spr",$B9         ; $B9 è il token di POS, quindi l'istruzione è SPRPOS
      !word cmd_sprpos-1
      
      !pet 6, "sprcol"
      !word cmd_sprcol-1

      !pet 9, "sprmulcol"
      !word cmd_sprmulcol-1

      !pet 7, "sprmul",$91
      !word cmd_sprmulon-1

      !pet 9, "sprmuloff"
      !word cmd_sprmuloff-1

      !pet 5, "spr",$BD,"x"     ; $BD è il token di EXP, quindi l'istruzione è SPREXPX
      !word cmd_sprexpx-1

      !pet 5, "spr",$BD,"y"     ; $BD è il token di EXP, quindi l'istruzione è SPREXPY
      !word cmd_sprexpy-1

      !pet 7, "sprshkx"
      !word cmd_sprshkx-1

      !pet 7, "sprshky"
      !word cmd_sprshky-1

      !byte 0                    ; una lunghezza pari a 0 indica la fine della tabella
