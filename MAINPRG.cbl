      *------------------------
       IDENTIFICATION DIVISION.
      *------------------------
       PROGRAM-ID.    MAINPRG.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  10/07/2023.
       DATE-COMPILED. 16/07/2023.
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
		     05 INP-TYPE           PIC X(01).
             88 READ-TYPE                 VALUE 'R'.
             88 WRITE-TYPE                VALUE 'W'.
             88 UPDTE-TYPE                VALUE 'U'.
             88 DELT-TYPE                 VALUE 'D'.
           05 INP-KEY.
             10 INP-ID           PIC 9(05) COMP-3.
             10 INP-DVZ          PIC 9(03) COMP.
      *****
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-REC.
           05 OUT-KEY-INFO.
             10 OUT-ID           PIC 9(05).
             10 OUT-DVZ          PIC 9(03).
           05 OUT-MSG-INFO.
             10 OUT-RROC-TYP     PIC X(09).
             10 OUT-RC           PIC 9(02).
             10 OUT-MSG          PIC X(20).
             10 OUT-FROM         PIC X(36).
             10 OUT-TO           PIC X(34).
      *****
       WORKING-STORAGE SECTION.
       01  FILE-FLAGS.
           05 INP-ST             PIC 9(02).
             88 INP-EOF                   VALUE 10.
             88 INP-SUCCESS               VALUE 00 97.
           05 OUT-ST             PIC 9(02).
             88 OUT-SUCCESS               VALUE 00 97.
           05 EXIT-ST            PIC X(01).
             88 EXIT-FLAG                 VALUE 'Y'.
       01  SUB-AREA.
           05 SUB-IDX-KEY.
             10 SUB-IDX-ID       PIC 9(05) COMP-3.
             10 SUB-IDX-DVZ      PIC 9(03) COMP.
           05 SUB-OUT-MSG-INFO.
             10 SUB-OUT-RROC-TYP PIC X(09).
             10 SUB-OUT-RC       PIC 9(02).
             10 SUB-OUT-MSG      PIC X(20).
             10 SUB-FIRSTNFROM   PIC X(15).
             10 SUB-FIRSTNTO     PIC X(15).
             10 SUB-LASTNFROM    PIC X(15).
             10 SUB-LASTNTO      PIC X(15).
      *--------------------
        PROCEDURE DIVISION.
      *--------------------
       MAIN-PRAG.
           PERFORM FILE-OPEN-CONTROL
           PERFORM READ-INP-FILE
           SET EXIT-FLAG TO TRUE
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       MAIN-PRAG-END. EXIT.
      *----
      *----
       FILE-OPEN-CONTROL.
           OPEN INPUT  INP-FILE
           OPEN OUTPUT OUT-FILE
           IF (NOT INP-SUCCESS OR NOT OUT-SUCCESS)
            DISPLAY 'FILE CANNOT OPEN'
            DISPLAY 'INP-ST: ' INP-ST
            DISPLAY 'OUT-ST: ' OUT-ST
            SET EXIT-FLAG TO TRUE
            MOVE 99 TO RETURN-CODE
            PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
       READ-INP-FILE.
      *burada neden yukarida inp-kullandigini acikla
           READ INP-FILE
           PERFORM UNTIL INP-EOF
            MOVE INP-ID   TO SUB-IDX-ID OUT-ID
            MOVE INP-DVZ  TO SUB-IDX-DVZ OUT-DVZ
            MOVE INP-KEY  TO SUB-IDX-KEY
            MOVE SPACES   TO OUT-MSG
            MOVE SPACES   TO OUT-FROM
            MOVE SPACES   TO OUT-TO
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
              CALL 'READPROC' USING SUB-OUT-MSG-INFO, SUB-IDX-KEY
           WHEN WRITE-TYPE
              CALL 'WRITPROC' USING SUB-OUT-MSG-INFO, SUB-IDX-KEY
           WHEN UPDTE-TYPE
              CALL 'UPDTPROC' USING SUB-OUT-MSG-INFO, SUB-IDX-KEY
           WHEN DELT-TYPE
              CALL 'DELTPROC' USING SUB-OUT-MSG-INFO, SUB-IDX-KEY
           WHEN OTHER
            MOVE 99 TO SUB-OUT-RC
            MOVE ' UNDEFINED-PROC-TYPE' TO SUB-OUT-MSG
            MOVE '-UNDF-RC:' TO SUB-OUT-RROC-TYP
           END-EVALUATE.
       SUB-PROG-HANDLE-END. EXIT.
      *----
      *----
       PRIN-OUT-FILE.
           MOVE SUB-OUT-RROC-TYP TO OUT-RROC-TYP
           MOVE SUB-OUT-MSG TO OUT-MSG 
           MOVE SUB-OUT-RC TO OUT-RC
           IF INP-TYPE IS EQUAL TO  'U' AND OUT-RC IS ZERO 
            STRING 'FROM: ' DELIMITED BY SIZE
                   SUB-FIRSTNFROM DELIMITED BY SIZE
                   SUB-LASTNFROM DELIMITED BY SIZE
                  INTO OUT-FROM
            END-STRING
            STRING 'TO: ' DELIMITED BY SIZE
                   SUB-FIRSTNTO DELIMITED BY SIZE
                   SUB-LASTNTO DELIMITED BY SIZE
                  INTO OUT-TO
            END-STRING
           END-IF.
           WRITE OUT-REC
           INITIALIZE SUB-OUT-MSG-INFO
           INITIALIZE SUB-IDX-KEY
           INITIALIZE OUT-REC.
       PRIN-OUT-FILE-END. EXIT.
      *----
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG
               CLOSE INP-FILE
               CLOSE OUT-FILE
               STOP RUN
           END-IF.
       END PROGRAM MAINPRG.
      *----
      *----
      * 01  FUNC-CALLER-FLAGS     PIC 9(01).          
      *       88 ERROR-MSG                 VALUE 1.
      *       88 FILL-KEY                  VALUE 2.
      *       88 FILL-OUT-REC              VALUE 3.
      *----
      *----
      * FROM-TO-HANDLE.
      *     STRING 'FROM: ' DELIMITED BY SIZE
      *            SUB-FIRSTNFROM DELIMITED BY SIZE
      *            SUB-LASTNFROM DELIMITED BY SIZE
      *           INTO OUT-FROM
      *     END-STRING.
      *     STRING 'TO: ' DELIMITED BY SIZE
      *            SUB-FIRSTNTO DELIMITED BY SIZE
      *            SUB-LASTNTO DELIMITED BY SIZE
      *           INTO OUT-TO
      *     END-STRING.
      * FROM-TO-HANDLE-END. EXIT.
      *----
      *----
      * UTILITY-FUNC.
      *     EVALUATE TRUE
      *     WHEN FILL-KEY 
      *      MOVE INP-ID   TO SUB-IDX-ID OUT-ID
      *      MOVE INP-DVZ  TO SUB-IDX-DVZ OUT-DVZ
      *      MOVE INP-KEY  TO SUB-IDX-KEY
      *      MOVE SPACES   TO OUT-MSG
      *      MOVE SPACES   TO OUT-FROM
      *      MOVE SPACES   TO OUT-TO
      *     END-EVALUATE.
      * UTILITY-FUNC-END. EXIT.
      *----