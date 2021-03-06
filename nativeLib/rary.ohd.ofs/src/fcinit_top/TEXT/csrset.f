C MEMBER CSRSET
C  (from old member FCCSRSET)
C
C DESC 'IN-CORE SORTING PACKAGE FOR CARRYOVER USED IN CGDEF COMMAND'
C.......................................................................
C                             LAST UPDATE: 07/27/95.12:12:15 BY $WC21DT
C
      SUBROUTINE CSRSET(C,NC,ISLOT,NSAVE,NARAYS,ARAY1,LARAY1,ARAY2,
     .  LARAY2,ARAY3,LARAY3,ARAY4,LARAY4,ARAY5,LARAY5,ARAY6,LARAY6,
     .  ARAY7,LARAY7,ARAY8,LARAY8,ARAY9,LARAY9,ARAY10,LARA10,IER)
C
C  IN-CORE SORTING PACKAGE USED TO SORT C ARRAYS DURING CARRYOVER
C  GROUP DEFINITION.  THE ORIGINAL PACKAGE HAD THREE ROUTINES --
C    1.CSRSET -- MUST BE CALLED FIRST TO SET UP THE BOOKKEEPING
C                ARRAYS FOR LATER CALLS.
C    2.CSAVE  -- USED TO PLACE A C ARRAY INTO A SPECIFIED SLOT IN
C                CORE FOR LATER RETRIEVAL.
C    3.CRETRV -- USED TO RETRIEVE A PREVIOUSLY SAVED C ARRAY.
C
C  ALL ARGUMENTS TO ALL THREE ENTRIES RETAIN THE SAME MEANING.
C
C  ARGUMENT  DESCRIPTION
C  --------  ----------------------------------------------------------
C  C         C ARRAY
C  NC        LENGTH OF C ARRAY. MUST BE UNCHANGED IN CALLS TO CSAVE AND
C            CRESTR AFTER CSRSET IS CALLED TO SET UP BOOKKEEPING FOR A
C            SPECIFIC SIZE C ARRAY.
C  ISLOT     SLOT TO SAVE OR RETRIEVE C ARRAY INTO/FROM.(NOT USED IN
C            ENTRY CSRSET)
C  NSAVE     MAX NUMBER OF SLOTS TO BE SAVED.  MUST NOT BE ALTERED
C            AFTER CSRSET IS CALLED.
C  ARAY*     WORKING STORAGE ARRAY *   THESE ROUTINES ARE WRITTEN TO
C            USE UP TO 10 WORKING STORAGE ARRAYS(IF NEEDED) OF ANY
C            AVAILABLE SIZE.  OF COURSE, THE CALLS TO CSRSET, CSAVE,
C            AND CRESTR MUST HAVE EXACTLY THE SAME WORKING STORAGE
C            ARRAYS IN EXACTLY THE SAME ORDER.
C  LARAY*    LENGTH OF THE *-TH WORKING STORAGE ARRAY.(VALUE OF ZERO
C            IS LEGAL)
C  IER       SET TO 0 FOR NORMAL RETURN, =1 IF ERROR OCCURS.
C
C  ROUTINE ORIGINALLY WRITTEN BY --
C    ED JOHNSON -- HRL -- 14 NOV 1979
C.......................................................................
      DIMENSION C(NC)
      DIMENSION ARAY1(NSAVE,1),ARAY2(NSAVE,1),ARAY3(NSAVE,1)
      DIMENSION ARAY4(NSAVE,1),ARAY5(NSAVE,1),ARAY6(NSAVE,1)
      DIMENSION ARAY7(NSAVE,1),ARAY8(NSAVE,1),ARAY9(NSAVE,1)
      DIMENSION ARAY10(NSAVE,1)
C NUSEAR IS NUMBER OF POSITIONS USED IN EACH ARRAY
CC AV      DIMENSION NUSEAR(10)
C IDEFIN(I)=1 IF CSAVE CALLED WITH ISLOT=I
CC AV      DIMENSION IDEFIN(30)
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/crsort'
C
ccAV      COMMON  /CRSORT/ NUSEAR,IDEFIN,MSAVE,MC
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_top/RCS/csrset.f,v $
     . $',                                                             '
     .$Id: csrset.f,v 1.3 2002/02/11 20:26:05 dws Exp $
     . $' /
