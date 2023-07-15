//CRTINPID JOB ' ',CLASS=A,MSGLEVEL=(1,1),MSGCLASS=A,NOTIFY=Z95610
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95610.QSAM.INP NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
/*
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
R10001571
U10002840
R10002840
W10003911
D10005911
R10009840
W10007433
W10002840
D10007433
R10003911
D10007433
W10007433
R10007433
U10007433
R10006978
U10006978
R10006978
R10008949
U10008949
R10008949
C10011501
U10032412
U10007433
U10009840
/*
//SORTOUT  DD DSN=Z95610.QSAM.INP,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=6)
//SYSIN    DD *
  SORT FIELDS=COPY
  OUTREC FIELDS=(1,1,
                 2,5,ZD,TO=PD,LENGTH=3,
                 7,3,ZD,TO=BI,LENGTH=2)
/*
