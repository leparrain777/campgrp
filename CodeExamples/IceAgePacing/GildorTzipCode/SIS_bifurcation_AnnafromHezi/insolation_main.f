! Main program for running the insolation.f subroutine alone:
! -----------------------------------------------------------
      IMPLICIT REAL*8(A-H,P-Z)                                          
      real*8 time_kyr, latitude_degrees
      integer month, day
      save
      time_kyr=-500
      month=6
      day=21
      latitude_degrees=65

!      write(*,*) " Enter time_kyr (negative for past), month,"
!     &     ," day in month, latitude_degrees:"
!     read(*,*) time_kyr, month, day, latitude_degrees
      open(33,file="Output/insol.dat")
      open(35,file="Output/insolation.data",form='unformatted')
      do time_kyr=-2000.0,0.0,0.01
        call insolation(time_kyr, month, day, latitude_degrees
     &       ,WW,TLS,ECC,PRE,PERH,XOB,DAYL )
        write(33,'(8g14.6)') time_kyr,WW*1000/86400,ECC,PRE,PERH,XOB
        write(35) WW
      end do
        WRITE(6,6010) month,day,TLS 
 6010   FORMAT(1X,'MONTH =',I3,3X,'DAY =',I3,3X,'TLS =',F7.1) 
        WRITE(6,6002) WW*1000/86400,DAYL 
 6002   FORMAT(1X,'DAY INSOL. =',F7.0,1X,'W M(-2) ',4X,'LENGTH DA
     *       =',F6.2,1X,'HOURS') 
        WRITE(6,6000) time_kyr,ECC,PRE,PERH,XOB 
 6000   FORMAT(1X,'TIME =',F10.1,3X,'ECCENTRICITY =',F8.5,/,20X
     &       ,'PREC. PARAM. =',F8.5,/,20X,'LONG. PERH. =',F7.1
     &       ,/,20X,'OBLIQUITY =',F7.3) 
      stop
      end
