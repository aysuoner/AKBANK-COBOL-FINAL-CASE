       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       data division.
       WORKING-STORAGE SECTION.
       01  STR.
           05 LEN      PIC  9(02).
           05 STR-CHR  PIC  X(80).
           05 I        PIC 9(02).    
           05 J        PIC 9(02).    
           05 K        PIC 9(02).    
       01  result.
           05 LEN      PIC  9(02).
           05 STR-CHR  PIC  X(80).
       procedure division.
           move 1 to  I J
           MOVE 22 to len of STR
           MOVE ' W e Lc ome   ay s   u ' TO STR-CHR of str.
           perform until I > len of STR
            move 0 to K
            unstring STR-CHR of STR
              delimited by ' '
              into STR-CHR of RESULT(j:)
              count in K
              with pointer I
            ADD J TO K GIVING J
           end-perform
           compute len of result = j - 1
           DISPLAY 'str: ' STR-CHR of result
           DISPLAY len OF RESULT
           goback.
      