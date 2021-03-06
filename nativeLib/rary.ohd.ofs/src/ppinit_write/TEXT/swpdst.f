C MODULE SWPDST
C-----------------------------------------------------------------------
C
C  ROUTINE TO PRINT ERROR MESSAGES BASED ON STATUS CODE FROM
C  PREPROCESSOR DATA BASE READ/WRITE ROUTINES WPDCR AND WPDC.
C
      SUBROUTINE SWPDST (CALLER,STAID,NUMBER,NDLYTP,DLYTYP,
     *   NRRSTP,RRSTYP,IPNTRS,NUMERR,ISTAT)
C
      CHARACTER*(*) CALLER
      CHARACTER*8 STAID
C
      DIMENSION DLYTYP(NDLYTP),RRSTYP(NRRSTP),IPNTRS(1)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_write/RCS/swpdst.f,v $
     . $',                                                             '
     .$Id: swpdst.f,v 1.4 2002/05/15 18:25:56 dws Exp $
     . $' /
C    ===================================================================
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,120)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('DEFN')
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,130) CALLER,STAID,NUMBER,ISTAT
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,140) NDLYTP,(DLYTYP(I),I=1,NDLYTP)
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,150) NRRSTP,(RRSTYP(I),I=1,NRRSTP)
         CALL SULINE (IOSDBG,1)
         NPNTRS=NDLYTP+NRRSTP
         WRITE (IOSDBG,160) NPNTRS,(IPNTRS(I),I=1,NPNTRS)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  CHECK FOR STATUS CODE OF ZERO
      IF (ISTAT.EQ.0) THEN
         WRITE (LP,170) CALLER(1:LENSTR(CALLER))
         CALL SULINE (LP,2)
         GO TO 110
         ENDIF
C
C  CHECK FOR VALID CALLER CODE
      IF (CALLER.NE.'WPDCR'.AND.CALLER.NE.'WPDC') GO TO 100
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      IF (CALLER.NE.'WPDCR') GO TO 70
C
C  WPDCR STATUS CODES
C
      IF (ISTAT.EQ.1) THEN
         WRITE (LP,200) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.2) THEN
         WRITE (LP,210) NUMBER,STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.3.OR.ISTAT.EQ.9.OR.ISTAT.EQ.12) THEN
         WRITE (LP,220) STAID
         CALL SUERRS (LP,2,NUMERR)
         WRITE (LP,230)
         CALL SULINE (LP,2)
         IF (NDLYTP.GT.0) THEN
            DO 10 I=1,NDLYTP
               IF (IPNTRS(I).EQ.-2) THEN
                  WRITE (LP,240) DLYTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
10                CONTINUE
            ENDIF
         IF (NRRSTP.GT.0) THEN
            DO 20 I=1,NRRSTP
               N=NDLYTP+I
               IF (IPNTRS(N).EQ.-2) THEN
                  WRITE (LP,250) RRSTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
20                CONTINUE
            ENDIF
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.4.OR.ISTAT.EQ.9.OR.ISTAT.EQ.11.OR.ISTAT.EQ.12) THEN 
         WRITE (LP,260) STAID
         CALL SUERRS (LP,2,NUMERR)
         WRITE (LP,270)
         CALL SULINE (LP,1)
         IF (NDLYTP.GT.0) THEN
            DO 30 I=1,NDLYTP
               IF (IPNTRS(I).EQ.0) THEN
                  WRITE (LP,240) DLYTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
30                CONTINUE
            ENDIF
         IF (NRRSTP.GT.0) THEN
            DO 40 I=1,NRRSTP
               N=NDLYTP+I
               IF (IPNTRS(N).EQ.0) THEN
                  WRITE (LP,250) RRSTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
40                CONTINUE
            ENDIF
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.5) THEN
         WRITE (LP,280) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.6.OR.ISTAT.EQ.10.OR.ISTAT.EQ.11.OR.ISTAT.EQ.12) THEN
         WRITE (LP,290) STAID
         CALL SUERRS (LP,2,NUMERR)
         IF (NDLYTP.GT.0) THEN
            DO 50 I=1,NDLYTP
               IF (IPNTRS(I).EQ.0) THEN
                  WRITE (LP,240) DLYTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
50                CONTINUE
               ENDIF
         IF (NRRSTP.GT.0) THEN
               N=NDLYTP+I
            DO 60 I=1,NRRSTP
               N=NDLYTP+I
               IF (IPNTRS(N).EQ.0) THEN
                  WRITE (LP,250) RRSTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
60             CONTINUE
            ENDIF
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.7) THEN
         WRITE (LP,300) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.8) THEN
         WRITE (LP,305) 'SIF','CREATE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.13) THEN
         WRITE (LP,310) CALLER(1:LENSTR(CALLER)),'CREATE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.14) THEN
         WRITE (LP,330) CALLER(1:LENSTR(CALLER)),'CREATE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.15) THEN
         WRITE (LP,333) CALLER(1:LENSTR(CALLER)),'CREATE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
