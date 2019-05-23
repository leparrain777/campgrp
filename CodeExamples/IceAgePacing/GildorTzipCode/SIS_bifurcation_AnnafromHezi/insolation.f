c subroutine for calculation of daily insolation. based on Berger 1978 
c but modified by Hezi/ Eli.

      subroutine insolation(time_kyr, month, day, latitude_degrees
     &     ,WW,TLS,ECC,PRE,PERH,XOB,DAYL)
C
C*******************************************                            
C   DAILY INSOLATION - LONG TERM VARIATION *                            
C*******************************************                            
C                                                                       
     
      IMPLICIT REAL*8(A-H,P-Z)                                          
      real*8 time_kyr, latitude_degrees
      integer month, day
      logical first_time
      data first_time/.true./
      save


c till the next XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX we have to do only once

      DIMENSION AE(19),BE(19),CE(19),AOB(47),BOB(47),COB(47),AOP(78),BOP
     *(78),COP(78)                                                      
C                                                                       
C                                                                       
C     THIS SOLUTION OF BERGER 1978 IS VALID ONLY FOR 1.000.000 YEARS    
C     CENTERED ON PRESENT-DAY.                                          
C     FOR LONGER PERIOD THE SOLUTION 1990 MUST BE USED.                 
C     (CONTACT BERGER FOR THIS 1990 SOLUTION)                           
C                                                                       
C                                                                       
C   PLEASE REFER TO :                                                   
C      BERGER A. 1978. A SIMPLE ALGORITHM TO COMPUTE LONG TERM          
C                      VARIATIONS OF DAILY OR MONTHLY INSOLATION        
C                      CONTR. 18  INST OF ASTRONOMY AND GEOPHYSICS      
C                      UNIVERSITE CATHOLIQUE DE LOUVAIN.                
C                      LOUVAIN-LA-NEUVE    BELGIUM.                     
C                                                                       
C      BERGER A. 1978. LONG TERM VARIATIONS OF DAILY INSOLATION AND     
C                      QUATERNARY CLIMATIC CHANGES                      
C                      J. OF ATMOSPHERIC SCIENCES  35  2362-2367        
C                                                                       
C   THE READ AND WRITE STATEMENTS MIGHT HAVE TO BE CHANGED.             
C   THE FUNCTION VALUE RETURNED BY DATAN IS ASSUMED TO BE A REAL*8      
C    RANGING FROM -PI/2 TO PI/2                                         
C                                                                       
C                                                                       
C                                                                       
C   THE INPUT DATA ARE GIVEN IN ANNEX                                   
C                                                                       
C*******************************************                            
C   DAILY INSOLATION - LONG TERM VARIATION *                            
C*******************************************                            
C                                                                       
C   CONSTANT                                                            
C                                                                       

      open(8,file="insolation.input",form='formatted')
      if (first_time) then
        first_time=.false.
        PI=3.14159265358979D0                                             
      PIR=PI/180.0D0                                                    
      PIRR=PIR/3600.0D0                                                 
      STEP=360.0D0/365.25D0                                             
      TEST=0.0001D0                                                     
C                                                                       
C   1.EARTH ORBITAL ELEMENTS : ECCENTRICITY           ECC   TABLE 1     
C***************************   PRECESSIONAL PARAMETER PRE               
C                              OBLIQUITY              XOB   TABLE 2     
C                              GENERAL PRECESSION     PRG               
C                              LONGITUDE PERIHELION   PERH  TABLE 3     
C                                                                       
C   READ NAME OF DATA                                                   
C                                                                       
      READ(8,5001)                                                      
