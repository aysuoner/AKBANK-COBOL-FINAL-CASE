      ******************************************************************
       IDENTIFICATION DIVISION.
      *----------------------------------------------------------------*
      *>   SUBPRG'i initial belirledim. Bu attribute sub-programdan   <*
      *>    cikilirken acilan tum dosyalarin otomatik olarak          <*
      *>    kapatilmasini sagliyor.                                   <*
      *----------------------------------------------------------------*
       PROGRAM-ID.            SUBPRG IS INITIAL
       AUTHOR.                AYSU ONER.
       DATE-WRITTEN.          10/07/2023.
       DATE-COMPILED.         16/07/2023.
      ******************************************************************
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE    ASSIGN TO  IDXFILE
                              ORGANIZATION INDEXED
                              ACCESS     RANDOM
                              RECORD KEY IDX-KEY
                              STATUS     IDX-ST.
      ******************************************************************
       DATA DIVISION.
      *
       FILE SECTION.
       FD  IDX-FILE.      *>*>.VSAM dosyasindaki veriler tanimlanir <*<*
       01  IDX-REC.
           05 IDX-KEY.
             10  IDX-ID            PIC 9(05)    COMP-3.
             10  IDX-DVZ           PIC 9(03)    COMP.
           05 IDX-FIRSTN           PIC X(15).
           05 IDX-LASTN            PIC X(15).
           05 IDX-JUL              PIC 9(07)    COMP-3.
           05 IDX-AMOUNT           PIC 9(13)V99 COMP-3.
      *
       WORKING-STORAGE SECTION.
            *>*> Dosya ve Process kontrollerini tutan Data-Group <*<*
       01  FILE-FLAGS.
           05 IDX-ST               PIC 9(02).
             88 IDX-SUCCESS                 VALUE 00 97.
           05 EXIT-ST              PIC 9(01).
             88 EXIT-PROG                   VALUE 1.
           05 UPDTE-PRC-ST         PIC 9(01).
             88 UPDT-SUCCESS                VALUE 1.
             88 UPDT-ALREADY                VALUE 2.
      *
             *>*> REMOVE-SPACES fonskiyonunun degiskenlerini *<*<
                        *> tutan Data-Group <*
       01  REMOVE-SPACES-VAR.
           05 SPACE-CHECK          PIC 9(02).
           05 TMP-STR.
             10 LEN                PIC  9(02).
             10 CHARS              PIC  X(15).
             10 I                  PIC  9(02).
             10 J                  PIC  9(02).
             10 K                  PIC  9(02).
           05 RES-STR.
             10 LEN                PIC 9(02).
             10 CHARS              PIC X(15).
      *
              *>*> UST-PROGRAMDAN gonderilen degiskenleri *<*<
                        *> tutan SECTION <*
       LINKAGE SECTION.
       01  LN-SUB-IDX-KEY.
           05 LN-SUB-IDX-ID        PIC 9(05) COMP-3.
           05 LN-SUB-IDX-DVZ       PIC 9(03) COMP.
       01  LN-OUT-MSG-INFO.
           05 LN-OUT-RROC-TYP      PIC X(09).
           05 LN-OUT-RC            PIC 9(02).
           05 LN-OUT-MSG           PIC X(20).
           05 LN-FIRSTNFROM        PIC X(15).
           05 LN-FIRSTNTO          PIC X(15).
           05 LN-LASTNFROM         PIC X(15).
           05 LN-LASTNTO           PIC X(15).
      ******************************************************************
       PROCEDURE DIVISION USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----------------------------------------------------------------*
       FILE-OPEN-CONTROL.
           OPEN I-O IDX-FILE
           IF NOT IDX-SUCCESS
             DISPLAY '.VSAM FILE CANNOT OPEN: '
             DISPLAY 'IDX-ST: ' IDX-ST
             SET EXIT-PROG TO TRUE
             MOVE IDX-ST TO RETURN-CODE
             PERFORM EXIT-SUBPROG
           END-IF.
           MOVE LN-SUB-IDX-KEY TO IDX-KEY.
       FILE-OPEN-CONTROL-END. EXIT.
      *====
      *================================================================*
      *>   ENTRY point ==> Sub-programda alternatif bir giris noktasi 
      *>     olusturur. Ust-programda bu ENTRY point belirtilirse
      *>     alt-program direkt bu ENRTY noktasindan baslar.
      *>   Boylelıkle alt-programa belirli bir .Vsam isi icin 
      *>   gelinir ve tekrar ust-programa donulur.
      *================================================================*
           ENTRY 'READPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----------------------------------------------------------------*
           PERFORM FILE-OPEN-CONTROL
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             MOVE ' RECORD READ' TO LN-OUT-MSG
           END-READ.
           MOVE '-READ-RC:' TO LN-OUT-RROC-TYP
           MOVE IDX-ST TO LN-OUT-RC
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *----------------------------------------------------------------*
      *>   Once READ ile .VSAM'a yazdirilacak KEY'i ariyorum.
      *>    Eger boyle bir key yoksa yeni olusturulacak RECORD'a
      *>    atamalari yapiyorum. Boylelikle DUPLICATE RECORD direkt 
      *>    WRITE statement'a atliyor.
      *----------------------------------------------------------------*
           ENTRY 'WRITPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----------------------------------------------------------------*
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
              MOVE ' DUPLICATE RECORD' TO LN-OUT-MSG
           NOT INVALID KEY
              MOVE ' NEW RECORD ADDED' TO LN-OUT-MSG
           END-WRITE.
           MOVE '-WRIT-RC:' TO LN-OUT-RROC-TYP
           MOVE IDX-ST TO LN-OUT-RC
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *----------------------------------------------------------------*
      *>   Odev UPDATE yapilirken isimde space varsa kaldirmamizi,
      *>    soyisimde ise e ===> i VE a ===> e donusumunu istemekte.
      *>   Ayni zamanda isimde bosluk yoksa ALREADY UPDATED 
      *>    bilgisi verilmelidir.
      *----------------------------------------------------------------*
           ENTRY 'UPDTPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----------------------------------------------------------------*
           PERFORM FILE-OPEN-CONTROL
           READ IDX-FILE KEY IS IDX-KEY
           NOT INVALID KEY
             PERFORM REMOVE-SPACES
             PERFORM REPLACING-CHR
           END-READ.
           REWRITE IDX-REC
           INVALID KEY
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             IF UPDT-ALREADY
               MOVE ' ALREADY UPDATED' TO LN-OUT-MSG
             ELSE
               MOVE ' RECORD UPDATED' TO LN-OUT-MSG
             END-IF
           END-REWRITE.
           MOVE '-UPDT-RC:' TO LN-OUT-RROC-TYP
           MOVE IDX-ST TO LN-OUT-RC
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *----
      *----------------------------------------------------------------*
           ENTRY 'DELTPROC' USING LN-OUT-MSG-INFO, LN-SUB-IDX-KEY.
      *----------------------------------------------------------------*
           PERFORM FILE-OPEN-CONTROL
           DELETE IDX-FILE RECORD
           INVALID KEY
             MOVE ' RECORD NOT FOUND' TO LN-OUT-MSG
           NOT INVALID KEY
             MOVE ' RECORD DELETED' TO LN-OUT-MSG
           END-DELETE.
           MOVE '-DELT-RC:' TO LN-OUT-RROC-TYP
           MOVE IDX-ST TO LN-OUT-RC
           SET EXIT-PROG TO TRUE.
           PERFORM EXIT-SUBPROG.
      *
            *>   UTILITY FUNCTIONS OF UPDTPROC *<
      *----------------------------------------------------------------*
       REMOVE-SPACES.
           MOVE IDX-FIRSTN TO CHARS OF TMP-STR LN-FIRSTNFROM
           MOVE 1 TO I J SPACE-CHECK
           COMPUTE LEN OF TMP-STR = LENGTH OF CHARS OF TMP-STR
           PERFORM UNTIL I > LEN OF TMP-STR  *>stringi sonuna kadar oku
             MOVE 0 TO K
             UNSTRING CHARS OF TMP-STR
               DELIMITED BY ' '     *> her boslukta res-str'nin J'inden
               INTO CHARS OF RES-STR(J:)         *> itibaren ekleme yap
               COUNT IN K
               WITH POINTER I
             END-UNSTRING
            IF J = 1
              MOVE K TO SPACE-CHECK *> update-crtl icin ilk res-str
            END-IF                      *> degerinin uzunlugu alinir
             ADD K to J
           END-PERFORM
           PERFORM UPDATE-CTRL
           MOVE CHARS OF RES-STR TO IDX-FIRSTN LN-FIRSTNTO.
       REMOVE-SPACES-END. EXIT.
      *----
      *----------------------------------------------------------------*
       UPDATE-CTRL.
           COMPUTE LEN OF RES-STR = J - 1
           IF (LEN OF RES-STR IS NOT EQUAL TO SPACE-CHECK)
                 SET UPDT-SUCCESS TO TRUE
           ELSE
                SET UPDT-ALREADY TO TRUE
           END-IF.
       UPDATE-CTRL-END. EXIT.
      *----
      *----------------------------------------------------------------*
       REPLACING-CHR.
           MOVE IDX-LASTN TO CHARS OF TMP-STR LN-LASTNFROM
           INSPECT CHARS OF TMP-STR
           REPLACING ALL 'e' BY 'i',
                         'E' BY 'I',
                         'a' BY 'e',
                         'A' BY 'E'
           MOVE CHARS OF TMP-STR TO IDX-LASTN LN-LASTNTO.
       REPLACING-CHR-END. EXIT.
      *----
      *----------------------------------------------------------------*
       EXIT-SUBPROG.
           IF EXIT-PROG
               GOBACK
           END-IF.
       EXIT-SUBPROG-END. EXIT.

      *NOT: INPFILE'DA BIR DEGISIKLIK YAPTIKTAN SONRA MAIN'I CALISTIRDI
      *GINDA ISTEDIGIN VERIYI ALAMIYORSAN ONCE VSAM DOSYASINI SUBMIT ET
      *CUNKU BIR ONCEKI WRITE DELT- UPDATE ISLEMI ILE ILK VSAM
      *DEGISMIS OLABILIR. BUNU NOT OLARAL README.md EKLE!!!!!
      *
      *     jcl duzelt dene!!!!!!
      *     tum jclleri gozden gecir
      *    program RETURN CODE gerekli mi arastir