CMGM  4/2002 ISTAT EQUALS 20 WHEN THE RRS RECORD NUMBER EXCEEDS 
C     2*I2MAX. ALL POSITIVE AND NEGATIVE RECORD NUMBERS HAVE BEEN 
C     USED (LIMITED BY I2) AND NO MORE RRS RECORDS CAN BE ADDED.
      IF (ISTAT.EQ.20) THEN
         WRITE (LP,334) CALLER(1:LENSTR(CALLER)),'CREATE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      WRITE (LP,190) ISTAT,CALLER(1:LENSTR(CALLER))
      CALL SUERRS (LP,2,NUMERR)
      GO TO 110
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
70    IF (CALLER.NE.'WPDC') GO TO 100
C
C  WPDC STATUS CODES
C
      IF (ISTAT.EQ.1) THEN
         WRITE (LP,340) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.2) THEN
         WRITE (LP,350) NUMBER,STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
       IF (ISTAT.EQ.3.OR.ISTAT.EQ.9.OR.ISTAT.EQ.12) THEN
         WRITE (LP,360) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.4.OR.ISTAT.EQ.9.OR.ISTAT.EQ.11.OR.ISTAT.EQ.12) THEN
         WRITE (LP,370) STAID
         CALL SUERRS (LP,2,NUMERR)
         WRITE (LP,380)
         CALL SULINE (LP,1)
         IF (NDLYTP.GT.0) THEN
            DO 80 I=1,NDLYTP
               IF (IPNTRS(I).EQ.0) THEN
                  WRITE (LP,240) DLYTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
80             CONTINUE
            ENDIF
         IF (NRRSTP.GT.0) THEN
            DO 90 I=1,NRRSTP
               N=NDLYTP+I
               IF (IPNTRS(N).EQ.0) THEN
                  WRITE (LP,250) RRSTYP(I)
                  CALL SULINE (LP,1)
                  ENDIF
90                CONTINUE
             ENDIF
           GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.5) THEN
         WRITE (LP,390) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.6.OR.ISTAT.EQ.10.OR.ISTAT.EQ.11.OR.ISTAT.EQ.12) THEN
         WRITE (LP,300) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.7) THEN
         WRITE (LP,310) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.8) THEN
         WRITE (LP,315) STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.13) THEN
         WRITE (LP,310) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.14) THEN
         WRITE (LP,320) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.15) THEN
         WRITE (LP,330) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.16) THEN
         WRITE (LP,335) STAID
         CALL SULINE (LP,2)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.17) THEN
         WRITE (LP,305) 'SIF','CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.18) THEN
         WRITE (LP,305) 'INDADD','CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      IF (ISTAT.EQ.19) THEN
         WRITE (LP,333) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
CMGM  4/2002 ISTAT EQUALS 20 WHEN THE RRS RECORD NUMBER EXCEEDS 
C     2*I2MAX. ALL POSITIVE AND NEGATIVE RECORD NUMBERS HAVE BEEN 
C     USED (LIMITED BY I2) AND NO MORE RRS RECORDS CAN BE ADDED.
      IF (ISTAT.EQ.20) THEN
         WRITE (LP,334) CALLER(1:LENSTR(CALLER)),'CHANGE',STAID
         CALL SUERRS (LP,2,NUMERR)
         GO TO 110
         ENDIF
C
      WRITE (LP,190) ISTAT,CALLER(1:LENSTR(CALLER))
      CALL SUERRS (LP,2,NUMERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
100   WRITE (LP,180) CALLER(1:LENSTR(CALLER))
      CALL SUERRS (LP,2,NUMERR)
C
110   IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,400)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
120   FORMAT (' *** ENTER SWPDST')
130   FORMAT (' CALLER=',A,3X,'STAID=',A,3X,'NUMBER=',I4,3X,
     *   'ISTAT=',I3)
140   FORMAT (' NDLYTP=',I2,3X,'DLYTYP=',20(A4,1X))
150   FORMAT (' NRRSTP=',I2,3X,'RRSTYP=',20(A4,1X))
160   FORMAT (' NPNTRS=',I2,3X,'IPNTRS=',20(I4,1X))
170   FORMAT ('0*** NOTE - IN SWPDST - STATUS CODE IS ZERO FOR CALLER ',
     *   A,'.')
180   FORMAT ('0*** ERROR - IN SWPDST - ',A,' IS AN INVALID CALLER ',
     *   'TYPE.')
190   FORMAT ('0*** ERROR - IN SWPDST - STATUS CODE ',I3,' ',
     *   'NOT RECOGNIZED FOR CALLER ',A,'.')
200   FORMAT ('0*** ERROR - STATION ',A,' IS ALREADY DEFINED IN ',
     *   'THE PREPROCESSOR DATA BASE.')
