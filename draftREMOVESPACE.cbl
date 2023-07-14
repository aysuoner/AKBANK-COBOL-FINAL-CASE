       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       data division.
       WORKING-STORAGE SECTION.
       01  LOOP-COUNT  PIC 9(02).
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
           move 1 to  I J LOOP-COUNT 
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
           ADD 1 TO LOOP-COUNT
           end-perform
           compute len of result = j - 1
           DISPLAY 'str: ' STR-CHR of result
           DISPLAY len OF RESULT
           DISPLAY 'LOP: ' LOOP-COUNT 
           goback.
      

      * identification division.
      * program-id. shortcut.
      *
      * data division.
      *
      * linkage section.
      * 01  str.
      *     05 len      pic 99.
      *     05 chars.
      *         10 cs pic x occurs 0 to 80 times 
      *               depending on len of str indexed by i j k.
      * 01  result.
      *     05 len      pic 99.
      *     05 chars    pic x(80).
      *
      * procedure division using str result.
      *     set i j to 1
      *     perform until i > len of str
      *       set k to 0
      *       unstring chars of str
      *         delimited by 'a' or 'e' or 'i' or 'o' or 'u'
      *         into chars of result(j:)
      *         count in k
      *         with pointer i
      *       set j up by k
      *     end-perform
      *     compute len of result = j - 1
      *     goback.
      *  end program shortcut.
      *
*