C    ===================================================================
C
C
ccAV      DATA NUSEAR/10*0/
ccAV      DATA IDEFIN/30*0/
C VALUES OF MSAVE AND MC SET ON CALL TO CSRSET TO NSAVE AND NC
ccAV      DATA MSAVE/-1/,MC/-1/
C
C  DEBUG FLAG = 'CGDF'
C
      DATA BUGOPT/4HCGDF/
C
C  STATEMENT FUNCTION COMPUTES MAX SIZE C ARRAY FOR N SAVE DATES
C
      MAXC(N)=LARAY1/N + LARAY2/N + LARAY3/N + LARAY4/N + LARAY5/N +
     .        LARAY6/N + LARAY7/N + LARAY8/N + LARAY9/N + LARA10/N
C
C  TRACE LEVEL = 2
C
      IF(ITRACE.GE.2)WRITE(IODBUG,900)
 900  FORMAT(19H0*** CSRSET ENTERED)
      DO 10 I=1,10
 10   NUSEAR(I)=0
      DO 20 I=1,30
 20   IDEFIN(I)=0
      IER=0
      IF(IFBUG(BUGOPT).EQ.0)GO TO 30
      WRITE(IODBUG,800)NC,NSAVE,LARAY1,LARAY2,LARAY3,LARAY4,
     .  LARAY5,LARAY6,LARAY7,LARAY8,LARAY9,LARA10
 800  FORMAT(45H --IN CSRSET, NC,NSAVE,LENGTHS OF TEN ARRAY =,2I6,/,
     .  1H ,10(1X,I7))
 30   IF(NSAVE.GT.0.AND.NSAVE.LE.30.AND.NC.GT.0)GO TO 40
      WRITE(IPR,901)NC,NSAVE
 901  FORMAT('0**ERROR** IN CSRSET, ILLEGAL VALUE OF NC(',I7,
     .  11H) OR NSAVE(,I7,1H))
      MSAVE=-1
      MC=-1
      IER=1
      CALL ERROR
      RETURN
 40   MSAVE=NSAVE
      MC=NC
      NARAYS=0
      NUSET=0
      DO 100 I=1,10
      NARAYS=NARAYS+1
      GO TO (51,52,53,54,55,56,57,58,59,60),I
 51   J=LARAY1/NSAVE
      GO TO 70
 52   J=LARAY2/NSAVE
      GO TO 70
 53   J=LARAY3/NSAVE
      GO TO 70
 54   J=LARAY4/NSAVE
      GO TO 70
 55   J=LARAY5/NSAVE
      GO TO 70
 56   J=LARAY6/NSAVE
      GO TO 70
 57   J=LARAY7/NSAVE
      GO TO 70
 58   J=LARAY8/NSAVE
      GO TO 70
 59   J=LARAY9/NSAVE
      GO TO 70
 60   J=LARA10/NSAVE
      GO TO 70
 70   NUSEAR(I)=J
      NUSET=NUSET+J
      IF(NUSET.LT.NC)GO TO 100
      NUSEAR(I)=NC-(NUSET-J)
      NUSET=NC
      GO TO 150
 100  CONTINUE
C
C  NOT ENOUGH ROOM TO SAVE NSAVE C ARRAYS EACH NC LONG
C
      J=MAXC(NSAVE)
      WRITE(IPR,902)NSAVE,NC,J
 902  FORMAT('0**ERROR** IN CSRSET, UNABLE TO HOLD ',I3,
     .  44H DATES OF CARRYOVER IN CORE WHEN C ARRAY IS ,I6,
     .  6H LONG.,/,31H MAX LENGTH OF C ARRAY WOULD BE,I7,/,
     .  55H TABLE OF DATES SAVED AND MAX LENGTH OF C ARRAY FOLLOWS,/,
     .  16H NSAVE        NC)
 903  FORMAT(1H ,I5,I10)
      DO 110 I=1,NSAVE
      J=MAXC(I)
      WRITE(IPR,903)I,J
 110  CONTINUE
      IER=1
      CALL ERROR
      MSAVE=-1
      MC=-1
      RETURN
 150  IF(IFBUG(BUGOPT).EQ.1)WRITE(IODBUG,801)NARAYS,(NUSEAR(I),I=1,NARAY
     .S)
 801  FORMAT(21H --IN CSRSET, NARAYS=,I3,15H USED IN EACH =,10I5)
      IER=0
      RETURN
      END
