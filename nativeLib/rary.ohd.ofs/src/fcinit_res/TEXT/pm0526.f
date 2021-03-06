C MEMBER PM0526
C  (from old member FCPM0526)
C
      SUBROUTINE PM0526(WORK,IUSEW,LEFTW,NP05,
     .                  LENDSU,JDEST,IERR)
C--------------------------------------------------------------------
C  ROUTINE TO GET AND CHECK PARAMETERS FOR S/U #05 -
C   FILL AND SPILL SCHEME
C---------------------------------------------------------------------
C  JTOSTROWSKI - HRL - MARCH 1983
C----------------------------------------------------------------
C
C
      INCLUDE 'common/comn26'
C
C
      INCLUDE 'common/err26'
C
C
      INCLUDE 'common/fld26'
C
C
      INCLUDE 'common/read26'
C
C
      INCLUDE 'common/suky26'
C
C
      INCLUDE 'common/warn26'
C
C
      DIMENSION WORK(1),INPUT(3)
      EQUIVALENCE (INPUT(3),ICOUNT)
C
      LOGICAL SPWYOK,ENDFND,ALLOK
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_res/RCS/pm0526.f,v $
     . $',                                                             '
     .$Id: pm0526.f,v 1.1 1995/09/17 18:51:58 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA INPUT/4HQLIM,4H    ,4H    /
      DATA CODEFS/1050.01/
C
C  INITIALIZE LOCAL VARIABLES AND COUNTERS
C
      ENDFND = .FALSE.
      QLIM = 0.0
      ICOUNT = 0
C
      NP05 = 0
C
      IP = 0
C
C
      IERR = 0
C
C  PARMS FOUND, LOOKING FOR ENDP
C
      LPOS = LSPEC + NCARD + 1
      LASTCD = LENDSU
      IBLOCK = 1
C
    5 IF (NCARD .LT. LASTCD) GO TO 8
           CALL STRN26(59,1,SUKYWD(1,7),3)
           IERR = 99
           GO TO 9
    8 NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
      IF(IERF .GT. 0 ) GO TO 9000
      NUMWD = (LEN -1)/4 + 1
      IDEST = IKEY26(CHAR,NUMWD,SUKYWD,LSUKEY,NSUKEY,NDSUKY)
      IF (IDEST.EQ.0) GO TO 5
C
C  IDEST = 7 IS FOR ENDP
C
      IF (IDEST.EQ.7.OR.IDEST.EQ.8) GO TO 9
          CALL STRN26(59,1,SUKYWD(1,7),3)
          JDEST = IDEST
          IERR = 89
    9 LENDP = NCARD
C
C  ENDP CARD OR TS OR CO FOUND AT LENDP,
C  ALSO ERR RECOVERY IF NEITHER ONE OF THEM FOUND.
C
C
      IBLOCK = 2
      CALL POSN26(MUNI26,LPOS)
      NCARD = LPOS - LSPEC -1
C
   10 CONTINUE
      NUMFLD = 0
      CALL UFLD26(NUMFLD,IERF)
      IF(IERF .GT. 0) GO TO 9000
      IF (NCARD.LT.LENDP) GO TO 20
          CALL POSN26(MUNI26,LPOS)
          IBLOCK = 3
          GO TO 200
   20 CONTINUE
      IF (IUSAME(CHAR,INPUT,1).EQ.1) GO TO 100
          ICOUNT = ICOUNT + 1
          GO TO 10
C
C----------------------------------------------------------------------
C  'QLIM' FOUND, NOW GET SPECIFICATION
C
  100 CONTINUE
      IP = IP + 1
      IF (IP.GT.1) CALL STER26(39,1)
C
      NUMFLD = -2
      CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
C  VALUE MUST BE REAL AND POSITIVE
C
      IF (ITYPE.LE.1) GO TO 110
      CALL STER26(4,1)
      GO TO 210
C
  110 CONTINUE
      IF (REAL.GE.0.00) GO TO 120
      CALL STER26(95,1)
      GO TO 210
C
C  VALUE IS OK. CONVERT TO METRIC.
C
  120 CONTINUE
      QLIM = REAL/CONVL3
C
C  STORE VALUE OF LIMITING Q IN 'WORK'.
C
  200 CONTINUE
      CALL FLWK26(WORK,IUSEW,LEFTW,QLIM,501)
C
C  THE 1ST KEYWORD MUST BE QLIM IF NEEDED.
C
      IF (ICOUNT.EQ.0.OR.IP.EQ.0) GO TO 205
C
           NFLD = 1
           CALL STRN26(100,1,INPUT,3)
           CALL STER26(101,1)
  205 CONTINUE
      IF (IBLOCK.EQ.3) NCARD = LPOS - LSPEC - 1
C
      NP05 = 1
C
C  WE NOW NEED TO CALL PM0626 TO GET THE SPILLWAY DEFINITION
C
  210 CONTINUE
C
      CALL PM0626(WORK,IUSEW,LEFTW,NPSPWY,CODEFS,SPWYOK,
     .            LENDSU,JDEST,IERR)
      IF (.NOT.SPWYOK) GO TO 9999
C
C  'ENDP' FOUND IN PM0626. WE ONLY NEED TO UPDATE THE NUMBER OF VALUES
C   STORED IN 'WORK'.
C
      NP05 = NP05 + NPSPWY
      GO TO 9999
C
C--------------------------------------------------------------
C  ERROR IN UFLD26
C
 9000 CONTINUE
      IF (IERF.EQ.1) CALL STER26(19,1)
      IF (IERF.EQ.2) CALL STER26(20,1)
      IF (IERF.EQ.3) CALL STER26(21,1)
      IF (IERF.EQ.4) CALL STER26( 1,1)
C
      IF (NCARD.GE.LASTCD) GO TO 9100
      IF (IBLOCK.EQ.1)  GO TO 5
      IF (IBLOCK.EQ.2)  GO TO 10
C
 9100 USEDUP = .TRUE.
C
 9999 CONTINUE
      RETURN
      END
