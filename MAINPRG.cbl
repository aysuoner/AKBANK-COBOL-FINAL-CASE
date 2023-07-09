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
      *---------------
        DATA DIVISION.
      *---------------
       FILE SECTION.
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
		     05 INP-TYPE       PIC X(01).
           05 INP-ID         PIC 9(05) COMP-3.
           05 INP-DVZ        PIC 9(03) COMP.
      *****
       WORKING-STORAGE SECTION.
       01  EXIT-FLAG         PIC X(01) VALUE 'N'.
       01  FILE-FLAGS.
           05 INP-ST         PIC 9(02).
              88 INP-EOF     VALUE 10.
              88 INP-SUCCESS VALUE 00 97.
      *--------------------
        PROCEDURE DIVISION.
      *--------------------
           OPEN INPUT INP-FILE.
      *----
       FILE-OPEN-CONTROL.
           IF NOT INP-SUCCESS
             DISPLAY 'FILE CANNOT OPEN'
             MOVE 'Y' TO EXIT-FLAG
             MOVE 99 TO RETURN-CODE
             PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
       READ-INP-FILE.
           READ INP-FILE
           PERFORM UNTIL INP-EOF
              CALL 'SUBPRG' USING INP-TYPE, INP-ID, INP-DVZ
              READ INP-FILE
           END-PERFORM.
           MOVE 'Y' TO EXIT-FLAG
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       READ-INP-FILE-END. EXIT.
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE INP-FILE
               STOP RUN
           END-IF.
      *----
       END PROGRAM MAINPRG.