210   FORMAT ('0*** ERROR - STATION NUMBER ',I5,' SPECIFIED FOR ',
     *   'STATION ',A,' IS ALREADY ASSIGNED TO ANOTHER STATION.')
220   FORMAT ('0*** ERROR - THE FOLLOWING DATA TYPES TO BE CREATED ',
     *   'IN THE PREPROCESSOR DATA BASE FOR STATION ',A,
     *   'ARE INVALID.')
230   FORMAT (T14,'TYPE MAY BE INVALID BECAUSE IT WAS NOT DEFINED ',
     *   'WHEN FILES WERE CREATED.' /
     *   T14,'STATION CHANGED FOR ALL VALID TYPES.')
240   FORMAT (T14,'DLY DATA TYPE : ',A4)
250   FORMAT (T14,'RRS DATA TYPE : ',A4)
260   FORMAT ('0*** ERROR - THE FOLLOWING DATA TYPES TO BE CREATED ',
     *   'IN THE PREPROCESSOR DATA BASE FOR STATION ',A)
270   FORMAT (T14,'CANNOT BE DEFINED BECAUSE FILES ARE FULL. THOSE ',
     *   'THAT CAN FIT WILL BE DEFINED.')
280   FORMAT ('0*** ERROR - NO DATA TYPES CAN BE DEFINED FOR STATION ',
     *   A,' BECAUSE FILES ARE FULL.')
290   FORMAT ('0*** ERROR - INVALID COMBINATIONS OF DATA TYPES TO BE ',
     *   'DEFINED FOR STATION ',A,'. ALL VALID COMBINATIONS OF ',
     *   'DATA TYPES DEFINED.')
300   FORMAT ('0*** ERROR - NO VALID COMBINATIONS OF DATA TYPES ',
     *   'FOR STATION ',A,' WERE SPECIFIED.')
305   FORMAT ('0*** ERROR - SIZE OF ',A,' ARRAY TOO SMALL TO ',A,' ',
     *   'STATION ',A,'.')
310   FORMAT ('0*** ERROR - SYSTEM ERROR - IN ',A,' - ACCESSING ',
     *   'PREPROCESSOR DATA BASE ',
     *   'WHILE TRYING TO ',A,' STATION ',A,'.')
315   FORMAT ('0*** ERROR - ERROR ENCOUNTERED DELETING DATA TYPES ',
     *   'FOR STATION ',A,'.')
320   FORMAT ('0*** ERROR - IN ',A,' - ARRAY TO STORE DATA TYPES ',
     *   'ADDED TOO SMALL ',
     *   'WHILE TRYING TO ',A,' STATION ',A,'.')
330   FORMAT ('0*** ERROR - IN ',A,' - NO MORE STATION INFORMATION ',
     *   'FILE RECORDS AVAILABLE ',
     *   'WHILE TRYING TO ',A,' STATION ',A,'.')
333   FORMAT ('0*** ERROR - IN ',A,' - INVALID INTEGER*2 VALUE ',
     *   'ENCOUNTERED ',
     *   'WHILE TRYING TO ',A,' STATION ',A,'.')
334   FORMAT ('0*** ERROR - IN ',A,' - MAXIMUM RRS RECORD NUMBER',
     *   ' (INTEGER*2) ENCOUNTERED ',
     *   'WHILE TRYING TO ',A,' STATION ',A,'.')
335   FORMAT ('0*** NOTE - NO INFORMATION NEEDS TO BE ',
     *   'CHANGED IN THE PREPROCESSOR DATA BASE FOR STATION ',A,'.')
340   FORMAT ('0*** ERROR - STATION ',A,' IS NOT DEFINED IN ',
     *   'THE PREPROCESSOR DATA BASE.')
350   FORMAT ('0*** ERROR - STATION NUMBER ',I5,' SPECIFIED FOR ',
     *   'STATION ',A,' IS ALREADY ASSIGNED TO ANOTHER STATION. ',
     *   'NO CHANGES MADE.')
360   FORMAT ('0*** ERROR - CANNOT ADD ALL NEW DATA TYPES OR CHANGE ',
     *   'LENGTH OF OLD RRS TYPES FOR STATION ',A,
     *   'BECAUSE FILES ARE FULL. NO CHANGES MADE.')
370   FORMAT ('0*** ERROR - THE FOLLOWING DATA TYPES TO BE CHANGED ',
     *   'IN THE PREPROCESSOR DATA BASE FOR STATION ',A,
     *   'ARE INVALID.')
380   FORMAT (T14,'STATION CHANGED FOR ALL VALID TYPES.')
390   FORMAT ('0*** ERROR - ALL DATA TYPES TO BE CHANGED ',
     *   'IN THE PREPROCESSOR DATA BASE FOR STATION ',A,
     *   'ARE INVALID. NO CHANGES MADE.')
400   FORMAT (' *** EXIT SWPDST')
C
      END
