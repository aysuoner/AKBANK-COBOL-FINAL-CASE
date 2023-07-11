      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
      *NOT: INPFILE'DA BIR DEGISIKLIK YAPTIKTAN SONRA MAIN'I CALISTIRDI
      *GINDA ISTEDIGIN VERIYI ALAMIYORSAN ONCE VSAM DOSYASINI SUBMIT ET
      *CUNKU BIR OONCEKI WRITE DELT- UPDATE ISLEMI ILE ILK VSAM
      *DEGISMIS OLABILIR. BUNU NOT OLARAL README.md EKLE!!!!!
      *
      *subprogramin surekli acilip kapanmamasi icin bir sey bul!!!
      *
       PROGRAM-ID.    SUBPRG.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  09/07/2023.
       DATE-COMPILED. 13/07/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN TO  IDXFILE
                             ORGANIZATION INDEXED
                             ACCESS     RANDOM
                             RECORD KEY IDX-KEY
                             STATUS     IDX-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
              10  IDX-ID      PIC 9(05)    COMP-3.
              10  IDX-DVZ     PIC 9(03)    COMP.
           05 IDX-FIRSTN      PIC X(15).
           05 IDX-LASTN       PIC X(15).
           05 IDX-JUL         PIC 9(07)    COMP-3.
           05 IDX-TUTAR       PIC 9(13)V99 COMP-3.
       WORKING-STORAGE SECTION.
       01  WS-ERROR-MSG       PIC X(80).
       01  EXIT-FLAG          PIC X(01) VALUE 'N'.
       01  FILE-FLAGS.
           05 IDX-ST          PIC 9(02).
               88 IDX-SUCCESS VALUE 00 41 97.
       01  REMOVE-SPACES-VAR.
           05 TMP-STR.
            10 LEN      PIC  9(02).
            10 CHARS    PIC  X(15).
            10 I        PIC  9(02).
            10 J        PIC  9(02).
            10 K        PIC  9(02).
           05 RES-STR.
            10 LEN   PIC 9(02).
            10 CHARS PIC X(15).
       LINKAGE SECTION.
       01  LN-IDX-AREA.
         05 LN-PROC-TYPE     PIC   X(01).
           88 LN-READ-TYPE   VALUE 'R'.
           88 LN-WRITE-TYPE  VALUE 'W'.
           88 LN-UPDTE-TYPE  VALUE 'U'.
           88 LN-DELT-TYPE   VALUE 'D'.
         05 LN-SUB-IDX-KEY.
           15 LN-SUB-IDX-ID  PIC 9(05) COMP-3.
           15 LN-SUB-IDX-DVZ PIC 9(03) COMP.
       01  LN-OUT-MSG-INFO.
         05 OUT-RC           PIC 9(02).
         05 OUT-MSG          PIC X(30).
      *   05 OUT-FROM         PIC X(15).
      *   05 OUT-TO           PIC X(15).
      *------------
       PROCEDURE DIVISION USING LN-IDX-AREA LN-OUT-MSG-INFO.
       MAIN-PRAG.
           PERFORM FILE-OPEN-CONTROL
           PERFORM SET-IDX-KEY
           PERFORM TYPE-DETECT
           MOVE 'Y' TO EXIT-FLAG
           PERFORM PROGRAM-EXIT.
       MAIN-PRAG-END. EXIT.
      *----
       FILE-OPEN-CONTROL.
           OPEN I-O IDX-FILE
           IF NOT IDX-SUCCESS
            DISPLAY '.VSAM FILE CANNOT OPEN: ' IDX-ST
            MOVE 'Y' TO EXIT-FLAG
            MOVE IDX-ST TO RETURN-CODE
            PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
       SET-IDX-KEY.
           MOVE LN-SUB-IDX-ID  TO IDX-ID
           MOVE LN-SUB-IDX-DVZ TO IDX-DVZ
           MOVE LN-SUB-IDX-KEY TO IDX-KEY.
       SET-IDX-KEY-END. EXIT.
      *----
       TYPE-DETECT.
           EVALUATE TRUE
           WHEN LN-READ-TYPE
            PERFORM READ-PROCESS
           WHEN LN-WRITE-TYPE
            PERFORM WRITE-PROCESS
           WHEN LN-UPDTE-TYPE
            PERFORM UPDTE-PROCESS
           WHEN LN-DELT-TYPE
            PERFORM DELT-PROCESS
           WHEN OTHER
            DISPLAY 'GECERSIZ ISTEK'
           END-EVALUATE.
       TYPE-DETECT-END. EXIT.
      *----
      *----
       READ-PROCESS.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
            MOVE IDX-ST TO OUT-RC
            MOVE ' RECORD NOT FOUND' TO OUT-MSG
           NOT INVALID KEY
            MOVE IDX-ST TO OUT-RC
            MOVE ' RECORD READ' TO OUT-MSG
           END-READ.
       READ-PROCESS-END. EXIT.
      *----
      *----
       WRITE-PROCESS.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
             MOVE 00 TO OUT-RC
             MOVE ' RECORD ADDED'    TO OUT-MSG.
             MOVE 'AYSU           ' TO IDX-FIRSTN
             MOVE 'ONER           ' TO IDX-LASTN
             MOVE '1995126'         TO IDX-JUL
             MOVE '000000000000000' TO IDX-TUTAR
             WRITE IDX-REC
           NOT INVALID KEY
            MOVE IDX-ST TO OUT-RC
            MOVE ' RECORD READ' TO OUT-MSG.
       WRITE-PROCESS-END. EXIT.
      *----
      *----
       UPDTE-PROCESS.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
            MOVE IDX-ST TO OUT-RC
            MOVE ' RECORD NOT FOUND' TO OUT-MSG
           NOT INVALID KEY
             MOVE IDX-FIRSTN TO CHARS OF TMP-STR
             PERFORM REMOVE-SPACES
             PERFORM REPLACING-CHR
             MOVE CHARS OF RES-STR TO IDX-FIRSTN
             MOVE IDX-LASTN TO CHARS OF TMP-STR
             PERFORM REMOVE-SPACES
             PERFORM REPLACING-CHR
             MOVE CHARS OF RES-STR TO IDX-LASTN
             REWRITE IDX-REC
             MOVE IDX-ST TO OUT-RC
             MOVE ' RECORD UPDATED' TO OUT-MSG
           END-READ.
       UPDTE-PROCESS-END. EXIT.
      *----
      *----
       DELT-PROCESS.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
            MOVE IDX-ST TO OUT-RC
            MOVE ' RECORD NOT FOUND' TO OUT-MSG
           NOT INVALID KEY
            DELETE IDX-FILE RECORD
             MOVE IDX-ST TO OUT-RC
             MOVE ' RECORD DELETED' TO OUT-MSG
           END-READ.
       DELT-PROCESS-END. EXIT.
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
           END-PERFORM.
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
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE IDX-FILE
               EXIT PROGRAM
           END-IF.
       PROGRAM-EXIT-END.
       END PROGRAM SUBPRG.
