C MODULE SNMAP
C-----------------------------------------------------------------------
C
C  ROUTINE TO PERFORMING NETWORK COMPUTATIONS FOR MAP AREAS.
C
      SUBROUTINE SNMAP (IRTYPE,IALL,IBMDR,IOPTN,OPTN,LARRAY,ARRAY,
     *   NNWFLG,INWFLG,STMNWT,IBASN,ITSHDR,IUEND,ISTAT)
C
      CHARACTER*4 OPTN,PLOT,UNITS,WDISP,XTYPE
      CHARACTER*8 TYPERR
      REAL BLNK/4H    /
C
      DIMENSION ARRAY(LARRAY),INWFLG(NNWFLG)
      DIMENSION UNUSED(5)
C
C  STAN ARRAYS
      DIMENSION STAID(2),STACOR(2)
C
C  MAP PARAMETER ARRAYS
      DIMENSION PID(2),DESC(5),BASNID(2),FPID(2),CENTRD(2),CORMDR(8)
      DIMENSION ITECHS(5)
C
C  BASN PARAMETER ARRAYS
      DIMENSION BPID(2),BTID(2),BPXID(2)
      DIMENSION BDESC(5),BCNTRD(2),FLTLN(2)
C
C  TIME SERIES VARIABLES
      CHARACTER*4 TSUNIT
      CHARACTER*8 TSFID
      CHARACTER*20 TSDESC
      PARAMETER (LWKBUF=500)
      DIMENSION IWKBUF(LWKBUF)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/suoptx'
      INCLUDE 'scommon/sutmrx'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'pppcommon/ppdtdr'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_network/RCS/snmap.f,v $
     . $',                                                             '
     .$Id: snmap.f,v 1.2 1998/04/07 17:58:10 page Exp $
     . $' /
C    ===================================================================
C
C
C
C  SET TRACE LEVEL
      CALL SBLTRC ('NTWK','NTWKMAP ','SNMAP   ',LTRACE)
C
      IF (LTRACE.GT.0) THEN
         WRITE (IOSDBG,500)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      CALL SBLDBG ('NTWK','NTWKMAP ','SNMAP   ',LDEBUG)
C
C  CHECK IF CPU TIMER DEBUG OPTION SPECIFIED
      LTIMR=ISBUG('TIMR')
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,510) IRTYPE,IALL,IBMDR,IOPTN,
     *      OPTN,LARRAY,STMNWT,IBASN,ITSHDR
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      ISTAT=0
C      
      NUMERR=0
      NMOVED=0
C
C  SET INDICATOR TO UPDATE PARAMETERS EVEN IF PREDETERMINED WEIGHTS USED
      INDPRE=1
