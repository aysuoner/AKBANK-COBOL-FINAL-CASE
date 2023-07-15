      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.                MAINPRG.
       AUTHOR.                    AYSU ONER.
       DATE-COMPILED.             16/07/2023.
       DATE-WRITTEN.              10/07/2023.

      ******************************************************************
       ENVIRONMENT DIVISION.
      *----------------------------------------------------------------*
      *> External data-setler ile internal dosyalar iliskilendirilir. <*
      *----------------------------------------------------------------*
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE        ASSIGN TO  INPFILE
                                  STATUS     INP-ST.
           SELECT OUT-FILE        ASSIGN TO  OUTFILE
                                  STATUS     OUT-ST.
      ******************************************************************
       DATA DIVISION.
      *----------------------------------------------------------------*
      *>   INP-FILE ==> input olarak kullanilan dosyanin icindeki     <*
      *>                veriler tanimlanir.                           <*
      *>   OUT-FILE ==> program sonunda olusturulacak out dosyasinin  <*
      *>                icinde bulunacak verileri tanimlar.           <*
      *-----------------------------------------------------------------
       FILE SECTION.
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 PROC-TYPE            PIC X(01).
             88 READ-TYPE                  VALUE 'R'.
             88 WRITE-TYPE                 VALUE 'W'.
             88 UPDTE-TYPE                 VALUE 'U'.
             88 DELT-TYPE                  VALUE 'D'.
           05 INP-KEY.
             10 INP-ID            PIC 9(05) COMP-3.
             10 INP-DVZ           PIC 9(03) COMP.
      *
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-REC.
           05 OUT-KEY-INFO.
             10 OUT-ID            PIC 9(05).
             10 OUT-DVZ           PIC 9(03).
           05 OUT-MSG-INFO.
             10 OUT-RROC-TYP      PIC X(09).
             10 OUT-RC            PIC 9(02).
             10 OUT-MSG           PIC X(20).
             10 OUT-FROM          PIC X(36).
             10 OUT-TO            PIC X(34).
      *----------------------------------------------------------------*
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------*
              *>*> Dosya kontrollerini tutan Data-Group <*<*
       01  FILE-FLAGS.
           05 INP-ST              PIC 9(02).
             88 INP-EOF                    VALUE 10.
             88 INP-SUCCESS                VALUE 00 97.
           05 OUT-ST              PIC 9(02).
             88 OUT-SUCCESS                VALUE 00 97.
           05 PRGM-EXIT-ST        PIC X(01).
             88 CLOSE-FILE                 VALUE 'Y'.
      *
              *>*> SUB-PRGM'a gonderilecek Data-Group   <*<*
       01  SUB-AREA.
           05 SUB-IDX-KEY.     *> RECORD-KEY data-items <*
             10 SUB-IDX-ID        PIC 9(05) COMP-3.
             10 SUB-IDX-DVZ       PIC 9(03) COMP.
      *
           05 SUB-OUT-INFO.    *> OUT-FILE data-items   *<
             10 SUB-OUT-RROC-TYP  PIC X(09).
             10 SUB-OUT-RC        PIC 9(02).
             10 SUB-OUT-MSG       PIC X(20).
             10 SUB-FIRSTNFROM    PIC X(15).
             10 SUB-FIRSTNTO      PIC X(15).
             10 SUB-LASTNFROM     PIC X(15).
             10 SUB-LASTNTO       PIC X(15).
      ******************************************************************
        PROCEDURE DIVISION.
      *----------------------------------------------------------------*
       MAIN-PRAG.
           PERFORM FILE-OPEN-CONTROL
           PERFORM READ-INP-FILE
           SET CLOSE-FILE TO TRUE
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       MAIN-PRAG-END. EXIT.
      *----------------------------------------------------------------*
       FILE-OPEN-CONTROL.
           OPEN INPUT  INP-FILE
           OPEN OUTPUT OUT-FILE
           IF (NOT INP-SUCCESS OR NOT OUT-SUCCESS)
            DISPLAY 'FILE CANNOT OPEN'
            DISPLAY 'INP-ST: ' INP-ST
            DISPLAY 'OUT-ST: ' OUT-ST
            SET CLOSE-FILE TO TRUE
            MOVE 99 TO RETURN-CODE
            PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *----
      *----------------------------------------------------------------*
      *>   Input-file, EOF'a kadar okunması icin donguye alinir       <*
      *>    ANCAK bos input dosyasinin donguye girmemesi icin         <*
      *>    basta READ INP-FILE islemi gerceklestirilir.              <*
      *----------------------------------------------------------------*
       READ-INP-FILE.
           READ INP-FILE
           PERFORM UNTIL INP-EOF
            MOVE INP-ID   TO SUB-IDX-ID OUT-ID
            MOVE INP-DVZ  TO SUB-IDX-DVZ OUT-DVZ
            MOVE INP-KEY  TO SUB-IDX-KEY
            MOVE SPACES   TO OUT-MSG
            MOVE SPACES   TO OUT-FROM
            MOVE SPACES   TO OUT-TO
            PERFORM SUB-PROG-HANDLE
            PERFORM PRNT-OUT-FILE
            READ INP-FILE
           END-PERFORM.
       READ-INP-FILE-END. EXIT.
      *----
      *----------------------------------------------------------------*
      *>   .VSAM islemlerini SUBPRG'da gerceklestirir.                <*
      *>   Process-tipine uygun fonksiyon SUBPRG'dan -CALL- edilir    <*
      *>   SUBPRG'dan belli bir fonsiyonu CALL etmek icin SUBPRG'da   <*
      *>    -ENTRY- point kullanilir!                                 <*
      *>   WHEN-OTHER ==> PROC-TYPE belirtilenlerin(R-W-U-D)          <*
      *>    disinda bir karakterse SUBPRG CALL edilmez                <*
      *----------------------------------------------------------------*
       SUB-PROG-HANDLE.
           EVALUATE TRUE
           WHEN READ-TYPE
              CALL 'READPROC' USING SUB-OUT-INFO, SUB-IDX-KEY
           WHEN WRITE-TYPE
              CALL 'WRITPROC' USING SUB-OUT-INFO, SUB-IDX-KEY
           WHEN UPDTE-TYPE
              CALL 'UPDTPROC' USING SUB-OUT-INFO, SUB-IDX-KEY
           WHEN DELT-TYPE
              CALL 'DELTPROC' USING SUB-OUT-INFO, SUB-IDX-KEY
           WHEN OTHER
            MOVE '-UNDF-RC:' TO SUB-OUT-RROC-TYP
            MOVE 99 TO SUB-OUT-RC
            MOVE ' UNDEFINED-PROC-TYPE' TO SUB-OUT-MSG
           END-EVALUATE.
       SUB-PROG-HANDLE-END. EXIT.
      *----
      *----------------------------------------------------------------*
      *>   SUB-PRGM'a gidip dolan veriler OUT-FILE degiskenlerine     <*
      *>    aktarilir.                                                <*
      *>   Odev'de UPDATE'de giden inputun before/after hali          <*
      *>    istendiginden 88 UPDATE-TYPE ozellikle kontrol edilir ve  <*
      *>    UPDATE-PROC icin OUT-FROM // OUT-TO verileri doldurulur   <*
      *----------------------------------------------------------------*
       PRNT-OUT-FILE.
           MOVE SUB-OUT-RROC-TYP TO OUT-RROC-TYP
           MOVE SUB-OUT-MSG      TO OUT-MSG
           MOVE SUB-OUT-RC       TO OUT-RC
           IF UPDTE-TYPE AND OUT-RC IS ZERO
            STRING 'FROM: '       DELIMITED BY SIZE
                   SUB-FIRSTNFROM DELIMITED BY SIZE
                   SUB-LASTNFROM  DELIMITED BY SIZE
                   INTO OUT-FROM
            END-STRING
            STRING 'TO: '       DELIMITED BY SIZE
                   SUB-FIRSTNTO DELIMITED BY SIZE
                   SUB-LASTNTO  DELIMITED BY SIZE
                  INTO OUT-TO
            END-STRING
           END-IF.
           WRITE OUT-REC
           INITIALIZE SUB-OUT-INFO
           INITIALIZE SUB-IDX-KEY
           INITIALIZE OUT-REC.
       PRNT-OUT-FILE-END. EXIT.
      *----
      *----------------------------------------------------------------*
      *>   Programi sonlandiran bu fonksiyonda STOP-RUN'a             <*
      *>    88 CLOSE-FILE conditation'i ile ulasilir                  <*
      *>   PERFORM ile direkt cikis gerceklesmedigi icin              <*
      *>    Program ReturnCode 00 ile bitmis olur.                    <*
      *----------------------------------------------------------------*
       PROGRAM-EXIT.
           IF CLOSE-FILE
               CLOSE INP-FILE
               CLOSE OUT-FILE
               STOP RUN
           END-IF.
       END PROGRAM MAINPRG.