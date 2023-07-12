      *------------------------
       IDENTIFICATION DIVISION.
      *------------------------
       PROGRAM-ID.    MAINPRG.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  09/07/2023.
       DATE-COMPILED. 13/07/2023.
      *---------------------
       ENVIRONMENT DIVISION.
      *---------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE   ASSIGN TO  INPFILE
                             STATUS     INP-ST.
           SELECT OUT-FILE   ASSIGN TO  OUTFILE
                             STATUS     OUT-ST.
      *---------------
        DATA DIVISION.
      *---------------
       FILE SECTION.
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
		     05 INP-TYPE       PIC X(01).
           05 INP-KEY.
            07 INP-ID        PIC 9(05) COMP-3.
            07 INP-DVZ       PIC 9(03) COMP.
      *****
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-REC.
         03 OUT-KEY-INFO.
           05 OUT-ID         PIC 9(05).
           05 OUT-DVZ        PIC 9(03).
           05 OUT-RROC-TYP   PIC X(06).
           03 OUT-RC-MSG     PIC X(03).
         03 OUT-MSG-INFO.
           05 OUT-RC         PIC 9(02).
           05 OUT-MSG        PIC X(35).
      *     05 OUT-FROM      PIC X(15).
      *     05 OUT-TO        PIC X(15).
      *****
       WORKING-STORAGE SECTION.
       01  EXIT-FLAG         PIC X(01) VALUE 'N'.
       01  FILE-FLAGS.
           05 INP-ST         PIC 9(02).
            88 INP-EOF       VALUE 10.
            88 INP-SUCCESS   VALUE 00 97.
           05 OUT-ST         PIC 9(02).
            88 OUT-SUCCESS   VALUE 00 97.
       01  SUB-AREA.
         05 PROC-TYPE        PIC   X(01).
           88 READ-TYPE      VALUE 'R'.
           88 WRITE-TYPE     VALUE 'W'.
           88 UPDTE-TYPE     VALUE 'U'.
           88 DELT-TYPE      VALUE 'D'.
         05 SUB-IDX-KEY.
           15 SUB-IDX-ID     PIC 9(05) COMP-3.
           15 SUB-IDX-DVZ    PIC 9(03) COMP.
      *--------------------
        PROCEDURE DIVISION.
      *--------------------
       MAIN-PRAG.
           PERFORM FILE-OPEN-CONTROL
           PERFORM READ-INP-FILE
           MOVE 'Y' TO EXIT-FLAG
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       MAIN-PRAG-END. EXIT.
      *----
      *----
       FILE-OPEN-CONTROL.
           OPEN INPUT INP-FILE
           OPEN OUTPUT OUT-FILE
           IF (NOT INP-SUCCESS OR NOT OUT-SUCCESS)
            DISPLAY 'FILE CANNOT OPEN'
            DISPLAY 'INP-ST: ' INP-ST
            DISPLAY 'OUT-ST: ' OUT-ST
            MOVE 'Y' TO EXIT-FLAG
            MOVE 99 TO RETURN-CODE
            PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
       READ-INP-FILE.
           READ INP-FILE
           PERFORM UNTIL INP-EOF
            MOVE INP-ID   TO SUB-IDX-ID OUT-ID
            MOVE INP-DVZ  TO SUB-IDX-DVZ OUT-DVZ
            MOVE INP-KEY  TO SUB-IDX-KEY
            MOVE SPACES   TO OUT-MSG
            MOVE INP-TYPE TO PROC-TYPE
            PERFORM SUB-PROG-HANDLE
            PERFORM PRIN-OUT-FILE
            CALL 'PRGEXIT'
            READ INP-FILE
           END-PERFORM.
       READ-INP-FILE-END. EXIT.
      *----
      *----
       SUB-PROG-HANDLE.
           EVALUATE TRUE
           WHEN READ-TYPE
              CALL 'READPROC' USING OUT-MSG-INFO, SUB-IDX-KEY
           WHEN WRITE-TYPE
              CALL 'WRITPROC' USING OUT-MSG-INFO, SUB-IDX-KEY
           WHEN UPDTE-TYPE
              CALL 'UPDTPROC' USING OUT-MSG-INFO, SUB-IDX-KEY
           WHEN DELT-TYPE
              CALL 'DELTPROC' USING OUT-MSG-INFO, SUB-IDX-KEY
           WHEN OTHER
            MOVE 99 TO OUT-RC
            MOVE ' UNDEFINED-PROC-TYPE' TO OUT-MSG
           END-EVALUATE.
       SUB-PROG-HANDLE-END. EXIT.
      *----
      *----
       PRIN-OUT-FILE.
           EVALUATE TRUE
              WHEN READ-TYPE IN PROC-TYPE
                 MOVE '-READ-' TO OUT-RROC-TYP
              WHEN WRITE-TYPE IN PROC-TYPE
                 MOVE '-WRIT-' TO OUT-RROC-TYP
              WHEN UPDTE-TYPE IN PROC-TYPE
                 MOVE '-UPDT-' TO OUT-RROC-TYP
              WHEN DELT-TYPE IN PROC-TYPE
                 MOVE '-DELT-' TO OUT-RROC-TYP
              WHEN OTHER
                 MOVE '-UNDF-' TO OUT-RROC-TYP
           END-EVALUATE
           MOVE 'RC: ' TO OUT-RC-MSG
           WRITE OUT-REC.
           INITIALIZE SUB-AREA
           INITIALIZE OUT-REC.
       PRIN-OUT-FILE-END. EXIT.
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE INP-FILE
               STOP RUN
           END-IF.
      *----
       END PROGRAM MAINPRG.