C
C  PRINT HEADING
      WRITE (LP,520)
      CALL SULINE (LP,2)
      IF (INWFLG(6).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 10
         WRITE (LP,580)
         CALL SULINE (LP,2)
10    IF (INWFLG(7).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 20
         WRITE (LP,590)
         CALL SULINE (LP,2)
20    IF (INWFLG(9).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 30
         WRITE (LP,600)
         CALL SULINE (LP,2)
30    WRITE (LP,610) STMNWT
      CALL SULINE (LP,2)
      IF (INDPRE.EQ.1) THEN
         WRITE (LP,620)
         CALL SULINE (LP,2)
         ENDIF
      IF (ITSHDR.EQ.1) THEN
         WRITE (LP,630)
         CALL SULINE (LP,2)
         ENDIF
C
      NAREA=0
      NSEGS=0
C
C  INITIALIZE POINTERS
      IDIV=25
      IDIM=LSWORK/IDIV
C  TIMING WT ID'S
      ID1=1
C  TIMING WTS
      ID2=IDIM*2+1
C  TIMING STATION POINTERS
      ID3=IDIM*3+1
C  TIMING STATION NWSRFS/HRAP COORDINATES
      ID4=IDIM*4+1
C  STATION WT ID'S
      ID5=IDIM*6+1
C  STATION WTS
      ID6=IDIM*8+1
C  STATION POINTERS
      ID7=IDIM*9+1
C  STATION NWSRFS/HRAP COORDINATES
      ID8=IDIM*10+1
C  MDR BOXES
      ID9=IDIM*12+1
C  X
      ID10=IDIM*13+1
C  Y
      ID11=IDIM*14+1
C  IY
      ID12=IDIM*15+1
C  IXB
      ID13=IDIM*16+1
C  IXE
      ID14=IDIM*17+1
C  LATITUDES
      ID15=IDIM*18+1
C  LONGITUDES
      ID16=IDIM*19+1
C  JX
      ID17=IDIM*20+1
C  JY
      ID18=IDIM*21+1
C  JN
      ID19=IDIM*22+1
C
      MBPTS=IDIM
      MSEGS=IDIM
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*) 'IN SNMAP -',
     *      ' LSWORK=',LSWORK,
     *      ' IDIV=',IDIV,
     *      ' MBPTS=',MBPTS,
     *      ' MSEGS=',MSEGS,
     *      ' '
         CALL SULINE (IOSDBG,1)
         ENDIF   
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GET RECORD NUMBER FOR LAST RECORD OF THIS TYPE
      XTYPE=' '
      IF (IBASN.EQ.0) XTYPE='MAP'
      IF (IBASN.EQ.1) XTYPE='BASN'
      IDXDAT=IPCKDT(XTYPE)
      IF (IDXDAT.GT.0) GO TO 40
         WRITE (LP,540) XTYPE
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
40    LSTREC=IPDTDR(4,IDXDAT)
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) IDXDAT,LSTREC
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      IPTR1=0
      IPTRN1=0
      IPTR3=0
      IPTRN3=0
      IPRNT=1
      UNITS='ENGL'
      IF (LTIMR.GT.0) CALL SUTIMR (LP,ITMELA,ITMTOT)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF SUFFICIENT CPU TIME AVAILABLE
50    ICKRGN=0
      ICKCPU=1
      MINCPU=10
      IPRERR=1
      IPUNIT=LP
      TYPERR='ERROR'
      INCLUDE 'clugtres'
      IF (IERR.GT.0) THEN
         CALL SUFATL
         IUEND=1
         GO TO 495
         ENDIF
C
C  CHECK IF ONLY THOSE MAP AREAS WITH CHANGED BASIN BOUNDARIES ARE TO
C  BE PROCESSED
      IF (IBASN.EQ.0) GO TO 80
C
C  READ BASIN BOUNDARY PARAMETERS
      CALL UREPET (' ',BASNID,8)
      IPRERR=0
      CALL SRBASN (ARRAY,LARRAY,IBVERS,BASNID,BDESC,SWORK(ID15),
     *   SWORK(ID16),IDIM,NBPTS,AREA,CAREA,ELEV,BCNTRD(1),BCNTRD(2),
     *   MAPFLG,MATFLG,BPID,BTID,BPXID,
     *   IDIM,NSEGS,SWORK(ID12),SWORK(ID13),SWORK(ID14),LFACTR,
     *   IPTR3,IPTRN3,IPRERR,IERR)
      IF (IERR.EQ.2.AND.NAREA.EQ.0) GO TO 480
      IF (IERR.EQ.6) GO TO 480
      IF (IERR.EQ.0) GO TO 70
         CALL SRPPST (BASNID,'BASN',IPTR3,LARRAY,0,IPTRN3,IERR)
         WRITE (LP,690) 'BASN',BASNID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
C
70    IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,560) BASNID,BPID,MAPFLG,IPTR3,IPTRN3
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SAVE RECORD NUMBER OF THIS PARAMETERS RECORD
      NPTR=IPTR3
C
C  CHECK IF MAP AREA USES THIS BASIN BOUNDARY
      IF (BPID(1).EQ.BLNK.AND.BPID(2).EQ.BLNK) GO TO 460
C
C  CHECK IF MAP AREA PARAMETERS NEED TO BE UPDATED
      IF (MAPFLG.EQ.1) GO TO 460
      CALL SUBSTR (BPID,1,8,PID,1)
      GO TO 90
C
C  READ MAP AREA PARAMETERS
80    CALL UREPET (' ',PID,8)
90    IPRERR=0
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,570) PID,IPTR1
         CALL SULINE (IOSDBG,1)
         ENDIF
      CALL SRMAP (IVER,PID,IDT,ITMWT,POWER,IDIM,NSTWT,ISTWT,IDIM,NPCPN,
     *   NSETS,DESC,BASNID,FPID,CENTRD,SWORK(ID1),SWORK(ID2),SWORK(ID4),
     *   SWORK(ID5),SWORK(ID6),SWORK(ID8),UNUSED,LARRAY,ARRAY,IPTR1,
     *   IPRERR,IPTRN1,IERR)
      IF (IERR.EQ.2.AND.NAREA.EQ.0) GO TO 480
      IF (IERR.EQ.6) GO TO 480
      IF (IERR.EQ.0) GO TO 100
         CALL SRPPST (PID,'MAP ',IPTR1,LARRAY,0,IPTRN1,IERR)
         WRITE (LP,690) 'MAP',PID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
