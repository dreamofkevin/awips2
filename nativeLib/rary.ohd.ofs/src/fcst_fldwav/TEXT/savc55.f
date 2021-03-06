C DESC -- THIS SUBROUTINE STORES THE CARRYOVER DATA AT THE APPROPIATE TIME
C
      SUBROUTINE SAVC55(PO,CCO,ICCO,QL,LTQL,POLH,LTPOLH,ITWT,LTITWT,T1,
     . LTT1,YD,QD,NB,KRCH,DDX,NQL,LQ1,LQN,NUMLAD,LAD,CHCTW,
     . K1,K2,K10,K16)
C
C           THIS SUBROUTINE WAS WRITTEN  BY:
C           JANICE LEWIS      HRL   MARCH, 1999
C
C
      INCLUDE 'common/fdbug'
      COMMON/M155/NU,JN,JJ,KIT,G,DT,TT,TIMF,F1
C
      DIMENSION PO(*),CCO(*),ICCO(*),QL(*),LTQL(*),POLH(*),LTPOLH(*)
      DIMENSION ITWT(*),LTITWT(*),T1(*),LTT1(*),YD(K2,K1),QD(K2,K1)
      DIMENSION DDX(K2,K1),NUMLAD(K1),LAD(K16,K1),CHCTW(K16,K1),NQL(K1)
      DIMENSION NB(K1),KRCH(K2,K1),LQN(K10,K1),LQ1(K10,K1)
      CHARACTER*8 SNAME
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_fldwav/RCS/savc55.f,v $
     . $',                                                             '
     .$Id: savc55.f,v 1.5 2004/02/02 21:53:55 jgofus Exp $
     . $' /
C    ===================================================================
C
C
C
      DATA SNAME/'SAVC55  '/
C
      CALL FPRBUG(SNAME,1,55,IBUG)
C
      IYDI=PO(316)-1
      IQDI=PO(317)-1
      IQLI=PO(318)-1
      IPLTI=PO(319)-1
      IIWTI=PO(364)-1
      NLOCK=PO(321)
      LOCK=0
C
      LCK=0
      LLD=1
      DO 1724 J=1,JN
C
C          SAVE WSEL'S AND DISCHARGES
C
      N=NB(J)
C      WRITE(6,1)
C    1 FORMAT(2X,'***********  IN SAVC55 AFTER INITIALIZATION *********')
      LIJ=LCAT21(1,J,NB)-1
C      WRITE(6,2) IYDI,N,LIJ
C    2 FORMAT(3X,'IYDI=',I5,3X,'N=',I5,3X,'LIJ=',I10)
      DO 1722 I=1,N
      CCO(IYDI+I)=YD(I,J)
      CCO(IQDI+I)=QD(I,J)
 1722 CONTINUE
C      WRITE(6,9999) (CCO(IYDI+I),I=1,N)
C 9999 FORMAT(2X,'COYDI=',10F10.2)
C      WRITE(6,9998) (CCO(IQDI+I),I=1,N)
C 9998 FORMAT(2X,'COQDI=',10F10.2)
      IYDI=IYDI+K2
      IQDI=IQDI+K2
C
C          SAVE LATERAL INFLOWS
C
      LT1=LTT1(J)-1
      CALL INTERP55(T1(1+LT1),NU,TT,IT1,IT2,TINP)
      IF(NQL(J).EQ.0) GO TO 1730
      N=NQL(J)
      LQL=LCAT21(1,J,NQL)-1
C      WRITE(6,4) IQLI,N,LQL
C    4 FORMAT(3X,'IQLI=',I5,3X,'N=',I5,3X,'LQL=',I10)
      DO 1728 I=1,N
      LOQ=LTQL(I+LQL)-1
      DX=0.
      L1=LQ1(I,J)
      LN=LQN(I,J)-1
      DO 1388 K=L1,LN
      DX=DX+DDX(K,J)
 1388 CONTINUE
C      WRITE(6,6) L,LOQ,IT1,IT2,TINP,DDX(L,J),QL(IT1+LOQ),QL(IT2+LOQ)
C    6 FORMAT(4X,'L  LOQ  IT1  IT2      TINP       DDX       QL1       QL
C     .2='/4I5,2F10.2,2F10.4)
      CCO(IQLI+I)=(QL(IT1+LOQ)+TINP*(QL(IT2+LOQ)-QL(IT1+LOQ)))*DX
 1728 CONTINUE
C      WRITE(6,9997) (CCO(IQLI+I),I=1,N)
C 9997 FORMAT(2X,'COQLI=',10F10.2)
      IQLI=IQLI+N
C
C          SAVE TARGET POOL ELEVATIONS AND GATE CONTROL SWITCHES
C
 1730 IF(NLOCK.EQ.0) GO TO 1724
      IF(NUMLAD(J).EQ.0) GO TO 1724
      N=NUMLAD(J)
      NLD=LCAT21(1,J,NUMLAD)-1
      I1=LOCK+1
C      I1=LOCK+1
      DO 1736 I=1,N
      LD=LAD(I,J)
      IF(KRCH(LD,J).EQ.28)  THEN
       LOCK=LOCK+1
       LON=LTPOLH(LOCK)-1
       LOT=LTITWT(LOCK)-1
       CCO(IPLTI+LOCK)=POLH(IT2+LON)+TINP*(POLH(IT1+LON)-POLH(IT2+LON))
       ICCO(IIWTI+LOCK)=ITWT(IT2+LOT)+TINP*(ITWT(IT1+LOT)-ITWT(IT2+LOT))
      ENDIF
 1736 CONTINUE
cc      WRITE(6,9995) (CCO(IPLTI+I),I=1,N)
cc 9995 FORMAT(2X,'COPLTI=',10F10.2)
cc      WRITE(6,9994) (ICCO(IIWTI+I),I=I1,LOCK)
cc 9994 FORMAT(2X,'COIWTI=',10I10)
C      IPLTI=IPLTI+LOCK
C      IIWTI=IIWTI+LOCK
C     WRITE(6,4) IQLI,N,LQL
 1724 CONTINUE
      RETURN
      END