5001  FORMAT(/////)                                                     
C         READ AMPLITUDE A  MEAN RATE B  PHASE C                        
C              THEY ARE IMMEDIATELY CONVERTED IN RADIANS                
C                                                                       
C         NEF  NOB  NOP  MAY BE REDUCED TO  19  18  9                   
C         BUT THE INPUT DATA MUST BE CHANGED ACCORDINGLY                
C                                                                       
C   ECCENTRICITY                                                        
C                                                                       
      NEF=19                                                            
        DO I=1,NEF                                                      
      READ(8,5000) AE(I),Y,Z                                            
 5000 FORMAT (13X,F11.8,F20.7,F20.6)                                    
          BE(I)=Y*PIRR                            ! convert into radians
      CE(I)=Z*PIR                                                       
        enddo
C                                                                       
C   OBLIQUITY      table 1 in JAS                                                     
C                                                                       
      XOD=23.320556D0                                                   
      NOB=47                                                            
        DO I=1,NOB                                                      
      READ(8,5002) AOB(I),Y,Z                                           
 5002 FORMAT(7X,F13.7,2X,F10.6,2X,F10.4)                                
      BOB(I)=Y*PIRR                                                     
      COB(I)=Z*PIR                                                      
        enddo
C                                                                       
C   GENERAL PRECESSION IN LONGITUDE table 5 in JAS                                 
C                                                                       
      XOP=3.392506D0                                                    
      PRM=50.439273D0                                                   
      NOP=78                                                            
        DO I=1,NOP                                                     
      READ(8,5002) AOP(I),Y,Z                                           
      BOP(I)=Y*PIRR                                                     
      COP(I)=Z*PIR                                                      
        enddo
C                                                                       
  100 CONTINUE                                                          
C                                                                       
      end if

C     2.INPUT PARAMETERS : LATITUDE PHI - TIME T - OPTION IOPT           
C**********************                                                 
C         IF IOPT=1  TRUE LONG.SUN TLS                                  
C         IF IOPT=2  MONTH MA - DAY JA                                  
C                                                                       
C      NEFF  NOBB  NOPP  NUMBER OF TERMS KEPT FOR COMPUTATION OF        
C                         EARTH ORBITAL ELEMENTS                        
C      THEY CAN BE REDUCED TO 19,18,9 RESPECTIVELY                      
C                 FOR A MINIMUM ACCURACY                                
C

      IOPT=2   ! use calendar date
      NEFF=19
      NOBB=18
      NOPP=9
      
!      write(*,*) "enter PHI (latitude in degrees):"
!      READ(5,*) PHI
      phi=latitude_degrees
      
!      write(*,*) "enter T (in kyr, e.g. -500 is 500,000 years ago):"
!      READ(5,*) T
      T=time_kyr
C                                                                       
C   3.NUMERICAL VALUE FOR ECC PRE XOB                                   
C     T IS NEGATIVE FOR THE PAST ;  T IS IN 1000 YEARS ; T=0 in seasonal cycles mode                
C                                                                       
      T=T*1000.0D0                                                      
      XES=0.0D0                                                         
      XEC=0.0D0                                                         
        DO I=1,NEFF                                                     
      ARG=BE(I)*T+CE(I)                                                 
      XES=XES+AE(I)*DSIN(ARG)                                           
      XEC=XEC+AE(I)*DCOS(ARG)                                           
        enddo
      ECC=DSQRT(XES*XES+XEC*XEC)                                        
      TRA=DABS(XEC)                                                     
      IF(TRA.LE.1.0D-08) GO TO 10                                       
      RP=DATAN(XES/XEC)                                                 
      IF(XEC) 11,10,12                                                  
   11 RP=RP+PI                                                          
      GO TO 13                                                          
   12 IF(XES) 14,13,13                                                  
   14 RP=RP+2.0D0*PI                                                    
      GO TO 13                                                          
   10 IF(XES) 15,16,17                                                  
   15 RP=1.5D0*PI                                                       
      GO TO 13                                                          
   16 RP=0.0D0                                                          
      GO TO 13                                                          
   17 RP=PI/2.0D0                                                       
   13 PERH=RP/PIR                                                       
C                                                                       
      PRG=PRM*T                                                         
      DO I=1,NOP                                                      
        ARG=BOP(I)*T+COP(I)                                               
        PRG=PRG+AOP(I)*DSIN(ARG)                                          
      enddo
      PRG=PRG/3600.0D0+XOP                                              
      PERH=PERH+PRG                                                     
   54 IF(PERH) 51,55,53                                                 
   51 PERH=PERH+360.0D0                                                 
      GO TO 54                                                          
   53 IF(PERH.LT.360.0D0) GO TO 55                                      
      PERH=PERH-360.0D0                                                 
      GO TO 53                                                          
   55 CONTINUE                                                          
C                                                                       
      PRE=ECC*DSIN(PERH*PIR)                                            
C                                                                       
      XOB=XOD                                                           
      DO I=1,NOBB                                                     
        ARG=BOB(I)*T+COB(I)                                               
        XOB=XOB+AOB(I)/3600.0D0*DCOS(ARG)                                 
      end do                                                         

!        WRITE(18,6000) T,ECC,PRE,PERH,XOB                                  
 6000   FORMAT(1X,'TIME =',F10.1,3X,'ECCENTRICITY =',F8.5,/,20X
     &       ,'PREC. PARAM. =',F8.5,/,20X,'LONG. PERH. =',F7.1
     &       ,/,20X,'OBLIQUITY =',F7.3) 

c end of initialization of constants used in the calculations.
c done once each run
c XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


C                                                                       
C   4.DAILY INSOLATION                                                  
C*********************                                                  
C                                                                       
C   OPTION SOLAR DATE - CALENDAR DATE                                   
C       DAILY INSOLATION IN LY DAY(-1)    OR    KJ M(-2) DAY(-1)        
C                  IF S0 IN LY MIN(-1)    OR    W M(-2)                 
C                     TAU = 24*60 MIN     OR    24*60*60 SEC / 1000     
C                                                                       
C                        IN W M(-2)                                     
C                  IF S0 IN W M(-2)      AND    TAU=1.0                 
C                                                                       
      SS=1367.0D0      ! solar constant                                                 
      TAU=86.4D0                                                        
      SF=TAU*SS/PI                                                      
      SO=DSIN(XOB*PIR)                                                  
      XL=PERH+180.0D0                                                   
!      WRITE(6,6003) PHI                                                 
 6003 FORMAT(1X,'LATITUDE =',F6.1)                                      
!      WRITE(6,6004) T,ECC,PRE,PERH,XOB                                  
 6004 FORMAT(1X,'TIME =',F10.1,3X,'ECCENTRICITY =',F8.5,/,20X,'PREC. PAR
     &AM. =',F8.5,/,20X,'LONG. PERH. =',F7.1,/,20X,'OBLIQUITY =',F7.3)  
C                                                                       
      IF(IOPT.EQ.2) GO TO 20                                            
C                                                                       
C   4.1 SOLAR DATE                                                      
C-----------------                                                      
C       CONSTANT INCREMENT OF TRUE LONGITUDE OF SUN TLS                 
C       ORIGIN IS VERNAL EQUINOX                                        
C       IF TLS=I*30 MID-MONTH IS NOW AROUND 21                          
C       TLS=0,30,...300,330 RESPECTIVELY FOR MARCH ... JANUARY, FEBRUARY
C                                                                       
!      write(*,*) "enter TLS:"
      READ(5,*) TLS                                                     
C                                                                       
      CALL DAYINS(ECC,XL,SO,TLS,PHI,PIR,PI,TEST,SF,WW,DAYL)             
!      WRITE(6,6001) TLS                                                 
 6001 FORMAT(1X,'TRUE LONG. SUN =',F7.1)                                
!      WRITE(6,6002) WW*1000/86400,DAYL
 6002 FORMAT(1X,'DAY INSOL. =',F7.0,1X,'W M(-2) ',4X,'LENGTH DA
     * =',F6.2,1X,'HOURS')                                              
      GO TO 101                                                         
C                                                                       
   20 CONTINUE                                                          
C                                                                       
C   4.2 CALENDAR DATE  MA-JA                                            
C--------------------                                                   
C      ND  NUMBER OF THIS DAY IN A YEAR OF 365 DAYS                     
C      XLAM = MEAN LONG. SUN FOR TRUE LONG. = 0                         
C      DLAMM = MEAN LONG. SUN FOR MA-JA                                 
C                                                                       
      MA=month
      JA=day
!     READ(5,*) MA,JA
!      write(*,*) " MA (month)=",ma,", JA (day of the month)=",ja
!      write(*,*) "e.g. for June 21, MA=6, JA=21:"
C                                                                       
      CALL NDAY(MA,JA,ND)                                               
      XLLP=XL*PIR                                                       
      XEE=ECC*ECC                                                       
      XSE=DSQRT(1.0D0-XEE)                                              
      XLAM=(ECC/2.0D0+ECC*XEE/8.0D0)*(1.0D0+XSE)*DSIN(XLLP)-XEE/4.0D0*(0
     &.5D0+XSE)*DSIN(2.0D0*XLLP)+ECC*XEE/8.0D0*(1.0D0/3.0D0+XSE)*DSIN(3.
     &0D0*XLLP)                                                         
      XLAM=2.0D0*XLAM/PIR                                               
      DLAMM=XLAM+(ND-80)*STEP                                           
      ANM=DLAMM-XL                                                      
      RANM=ANM*PIR                                                      
      XEC=XEE*ECC                                                       
      RANV=RANM+(2.0D0*ECC-XEC/4.0D0)*DSIN(RANM)+5.0D0/4.0D0*ECC*ECC*   
     &     DSIN(2.0D0*RANM)+13.0D0/12.0D0*XEC*DSIN(3.0D0*RANM)               
      ANV=RANV/PIR                                                      
      TLS=ANV+XL                                                        
      CALL DAYINS(ECC,XL,SO,TLS,PHI,PIR,PI,TEST,SF,WW,DAYL)             
!      WRITE(6,6010) MA,JA,TLS                                           
 6010 FORMAT(1X,'MONTH =',I3,3X,'DAY =',I3,3X,'TLS =',F7.1)             
!      WRITE(6,6002) WW*1000/86400,DAYL                                             
C                                                                       
  101 continue
!      WRITE(6,6100)                                                     
 6100 FORMAT(//)                                                        
C                                                                       
!      GO TO 100                                                         
c      STOP                                                              
      return
      END                                                               
      SUBROUTINE NDAY(MA,JA,ND)                                         
      IMPLICIT REAL*8(A-H,P-Z)                                          
      DIMENSION NJM(12)                                                 
      DATA NJM/31,28,31,30,31,30,31,31,30,31,30,31/                     
      ND=0                                                              
      M=MA-1                                                            
      IF (M.EQ.0) GO TO 2                                               
      DO 1 I=1,M                                                        
    1 ND=ND+NJM(I)                                                      
    2 ND=ND+JA                                                          
      RETURN                                                            
      END                                                               
      SUBROUTINE DAYINS(ECC,XL,SO,DLAM,PHI,PIR,PI,TEST,SF,WW,DAYL)      
      IMPLICIT REAL*8(A-H,P-Z)                                          
C                                                                       
C   OUTPUT : WW=LY/DAY  OR  KJ M(-2) DAY(-1)  DAYL=LENGTH OF DAY (HOURS)
C                                                                       
      RPHI=PHI*PIR                                                      
      RANV=(DLAM-XL)*PIR                                                
      RAU=(1.0D0-ECC*ECC)/(1.0D0+ECC*DCOS(RANV))                        
      S=SF/RAU/RAU                                                      
      RLAM=DLAM*PIR                                                     
      SD=SO*DSIN(RLAM)                                                  
      CD=DSQRT(1.0D0-SD*SD)                                             
      RDELTA=DATAN(SD/CD)                                               
      DELTA=RDELTA/PIR                                                  
      SP=SD*DSIN(RPHI)                                                  
      CP=CD*DCOS(RPHI)                                                  
      APHI=DABS(PHI)                                                    
      ADELTA=DABS(DELTA)                                                
C                                                                       
C   SINGULARITY FOR APHI=90 AND DELTA=0                                 
C   PARTICULAR CASES FOR PHI=0  OR  DELTA=0                             
C                                                                       
      TT=DABS(APHI-90.0D0)                                              
      IF ((TT.LE.TEST).AND.(ADELTA.LE.TEST)) GO TO 2                    
      IF(ADELTA.LE.TEST) GO TO 6                                        
      IF(APHI.LE.TEST) GO TO 7                                          
C                                                                       
C   LABEL 2 : POLAR CONTINUAL NIGHT OR W=0  DAYL=0                      
C   LABEL 4 : POLAR CONTINUAL DAY                                       
C   LABEL 3 : DAILY SUNRISE AND SUNSET                                  
C   LABEL 6 : EQUINOXES                                                 
C   LABEL 7 : EQUATOR                                                   
C                                                                       
      AT=90.0D0-ADELTA                                                  
      SPD=PHI*DELTA                                                     
      IF (APHI.LE.AT) GO TO 3                                           
      IF (SPD) 2,3,4                                                    
    2 DAYL=0.00D0                                                       
      WW=0.00D0                                                         
      GO TO 5                                                           
    4 DAYL=24.00D0                                                      
      WW=S*SP*PI                                                        
      GO TO 5                                                           
    3 TP=-SP/CP                                                         
      STP=DSQRT(1.0D0-TP*TP)                                            
      RDAYL=dACOS(TP)                                                  
      DAYL=24.0D0*RDAYL/PI                                              
      WW=S*(RDAYL*SP+CP*STP)                                            
      GO TO 5                                                           
    6 DAYL=12.0D0                                                       
      WW=S*DCOS(RPHI)                                                   
      GO TO 5                                                           
    7 DAYL=12.0D0                                                       
      WW=S*DCOS(RDELTA)                                                 
    5 RETURN                                                            
      END                                                               