100   IPTR2=0
      CALL SRMAPS (IVER,PID,CENTRD,RADINF,IPMAP,NTECH,IBSNID,IDIM,NSTWT,
     *   IDIM,NPCPN,IDIM,NBOX,ITECHS,SWORK(ID3),SWORK(ID7),SWORK(ID9),
     *   CORMDR,UNUSED,LARRAY,ARRAY,IPTR2,IPRERR,IPTRN2,IERR)
      IF (IERR.EQ.0) GO TO 110
         CALL SRPPST (PID,'MAPS',IPTR2,LARRAY,0,IPTRN2,IERR)
         WRITE (LP,690) 'MAPS',PID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
C
C  SAVE RECORD NUMBER OF MAPS PARAMETERS
110   IPMAPS=IPTR2
C
C  SAVE RECORD NUMBER OF THIS PARAMETERS RECORD
      IF (IBASN.EQ.0) NPTR=IPTR1
C
      IF (IBASN.EQ.1) GO TO 120
C
C  CHECK IF BASIN BOUNDARY USED
      IF (IBSNID.EQ.0) GO TO 120
      IPTR3=0
      CALL SRBASN (ARRAY,LARRAY,IBVERS,BASNID,BDESC,SWORK(ID15),
     *   SWORK(ID16),IDIM,NBPTS,AREA,CAREA,ELEV,BCNTRD(1),BCNTRD(2),
     *   MAPFLG,MATFLG,BPID,BTID,BPXID,
     *   IDIM,NSEGS,SWORK(ID12),SWORK(ID13),SWORK(ID14),LFACTR,
     *   IPTR3,IPTRN3,IPRERR,IERR)
      IF (IERR.EQ.0) GO TO 120
         CALL SRPPST (BASNID,'BASN',IPTR3,LARRAY,0,IPTRN3,IERR)
         WRITE (LP,690) 'BASN',BASNID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
C
120   IF (IOPMLV.GT.1) THEN
         WRITE (LP,520)
         CALL SULINE (LP,1)
         ENDIF
C
C  CHECK IF PREDETERMINED WEIGHTS BEING USED
      IF (ITMWT.NE.1.OR.ISTWT.NE.1) GO TO 130
         IF (IOPMLV.LE.1) GO TO 125
            WRITE (LP,730) PID
            CALL SULINE (LP,2)
125      IF (INDPRE.EQ.1) GO TO 130
         IF (ITSHDR.EQ.1) GO TO 130
         GO TO 460
C
C  PRINT PARAMETERS
130   IF (LDEBUG.LT.2) GO TO 140
      PLOT='NO'
      CALL SPMAP (IPRNT,IVER,IVER,PID,IDT,ITMWT,POWER,NSTWT,ISTWT,NPCPN,
     *   NSETS,DESC,BASNID,FPID,CENTRD,SWORK(ID1),SWORK(ID2),SWORK(ID4),
     *   SWORK(ID5),SWORK(ID6),SWORK(ID8),RADINF,IPMAP,NTECH,IBSNID,
     *   NBOX,ITECHS,SWORK(ID3),SWORK(ID7),SWORK(ID9),CORMDR,UNUSED,
     *   SWORK(ID12),SWORK(ID13),SWORK(ID14),NSEGS,SWORK(ID10),
     *   SWORK(ID11),SWORK(ID17),SWORK(ID18),NBPTS,LFACTR,PLOT,
     *   LARRAY,ARRAY,UNITS,AREA,CAREA,SWORK(ID19),IERR)
