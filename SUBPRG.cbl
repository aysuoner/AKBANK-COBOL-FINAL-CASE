      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
      *NOT: INPFILE'DA BIR DEGISIKLIK YAPTIKTAN SONRA MAIN'I CALISTIRDI
      *GINDA ISTEDIGIN VERIYI ALAMIYORSAN ONCE VSAM DOSYASINI SUBMIT ET
      *CUNKU BIR ONCEKI WRITE DELT- UPDATE ISLEMI ILE ILK VSAM
      *DEGISMIS OLABILIR. BUNU NOT OLARAL README.md EKLE!!!!!
      *
      *subprogramin surekli acilip kapanmamasi icin bir sey bul!!!
      *DOSYA ACIP KAPAMA ICIN INITIAL ATTRIBUTE ARASTIR
      *TUTAR DEGISKEN ADI DEGISTIR
      *jcl duzelt
      *RETURN CODE AMAC ARASTIR TAM OGREN
      * bosluklari kaldirinca zaten update oldu desin.
      *INITIAL ayarlamak gerekli mi ogren?
       PROGRAM-ID.    SUBPRG IS INITIAL
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  10/07/2023.
       DATE-COMPILED. 16/07/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE    ASSIGN TO  IDXFILE
                              ORGANIZATION INDEXED
                              ACCESS     RANDOM
                              RECORD KEY IDX-KEY
                              STATUS     IDX-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
             10  IDX-ID         PIC 9(05)    COMP-3.
             10  IDX-DVZ        PIC 9(03)    COMP.
           05 IDX-FIRSTN        PIC X(15).
           05 IDX-LASTN         PIC X(15).
           05 IDX-JUL           PIC 9(07)    COMP-3.
           05 IDX-AMOUNT        PIC 9(13)V99 COMP-3.
       WORKING-STORAGE SECTION.
       01  FILE-FLAGS.
           05 IDX-ST            PIC 9(02).
             88 IDX-SUCCESS              VALUE 00 97.
           05 EXIT-ST           PIC 9(01).
             88 EXIT-PROG                VALUE 1.
       01  REMOVE-SPACES-VAR.
           05 TMP-STR.
             10 LEN             PIC  9(02).
             10 CHARS           PIC  X(15).
             10 I               PIC  9(02).
             10 J               PIC  9(02).
             10 K               PIC  9(02).
           05 RES-STR.
             10 LEN             PIC 9(02).
             10 CHARS           PIC X(15).
       LINKAGE SECTION.
       01  LN-SUB-IDX-KEY.
           05 LN-SUB-IDX-ID     PIC 9(05) COMP-3.
           05 LN-SUB-IDX-DVZ    PIC 9(03) COMP.
       01  LN-OUT-MSG-INFO.
           05 LN-OUT-RROC-TYP   PIC X(09).
           05 LN-OUT-RC         PIC 9(02).
           05 LN-OUT-MSG        PIC X(20).
           05 LN-FIRSTNFROM     PIC X(15).
           05 LN-FIRSTNTO       PIC X(15).
           05 LN-LASTNFROM      PIC X(15).
           05 LN-LASTNTO        PIC X(15).
      *------------
       PROCEDURE DIVISION USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----
       FILE-OPEN-CONTROL.
           OPEN I-O IDX-FILE
      *    BU DISPLAYI SIL ISIN BITINCE
           DISPLAY 'ST: ' IDX-ST
           IF NOT IDX-SUCCESS
             DISPLAY '.VSAM FILE CANNOT OPEN: ' IDX-ST
             SET EXIT-PROG TO TRUE
             MOVE IDX-ST TO RETURN-CODE
             PERFORM EXIT-SUBPROG
           END-IF.
      *     MOVE LN-SUB-IDX-ID  TO IDX-ID.
      *     MOVE LN-SUB-IDX-DVZ TO IDX-DVZ.
           MOVE LN-SUB-IDX-KEY TO IDX-KEY.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
      *-------------------------------------------------
           ENTRY 'READPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *-------------------------------------------------
           PERFORM FILE-OPEN-CONTROL
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD READ' TO LN-OUT-MSG
           END-READ.
           MOVE '-READ-RC:' TO LN-OUT-RROC-TYP
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *-------------------------------------------------
           ENTRY 'WRITPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *-------------------------------------------------
           PERFORM FILE-OPEN-CONTROL
           READ IDX-FILE KEY IS IDX-KEY
           NOT INVALID KEY
             MOVE 'AYSU           ' TO IDX-FIRSTN
             MOVE 'ONER           ' TO IDX-LASTN
             MOVE '1995126'         TO IDX-JUL
             MOVE '000000000000000' TO IDX-AMOUNT
           END-READ
           WRITE IDX-REC
           INVALID KEY
              MOVE IDX-ST TO LN-OUT-RC
              MOVE ' DUPLICATE RECORD' TO LN-OUT-MSG
           NOT INVALID KEY
              MOVE IDX-ST TO LN-OUT-RC
              MOVE ' NEW RECORD ADDED' TO LN-OUT-MSG
           END-WRITE.
           MOVE '-WRIT-RC:' TO LN-OUT-RROC-TYP
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *-------------------------------------------------
           ENTRY 'UPDTPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *-------------------------------------------------
           PERFORM FILE-OPEN-CONTROL
           READ IDX-FILE KEY IS IDX-KEY
           NOT INVALID KEY
      *****updateforname
             MOVE IDX-FIRSTN TO CHARS OF TMP-STR LN-FIRSTNFROM
             PERFORM REMOVE-SPACES
             PERFORM REPLACING-CHR
             MOVE CHARS OF RES-STR TO IDX-FIRSTN LN-FIRSTNTO
      *****updateforlastname
             MOVE IDX-LASTN TO CHARS OF TMP-STR LN-LASTNFROM
             PERFORM REMOVE-SPACES
             PERFORM REPLACING-CHR
             MOVE CHARS OF RES-STR TO IDX-LASTN LN-LASTNTO
           END-READ.
           REWRITE IDX-REC
           INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD UPDATED' TO LN-OUT-MSG
           END-REWRITE.
           MOVE '-UPDT-RC:' TO LN-OUT-RROC-TYP
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *-------------------------------------------------
           ENTRY 'DELTPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *-------------------------------------------------
           PERFORM FILE-OPEN-CONTROL
           DELETE IDX-FILE RECORD
           INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             MOVE IDX-ST TO LN-OUT-RC
             MOVE ' RECORD DELETED' TO LN-OUT-MSG
           END-DELETE.
           MOVE '-DELT-RC:' TO LN-OUT-RROC-TYP
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *----
       REMOVE-SPACES.
           MOVE 1 TO I J
           COMPUTE LEN OF TMP-STR = LENGTH OF CHARS OF TMP-STR
           PERFORM UNTIL I > LEN OF TMP-STR
             MOVE 0 TO K
             UNSTRING CHARS OF TMP-STR
               DELIMITED BY ' '
               INTO CHARS OF RES-STR(J:)
               COUNT IN K
               WITH POINTER I
             END-UNSTRING
             ADD J TO K GIVING J
           END-PERFORM
           COMPUTE LEN OF RES-STR = J - 1.
       REMOVE-SPACES-END. EXIT.
      *----
      *----
       REPLACING-CHR.
           INSPECT CHARS OF RES-STR
           REPLACING ALL 'e' BY 'i',
                         'E' BY 'I',
                         'a' BY 'e',
                         'A' BY 'E'.
       REPLACING-CHR-END. EXIT.
      *----
      *----
       EXIT-SUBPROG.
           IF EXIT-PROG
               DISPLAY IDX-ID IDX-DVZ
      *         CLOSE IDX-FILE
               GOBACK
           END-IF.
       EXIT-SUBPROG-END. EXIT.
      *
      *
      *
      *----
      *     ENTRY 'PRGEXIT'.
      *     IF CLOSE-FILE
      *         DISPLAY 'GIRDI' IDX-ID IDX-DVZ
      *         CLOSE IDX-FILE
      *         EXIT PROGRAM
      *     END-IF.
      * END PROGRAM SUBPRG.
