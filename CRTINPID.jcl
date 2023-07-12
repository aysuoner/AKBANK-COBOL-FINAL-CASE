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
R30002847
U50001949
Q30342847
U50001969
W30342847
D50301949
D50001949
W50001949
R50001949
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