C
      IF (IBSNID.EQ.0) GO TO 140
      IF (ISTWT.NE.2.AND.ISTWT.NE.3) GO TO 140
      IPLOT=0
      IF (IOPPLT.EQ.1) IPLOT=1
      CALL SPBASN (BASNID,BDESC,SWORK(ID15),
     *   SWORK(ID16),NBPTS,AREA,ELEV,CAREA,SWORK(ID12),SWORK(ID13),
     *   SWORK(ID14),NSEGS,BCNTRD(1),BCNTRD(2),
     *   MAPFLG,MATFLG,BPID,BTID,BPXID,UNITS,LFACTR,
     *   SWORK(ID10),SWORK(ID11),SWORK(ID17),SWORK(ID18),IBVERS,IPLOT,
     *   SWORK(ID19),IERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
140   IUBASN=0
      IF (IBASN.EQ.1) GO TO 170
C
C  CHECK IF BASIN BOUNDARIES USED
      IF (IBSNID.EQ.0) GO TO 160
C
C  CHECK IF TIMING AND STATION WEIGHTS NEED TO BE UPDATED
      IF (INWFLG(6).GT.0.OR.INWFLG(7).GT.0) GO TO 160
C
C  CHECK IF FORCED RUN
      IF (IOPTN.GT.0.AND.
     *   (OPTN.EQ.'ALL'.OR.OPTN.EQ.'MAP'.OR.OPTN.EQ.'BASN')) GO TO 160
C
C  CHECK IF PARAMETERS NEED TO BE UPDATED DUE TO BASIN BOUNDARY CHANGE
      IF (INWFLG(9).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 160
C
C  CHECK IF PARAMETERS UPDATED SINCE BASIN DEFINED OR REDEFINED
      IF (MAPFLG.EQ.0) GO TO 150
         WRITE (LP,760) PID
         CALL SULINE (LP,1)
         GO TO 460
C
150   IUBASN=1
C
C  CHECK IF TIMING WEIGHTS NEED TO BE UPDATED
160   IF (IUBASN.EQ.1) GO TO 170
      IF (INWFLG(6).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 230
C
170   IF (LTIMR.GT.0) THEN
         WRITE (LP,700)
         CALL SULINE (LP,2)
         CALL SUTIMR (LP,ITMELA,ITMTOT)
         ENDIF
C
C  CHECK IF PREDETERMINED WEIGHTS BEING USED
      IF (ITMWT.NE.1) GO TO 200
      IF (IOPMLV.GT.1) THEN
         IF (INDPRE.EQ.1.AND.ISTWT.NE.1) THEN
            WRITE (LP,740) PID
            CALL SULINE (LP,1)
            ENDIF
         ENDIF
C
C  UPDATE PPVR POINTERS FOR PREDETERMINED STATION WEIGHTS
      DO 190 I=1,NSTWT
         IPOS=ID1+I*2-2
         CALL SUBSTR (SWORK(IPOS),1,8,STAID,1)
         CALL SFSCHK (LARRAY,ARRAY,STAID,'PCPN',STACOR,IPPP24,IPPPVR,
     *      IPEA24,IPTM24,NUMERR,IERR)
         IPOS=ID3+I-1
         CALL SFCONV (SWORK(IPOS),IPPPVR,1)
190      CONTINUE
         GO TO 210
C
C  UPDATE TIMING WEIGHTS
200   IPARM=1
      ITYPE=ITMWT
      IF (ITMWT.EQ.2) ITYPE=4
      CALL SFWGHT (IRTYPE,PID,IPARM,ITYPE,NSEGS,LFACTR,SWORK(ID12),
     *   SWORK(ID13),SWORK(ID14),IDIM,CENTRD(1),CENTRD(2),POWER,STMNWT,
     *   NSTWT,SWORK(ID1),SWORK(ID2),SWORK(ID3),SWORK(ID4),IERR)
      IF (IERR.GT.0) GO TO 460
C
210   IF (LDEBUG.LT.2) GO TO 230
         WRITE (IOSDBG,770)
         CALL SULINE (IOSDBG,2)
         WRITE (IOSDBG,780)
         CALL SULINE (IOSDBG,2)
         DO 220 I=1,NSTWT
            IPOS=ID3+I-1
            CALL SFCONV (IVALUE,SWORK(IPOS),1)
            WRITE (IOSDBG,810) (SWORK(ID1+I*2-3+J),J=1,2),
     *         SWORK(ID2+I-1),IVALUE
            CALL SULINE (IOSDBG,1)
220         CONTINUE
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF STATION WEIGHTS NEED TO BE UPDATED
230   IF (IBASN.EQ.1) GO TO 240
      IF (IUBASN.EQ.1) GO TO 240
      IF (INWFLG(7).EQ.0.AND.IALL.EQ.-1.AND.IOPTN.EQ.0) GO TO 300
C
240   IF (LTIMR.EQ.0) GO TO 250
         WRITE (LP,710)
         CALL SULINE (LP,2)
         CALL SUTIMR (LP,ITMELA,ITMTOT)
C
C  CHECK IF PREDETERMINED WEIGHTS BEING USED
250   IF (ISTWT.NE.1) GO TO 270
      IF (IOPMLV.GT.1) THEN
         IF (INDPRE.EQ.1.AND.ITMWT.NE.1) THEN
            WRITE (LP,750) PID
            CALL SULINE (LP,1)
            ENDIF
         ENDIF
C
C  UPDATE PREDETERMINED STATION STATION WEIGHTS
      DO 260 I=1,NPCPN
         IPOS=ID5+I*2-2
         CALL SUBSTR (SWORK(IPOS),1,8,STAID,1)
         CALL SFSCHK (LARRAY,ARRAY,STAID,'PCPN',STACOR,IPPP24,IPPPVR,
     *      IPEA24,IPTM24,NUMERR,IERR)
         IPOS=ID7+I-1
         CALL SFCONV (SWORK(IPOS),IPPP24,1)
260      CONTINUE
         GO TO 280
C
C  UPDATE STATION WEIGHTS
270   IPARM=2
      ITYPE=ISTWT-1
      CALL SFWGHT (IRTYPE,PID,IPARM,ITYPE,NSEGS,LFACTR,SWORK(ID12),
     *   SWORK(ID13),SWORK(ID14),IDIM,CENTRD(1),CENTRD(2),POWER,STMNWT,
     *   NPCPN,SWORK(ID5),SWORK(ID6),SWORK(ID7),SWORK(ID8),IERR)
      IF (IERR.GT.0) GO TO 460
C
280   IF (LDEBUG.LT.2) GO TO 300
         WRITE (IOSDBG,790)
         CALL SULINE (IOSDBG,2)
         WRITE (IOSDBG,800)
         CALL SULINE (IOSDBG,2)
         DO 290 I=1,NPCPN
            IPOS=ID7+I-1
            CALL SFCONV (IVALUE,SWORK(IPOS),1)
            WRITE (IOSDBG,810) (SWORK(ID5+I*2-3+J),J=1,2),
     *         SWORK(ID6+I-1),IVALUE
            CALL SULINE (IOSDBG,1)
290         CONTINUE
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF MDR BOXES TO BE RECOMPUTED
300   IF (IBMDR.EQ.0) GO TO 310
         IF (IBSNID.EQ.0) GO TO 310
         IF (NBOX.EQ.0) GO TO 310
         ILLGD=1
         CALL SBLLGD (SWORK(ID16),SWORK(ID15),NBPTS,SWORK(ID10),
     *      SWORK(ID11),ILLGD,IERR)
         CALL SBMDRV (SWORK(ID10),SWORK(ID11),NBPTS,SWORK(ID9),IDIM,
     *      NBOX,SWORK(ID12),SWORK(ID13),SWORK(ID14),NSEGS,LFACTR,IERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
310   IF (LTIMR.EQ.0) GO TO 320
         WRITE (LP,720)
         CALL SULINE (LP,2)
         CALL SUTIMR (LP,ITMELA,ITMTOT)
C
C  CHECK IF MAP AREA CENTROID NEEDS TO BE UPDATED IN TIME SERIES HEADER
320   ICNTRD=0
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,640) ITSHDR,IBSNID
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (ITSHDR.EQ.1) GO TO 330
C
C  CHECK IF MAP AREA CENTROID NEEDS TO BE UPDATED DUE TO BASIN BOUNDARY
C  CHANGE
      IF (INWFLG(9).EQ.0) GO TO 370
C
C  CHECK IF MAP AREA HAS BASIN BOUNDARY
330   IF (IBSNID.EQ.1) GO TO 340
         IF (ITSHDR.EQ.1) GO TO 360
         GO TO 420
C
C  CHECK IF CENTRIOD HAS CHANGED
340   IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,650) BCNTRD
         CALL SULINE (IOSDBG,1)
         WRITE (IOSDBG,660) CENTRD
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (ITSHDR.EQ.1) GO TO 350
      IF (CENTRD(1).EQ.BCNTRD(1).AND.CENTRD(2).EQ.BCNTRD(2)) GO TO 370
350   CENTRD(1)=BCNTRD(1)
      CENTRD(2)=BCNTRD(2)
360   ICNTRD=1
C
C  UPDATE MAP PARAMETERS
370   WDISP='OLD'
      NSPACE=0
      CALL SWMAP (IVER,PID,IDT,ITMWT,POWER,NSTWT,ISTWT,NPCPN,NSETS,
     *   DESC,BASNID,FPID,CENTRD,SWORK(ID1),SWORK(ID2),SWORK(ID4),
     *   SWORK(ID5),SWORK(ID6),SWORK(ID8),
     *   UNUSED,LARRAY,ARRAY,IPTR1,WDISP,NSPACE,IERR)
      IPMAP=IPTR1
      CALL SWMAPS (IVER,PID,CENTRD,RADINF,IPMAP,NTECH,IBSNID,NSTWT,
     *   NPCPN,NBOX,ITECHS,SWORK(ID3),SWORK(ID7),SWORK(ID9),CORMDR,
     *   UNUSED,LARRAY,ARRAY,IPTR2,WDISP,NSPACE,IERR2)
      IF (IERR.GT.0.OR.IERR2.GT.0) GO TO 470
C
C  CHECK IF MAPS PARAMETER RECORD MOVED
      IF (IPTR2.NE.IPMAPS) NMOVED=NMOVED+1
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,670) IPTR2,IPMAPS,NMOVED
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  CHECK IF BASIN BOUNDARY IDENTIFIER USED
      IF (IBSNID.EQ.1) GO TO 380
         IF (ITSHDR.EQ.1) GO TO 400
         GO TO 420
C
C  CHECK IF BASIN BOUNDARY CHANGED SINCE AREA DEFINITION LAST UPDATED
380   IF (MAPFLG.EQ.0) GO TO 390
         IF (ITSHDR.EQ.1) GO TO 400
         GO TO 420
C
C  SET MAP UPDATE INDICATOR
390   MAPFLG=1
      CALL SWBASN (ARRAY,LARRAY,IBVER,BASNID,BDESC,SWORK(ID15),
     *   SWORK(ID16),NBPTS,AREA,CAREA,ELEV,BCNTRD(1),BCNTRD(2),
     *   MAPFLG,MATFLG,BPID,BTID,BPXID,
     *   NSEGS,SWORK(ID12),SWORK(ID13),SWORK(ID14),LFACTR,
     *   WDISP,NSPACE,IERR)
      IF (IERR.GT.0) GO TO 460
C
C  CHECK IF TIME SERIES HEADER TO BE UPDATED
400   IF (ICNTRD.EQ.0) GO TO 420
C
C  UPDATE TIME SERIES HEADER
      NPAIR=1
      ILLGD=0
      CALL SBLLGD (FLTLN(2),FLTLN(1),NPAIR,CENTRD(1),CENTRD(2),ILLGD,
     *   IERR)
      CALL SUDOPN (1,'PRD ',IERR)
      TSUNIT=' '
      TSDESC=' '
      TSFID=' '
      NXBUF=0
      CALL WPRDC (PID,'MAP ',TSUNIT,FLTLN,TSDESC,TSFID,NXBUF,XBUF,
     *   LWKBUF,IWKBUF,IREC,IERR)
      IF (IERR.GT.0) THEN
         IF (IERR.NE.8) THEN
            CALL SWPRST ('WPRDC   ',PID,'MAP',0,TSUNIT,TSFID,LWKBUF,
     *         NXBUF,IERR)
            GO TO 460
            ENDIF
         ENDIF
C
C  CHECK MESSAGES LEVEL VALUE
      IF (IOPMLV.GT.1) THEN
         WRITE (LP,680) PID
         CALL SULINE (LP,1)
         ENDIF
C
      CALL SUDWRT (1,'PRD ',IERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
420   IF (LDEBUG.LT.2) GO TO 450
C
C  READ MAP AREA PARAMETERS
      IPTR1=0
      IPRERR=1
      CALL SRMAP (IVER,PID,IDT,ITMWT,POWER,IDIM,NSTWT,ISTWT,IDIM,NPCPN,
     *   NSETS,DESC,BASNID,FPID,CENTRD,SWORK(ID1),SWORK(ID2),SWORK(ID4),
     *   SWORK(ID5),SWORK(ID6),SWORK(ID8),UNUSED,LARRAY,ARRAY,IPTR1,
     *   IPRERR,IPTRN1,IERR)
      IF (IERR.EQ.0) GO TO 430
         CALL SRPPST (PID,'MAP ',IPTR1,LARRAY,0,IPTRN1,IERR)
         WRITE (LP,690) 'MAP',PID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
430   IPTR2=0
      CALL SRMAPS (IVER,PID,CENTRD,RADINF,IPMAP,NTECH,IBSNID,IDIM,NSTWT,
     *   IDIM,NPCPN,IDIM,NBOX,ITECHS,SWORK(ID3),SWORK(ID7),SWORK(ID9),
     *   CORMDR,UNUSED,LARRAY,ARRAY,IPTR2,IPRERR,IPTRN2,IERR)
      IF (IERR.EQ.0) GO TO 440
         CALL SRPPST (PID,'MAPS',IPTR2,LARRAY,0,IPTRN2,IERR)
         WRITE (LP,690) 'MAPS',PID,IERR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 470
C
C  PRINT MAP AREA PARAMETERS
440   PLOT='NO'
      CALL SPMAP (IPRNT,IVER,IVER,PID,IDT,ITMWT,POWER,NSTWT,ISTWT,NPCPN,
     *   NSETS,DESC,BASNID,FPID,CENTRD,SWORK(ID1),SWORK(ID2),SWORK(ID4),
     *   SWORK(ID5),SWORK(ID6),SWORK(ID8),RADINF,IPMAP,NTECH,IBSNID,
     *   NBOX,ITECHS,SWORK(ID3),SWORK(ID7),SWORK(ID9),CORMDR,UNUSED,
     *   SWORK(ID12),SWORK(ID13),SWORK(ID14),NSEGS,SWORK(ID10),
     *   SWORK(ID11),SWORK(ID17),SWORK(ID18),NBPTS,LFACTR,PLOT,
     *   LARRAY,ARRAY,UNITS,AREA,CAREA,SWORK(ID19),IERR)
C
      IF (IBSNID.EQ.0) GO TO 450
      IF (ISTWT.NE.2.AND.ISTWT.NE.3) GO TO 450
C
C  READ BASN PARAMETERS
      IPTR3=0
      CALL SRBASN (ARRAY,LARRAY,IBVERS,BASNID,BDESC,SWORK(ID15),
     *   SWORK(ID16),IDIM,NBPTS,AREA,CAREA,ELEV,BCNTRD(1),BCNTRD(2),
     *   MAPFLG,MATFLG,BPID,BTID,BPXID,
     *   IDIM,NSEGS,SWORK(ID12),SWORK(ID13),SWORK(ID14),LFACTR,
     *   IPTR3,IPTRN3,IPRERR,IERR)
C
C  PRINT BASN PARAMETERS
      IF (IPLOT.EQ.1) THEN
         CALL SPBASN (BASNID,BDESC,SWORK(ID15),
     *      SWORK(ID16),NBPTS,AREA,ELEV,CAREA,SWORK(ID12),SWORK(ID13),
     *      SWORK(ID14),NSEGS,BCNTRD(1),BCNTRD(2),
     *      MAPFLG,MATFLG,BPID,BTID,BPXID,UNITS,LFACTR,
     *      SWORK(ID10),SWORK(ID11),SWORK(ID17),SWORK(ID18),IBVERS,
     *      IPLOT,SWORK(ID19),IERR)
         ENDIF
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
450   NAREA=NAREA+1
C
460   IF (LTIMR.GT.0) CALL SUTIMR (LP,ITMELA,ITMTOT)
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,820) NPTR,LSTREC
         CALL SULINE (IOSDBG,1)
         ENDIF
      IF (NPTR.GE.LSTREC) GO TO 480
         IPTR1=IPTRN1
         IPTR3=IPTRN3
         GO TO 50
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
470   ISTAT=1
C
C  CHECK IF ANY MAP PARAMETER RECORDS MOVED
480   IF (NMOVED.EQ.0) GO TO 490
         WRITE (LP,530)
         CALL SULINE (LP,2)
         WRITE (LP,830) NMOVED
         IF (IOPOVP.EQ.1) THEN
            WRITE (LP,830) NMOVED
            WRITE (LP,830) NMOVED
            ENDIF
         CALL SUWRNS (LP,0,-1)
C
490   WRITE (LP,840) NAREA
      CALL SULINE (LP,2)
C
495   IF (LTRACE.GT.0) THEN
         WRITE (IOSDBG,850) ISTAT
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
500   FORMAT (' *** ENTER SNMAP')
510   FORMAT (' IRTYPE=',I2,3X,'IALL=',I2,3X,'IBMDR=',I2,3X,
     *   'IOPTN=',I2,3X,'OPTN=',A4,3X,'LARRAY=',I5,3X,
     *   'STMNWT=',F7.3,3X,'IBASN=',I2,3X,'ITSHDR=',I2)
520   FORMAT (' ')
530   FORMAT ('0')
540   FORMAT ('0*** ERROR - PARAMETER TYPE ',A4,' NOT FOUND IN ',
     *   'THE PREPROCESSOR PARAMETRIC DATA BASE.')
550   FORMAT (' IDXDAT=',I3,3X,'LSTREC=',I5)
560   FORMAT (' BASNID=',2A4,3X,'BPID=',2A4,'MAPFLG=',I2,3X,
     *   'IPTR3=',I5,3X,'IPTRN3=',I5)
570   FORMAT (' PID=',2A4,3X,'IPTR1=',I5)
580   FORMAT ('0*--> FIND CLOSEST PCPN STATIONS FOR MAP AREAS ',
     *   'USING 1/D**2 OR 1/D**POWER TIMING WEIGHTS.')
590   FORMAT ('0*--> FIND CLOSEST PCPN STATIONS FOR MAP AREAS ',
     *   'USING GRID POINT, THIESSEN OR 1/D**POWER STATION WEIGHTS.')
600   FORMAT ('0*--> UPDATE MAP AREA PARAMETERS DUE TO BASIN BOUNDARY ',
     *   'CHANGE.')
610   FORMAT ('0*** NOTE - MINIMUM WEIGHT OF STATIONS TO BE KEPT WHEN ',
     *   'DOING STATION WEIGHTING IS ',F5.3,'.')
620   FORMAT ('0*** NOTE - PARAMETERS WILL BE UPDATED EVEN IF AREA ',
     *   'HAS PREDETERMINED WEIGHTS.')
630   FORMAT ('0*** NOTE - TIME SERIES HEADERS WILL BE UPDATED EVEN ',
     *   'IF BASIN BOUNDARY HAS NOT CHANGED.')
640   FORMAT (' ITSHDR=',I2,3X,'IBSNID=',I2)
650   FORMAT (' BCNTRD(1)=',F8.4,3X,'BCNTRD(2)=',F8.4)
660   FORMAT (' CENTRD(1)=',F8.4,3X,'CENTRD(2)=',F8.4)
670   FORMAT (' IPTR2=',I5,3X,'IPMAPS=',I5,3X,'NMOVED=',I4)
680   FORMAT (' *** NOTE - MAP  TIME SERIES HEADER SUCCESSFULLY ',
     *   'UPDATED FOR AREA ',2A4,'.')
690   FORMAT ('0*** ERROR - IN SNMAP - UNSUCCESSFUL CALL TO SR',A4,
     *   ' FOR IDENTIFIER ',2A4,'. STATUS CODE=',I2)
700   FORMAT ('0CPU TIME USED BEFORE UPDATING TIMING WEIGHTS')
710   FORMAT ('0CPU TIME USED BEFORE UPDATING STATION WEIGHTS')
720   FORMAT ('0CPU TIME USED BEFORE UPDATING PARAMETERS')
730   FORMAT (' *** NOTE - MAP  AREA ',2A4,' HAS PREDETERMINED TIMING ',
     *   'AND STATION WEIGHTS.')
740   FORMAT (' *** NOTE - MAP  AREA ',2A4,' HAS PREDETERMINED ',
     *   'TIMING WEIGHTS.')
750   FORMAT (' *** NOTE - MAP  AREA ',2A4,' HAS PREDETERMINED ',
     *   'STATION WEIGHTS.')
760   FORMAT (' *** NOTE - MAP  AREA ',2A4,' DOES NOT NEED TO HAVE ',
     *   'PARAMETERS UPDATED BECAUSE BASIN BOUNDARY HAS NOT CHANGED.')
770   FORMAT ('0CONTENTS OF NETWORK ARRAYS FOR CLOSEST PCPN ',
     *   'TIMING STATIONS')
780   FORMAT ('0',T5,'TSTAID  ',4X,'TSTAWT',5X,'IPPPVR')
790   FORMAT ('0CONTENTS OF NETWORK ARRAYS FOR CLOSEST PCPN ',
     *   'WEIGHTING STATIONS')
800   FORMAT ('0',T5,'CSTAID  ',4X,'TCTAWT',5X,'IPPP24')
810   FORMAT (T5,2A4,3X,G8.3,5X,I4)
820   FORMAT (' NPTR=',I5,3X,'LSTREC=',I5)
830   FORMAT ('+*** WARNING - ',I4,' MAPS AREA PARAMETER RECORDS ',
     *   'WERE MOVED. THE @ORDER COMMAND SHOULD BE RUN TO ',
     *   'MAINTAIN MAXIMUM EFFICIENCY.')
840   FORMAT ('0*** NOTE - ',I4,' AREAS WITH MAP PARAMETERS ',
     *   'SUCCESSFULLY PROCESSED.')
850   FORMAT (' *** EXIT SNMAP - ISTAT=',I2)
C
      END
