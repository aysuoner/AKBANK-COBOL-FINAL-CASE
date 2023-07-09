      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
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
              10  IDX-ID    PIC 9(05) COMP-3.
              10  IDX-DVZ   PIC 9(03) COMP.
           05 IDX-FIRSTN    PIC X(15).
           05 IDX-LASTN     PIC X(15).
           05 IDX-JUL       PIC 9(07) COMP-3.
           05 IDX-TUTAR     PIC 9(13)V99 COMP-3.
       WORKING-STORAGE SECTION.
       01 IDX-ST            PIC 9(02).
           88 IDX-SUCCESS   VALUE 00 97.
           88 DUPLICATE     VALUE 22.
       LINKAGE SECTION.
       01  LN-INP-REC.
		     05 LN-INP-TYPE   PIC X(01).
		       88 READ-TYPE     VALUE 'R'.
		       88 WRITE-TYPE    VALUE 'W'.
		       88 UPDTE-TYPE    VALUE 'U'.
		       88 DELT-TYPE     VALUE 'D'.
           05 LN-INP-ID     PIC 9(05) COMP-3.
           05 LN-INP-DVZ    PIC 9(03) COMP.
       01  LN-WS-TYPE       PIC X(01).
       PROCEDURE DIVISION USING LN-INP-REC, LN-WS-TYPE.
           OPEN INPUT IDX-FILE.
       TYPE-CALL.
           DISPLAY "LNINP:" LN-INP-TYPE.
           EVALUATE TRUE
           WHEN READ-TYPE
            PERFORM READ-SUB
            EXIT PROGRAM
           WHEN WRITE-TYPE
            PERFORM WRITE-SUB
            EXIT PROGRAM
           WHEN UPDTE-TYPE
            PERFORM UPDTE-SUB
            EXIT PROGRAM
           WHEN DELT-TYPE
            PERFORM DELT-SUB
            EXIT PROGRAM
           WHEN OTHER
            DISPLAY 'GECERSIZ ISTEK'
           EXIT PROGRAM
           END-EVALUATE.
       TYPE-CALL-END. EXIT.
      *
       READ-SUB.
           DISPLAY 'READ'.
      *     MOVE LN-INP-ID  TO IDX-ID
      *     MOVE LN-INP-DVZ TO IDX-DVZ
      *     MOVE LN-INP-REC TO IDX-KEY.
      *     READ IDX-FILE KEY IS IDX-KEY
      *     INVALID KEY
      *      DISPLAY "Record Undefined: " LN-INP-ID LN-INP-DVZ
      *     NOT INVALID KEY
      *      DISPLAY "Record OK: " LN-INP-ID LN-INP-DVZ.
       READ-SUB-END. EXIT.
      *
       WRITE-SUB.
           DISPLAY 'WRITE'.
       WRITE-SUB-END. EXIT.
      *
       UPDTE-SUB.
           DISPLAY  'UPDATE'.
       UPDTE-SUB-END. EXIT.
      *
       DELT-SUB.
           DISPLAY  'DELT'.
       DELT-SUB-END. EXIT.
      *
      * SET-IDX-KEY.
      *     MOVE LN-INP-ID  TO IDX-ID
      *     MOVE LN-INP-DVZ TO IDX-DVZ
      *     MOVE LN-INP-REC TO IDX-KEY.
      * SET-IDX-KEY-END. EXIT.

           GOBACK.
       END PROGRAM SUBPRG.