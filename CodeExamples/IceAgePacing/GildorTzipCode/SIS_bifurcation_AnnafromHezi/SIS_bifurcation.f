*     D02PDF Example Program Text
*     Mark 16 Release. NAG Copyright 1993.
*     .. Parameters ..
      implicit none
      include "SIS_bifurcation.h"
      INTEGER NOUT
      PARAMETER (NOUT=6)
      DOUBLE PRECISION Precipitation, Ablation,T_deep_ocean
     &     ,Temperature,land_ice_area,ice_volume
      INTEGER          I,L
      DOUBLE PRECISION YNOW(NEQ), YPNOW(NEQ)
      INTEGER  IFAIL
      real*8 time, time1, time2, Y(NEQ), TOL, G, W(28+21*NEQ)
     &     ,time_nag,tend_nag,S_milan_save
      CHARACTER*1 RELABS
      EXTERNAL  F, OUTPUT, D02CJW
*     .. Executable Statements ..

*  Set initial conditions and input for Nag
      open(33,file="Output/z.dat") ! ,status='new')
      open(34,file="Output/x.dat") ! ,status='new')
      if (use_milankovitch.and.read_insolation) then
        open(35,file="Output/insolation.data",form='unformatted')
        do i=-200000,0
          read(35) insolation_data(i)
        end do
!        write(44,'(g14.6)') (insolation_data(i),i=-200000,0)
      end if
      time1 = tbeg
      time2 = tend
      ice_volume=0.0
      S_milan=0.0
      do Temperature=-15.,25.,0.05
        write(34,'(8g12.4)') Temperature
     &       ,Precipitation(Temperature+273,time1)/Sv
     &       ,Precipitation(Temperature+273,time2)/Sv
     &       ,Ablation(time1,Temperature,ice_volume)/Sv
     &       ,Ablation(time2,Temperature,ice_volume)/Sv
      end do
      S_milan=S_milan_input

c     initial land ice volume (8000km^2*1km):
      Y(1) = initial_ice
c     initial ocean temperature:
      Y(2) = initial_temperature

*     Integrate:
      TOL = 1.0D-10
!      WRITE (NOUT,'(/A,D8.1)') 'Calculation with TOL = ', TOL
      WRITE (NOUT,'(/4A/)')
     &     '  t(kyr)     I_L_area/a_land      T_ocn_atm      P ,   S'
      IFAIL = 0
      relabs='M'
      time_nag=tbeg
      tend_nag=tend
      call D02CJF(time_nag, TEND_nag, NEQ, Y, F, TOL, RELABS, OUTPUT,
     &     D02CJW, W,IFAIL)
      if (ifail.ne.0) then
        write(*,*) " IFAIL=",IFAIL
        stop' SIS error: ifail .ne.0 on exit from D02CJF'
      endif
      ice_volume=Y(1)
      Temperature=Y(2)
      WRITE (NOUT,'(1X,g12.4,400(3X,g14.6))') time_nag/(1.e3*yr)
     &     ,land_ice_area(ice_volume)/a_lnd,Temperature
     &     ,Precipitation(Temperature+273,time_nag)/Sv
     &     ,Ablation(time_nag,Temperature,ice_volume)/Sv
      WRITE (33,'(1X,g12.4,400(3X,g14.6))') time_nag/(1.e3*yr)
     &     ,land_ice_area(ice_volume)/a_lnd,Temperature
     &     ,Precipitation(Temperature+273,time)/Sv
     &     ,Ablation(time_nag,Temperature,ice_volume)/Sv

      call calculate_avg_period
!      write(*,*) "ncalls to ablation routine=",ncalls
      
      STOP
      END


      SUBROUTINE F(time,Y,YP)
      implicit none
*     .. Scalar Arguments ..
      DOUBLE PRECISION time,Precipitation,Ablation,land_ice_area
*     .. Array Arguments ..
      DOUBLE PRECISION Y(*), YP(*)
      real*8 P,S,I_s,ice_volume,T_ocn_atm,T_deep_ocean
      real*8 ocean_albedo, land_albedo, I_L_area,T_f
      include "SIS_bifurcation.h"
*     .. Executable Statements ..

c     Prognostic model parameters:      
      ice_volume=Y(1)
      T_ocn_atm=Y(2)

c     Calculate diagnostic variables
      I_L_area=land_ice_area(ice_volume)
      S=Ablation(time,T_ocn_atm,ice_volume)
      P=Precipitation(T_ocn_atm+273.0,time)
      if (T_ocn_atm.lt.T_f(time)) then
        I_s=I0_s
      else
        I_s=0.0
      endif

      ocean_albedo =  (1 - alpha_s * I_s/a_ocn)
      land_albedo = (1 - alpha_L * I_L_area/a_lnd)

!     Calculate rhs of prognostic equations:
!     --------------------------------------
!     For land ice:
      YP(1) = P - S
!     to avoid further decreasing an already negative land ice:      
      if (ice_volume.le.0 .and. P - S .lt. 0.0) YP(1)=0.0
!     to avoid having the glacier grow too much:
      if (I_L_area.gt.0.8*a_lnd .and. P - S .gt. 0.0) YP(1)=0.0

      
!     For ocean temperature:
      YP(2)=( - emissivity * sigma_SB
     &     * (T_ocn_atm+273.0)**2*(T_ocn_atm+273.0)**2
     &     + H_s * ocean_albedo * land_albedo * (1.-alpha_C)
     &     )*a_ocn/C_ocn


      RETURN
      END

      real*8 function land_ice_area(ice_volume)
!     using a parabolic shape assumption
      implicit none
      include "SIS_bifurcation.h"
      real*8 ice_volume,sqrt_lambda,glacier_width,glacier_length

      sqrt_lambda=3.1622777                       ! sqrt(10)
      if (ice_volume.lt.0) then
!       stop 'Error: negative ice volume in function land_ice_area'
        land_ice_area=0.0
      else
        glacier_width=domain_width_EW*lnd_width_fraction
        glacier_length=
     &       (abs(ice_volume/(glacier_width*2*sqrt_lambda)))**(2./3.)
        land_ice_area=glacier_width*glacier_length
      end if

      return
      end


      SUBROUTINE OUTPUT(time,Y)
      implicit none
      include "SIS_bifurcation.h"
      real*8 time,Y(*)
     &     ,land_ice_area,Precipitation,Ablation,T_deep_ocean
     &     ,ice_volume, Temperature
      data noutputs/0/

      ice_volume=Y(1)
      Temperature=Y(2)
c     write to output file:
      WRITE (33,'(1X,g12.4,400(3X,g14.6))') time/(1.e3*yr)
!     &     ,ice_volume,Temperature
     &     ,land_ice_area(ice_volume)/a_lnd,Temperature
     &     ,Precipitation(Temperature+273,time)/Sv
     &     ,Ablation(time,Temperature,ice_volume)/Sv

c     Save output in an aray, to be used for calculating period:
      if (noutputs .lt. max_output) then
        noutputs=noutputs+1
        output_array(noutputs,1)=time/(1.e3*yr)
        output_array(noutputs,2)=land_ice_area(ice_volume)/a_lnd
      else
        write(*,*) 'too many outputs for size of output_array.'
        stop
      endif

c     Specify for Nag the next time to write output:
      time=time+output_interval
      return
      end


      subroutine calculate_avg_period
      implicit none
      include "SIS_bifurcation.h"
      integer i,nzeros,max_zeros,iavg
      parameter(max_zeros=10000)
      real*8 time_of_zero(max_zeros)
      real*8 t_before_zero, t_after_zero,
     &     ice_before_zero, ice_after_zero
     &     ,avg_period, rms_period, avg


c     Remove mean of land ice (mean based on second half of time series
c     only, to avoid transient effects), so that zero-crossings may be
c     used to calcualte the period:
      avg=0.0
      iavg=0
      do i=noutputs/2,noutputs
        iavg=iavg+1
        avg=avg+output_array(i,2)
      end do
      avg=avg/iavg
      do i=noutputs/2,noutputs
        output_array(i,2)=output_array(i,2)-avg
      end do

c     Calculate times interpolated zeros of land ice:
      nzeros=0
      do i=noutputs/2+1,noutputs
        if (output_array(i,2).gt.0.0
     &       .and.
     &       output_array(i-1,2).le.0.0) then
          nzeros=nzeros+1
          t_before_zero=output_array(i-1,1)
          t_after_zero=output_array(i,1)
          ice_before_zero=output_array(i-1,2)
          ice_after_zero=output_array(i,2)
          time_of_zero(nzeros)=
     &      (t_before_zero*ice_after_zero-t_after_zero*ice_before_zero)
     &         /(ice_after_zero-ice_before_zero)
        endif
      end do

c     Average over periods during second half of run, to avoid transient
c     effects:
      if (nzeros.gt.4) then
        avg_period=0.0
        iavg=0
        do i=nzeros/2,nzeros
          iavg=iavg+1
          avg_period=avg_period+(time_of_zero(i)-time_of_zero(i-1))
        end do
        avg_period=avg_period/iavg

c       calculate rms of period during the second half of run:
        rms_period=0.0
        iavg=0
        do i=nzeros/2,nzeros
          iavg=iavg+1
          rms_period=(avg_period-(time_of_zero(i)-time_of_zero(i-1)))**2
        end do
        rms_period=sqrt(rms_period/iavg)

        write(*,'(" avg_period, rms_period=",2G16.8)')
     &       avg_period, rms_period
      else
        write(*,'(" calculate_avg_period: "
     &       ,"not enough zeros to calculate period, nzeros=",I5)')
     &       nzeros
      end if
      
      return
      end

      real*8 function Precipitation(Temperature,time)
!     Temperature should be in Kelvin
      implicit none
      include "SIS_bifurcation.h"
      real*8 A,B,RH,qsat,epsilon,Temperature,ps,q,T_f
     &     ,time
 
      if (switch_precipitation) then
c       precipitation is at one of two states, dictated by the presence
c       of sea ice:
        if (Temperature.lt.273+T_f(time)) then
          Precipitation=delta*P_0
        else
          Precipitation=P_0
        endif
      else
c       calculate the saturation vapor pressure using approximate
c       Clausius-Clapeyron equation.
        
        A=2.53d+11                                ! Pascall
        B=5.42d+3                                 ! K
        RH=0.7                                    ! relative humidity
        Ps=1.0d+5                                 ! surface pressure, pascal
        epsilon=0.622
        qsat=A*exp(-B/Temperature)

c       Calculate new specific humidity base on constant relative
c       humidity RH in each box
        q=RH*epsilon*qsat/Ps

!       Multiply by an arbitrary constant to convert to Sv of
!       precipitation over land glaciers:
        Precipitation=P_0+q*P_1*1.e6

!       if sea ice exists, then reduce precipitation due to reduced
!       local evalporation and shifts of storm track:
        if (Temperature.lt.273+T_f(time)) then
          Precipitation=Precipitation*(1-I0_s/a_ocn)
        endif
        if (Temperature.gt.273+T_rain) then
          Precipitation=
     &         Precipitation*exp(-(Temperature-(T_rain+273.))**2/8.**2)
        endif
        
      end if

      return
      end

      real*8 function Ablation(time,Temperature,ice_volume)
      implicit none
      include "SIS_bifurcation.h"
      real*8 time,Temperature,ice_volume,ablation_area,land_ice_area
     &     ,S_Milankovitch

      ablation_area=a_lnd*0.5
      Ablation = S_0
     &     + S_Temperature*(Temperature-0.0)
     &     + S_Milankovitch(time)
     &     + S_isostatic*(land_ice_area(ice_volume)/ablation_area-1.0)

      return
      end

      real*8 function S_Milankovitch(time)
!     the part of ablation that depends on Milankovitch forcing
      implicit none
      include "SIS_bifurcation.h"
      real*8 time_kyr,time,latitude_degrees
     &     ,WW,TLS,ECC,PRE,PERH,XOB,DAYL
     &     ,mean_insolation,std_insolation
      integer month, day

      ncalls=ncalls+1
      
      if (use_milankovitch) then
        time_kyr=time/(1000.0*yr)
        month=6
        day=21
        latitude_degrees=65
!       (WW*1000/86400) is in watts/m^2; substruct and divide by mean to bring to O(1):
        if (read_insolation) then
          ww=insolation_data(nint(time_kyr*100))
        else
          call insolation(time_kyr, month, day, latitude_degrees
     &         ,WW,TLS,ECC,PRE,PERH,XOB,DAYL)
        end if
        mean_insolation=493.3234                  ! mean(insol(:,2)
        std_insolation=23.4328                    ! std(insol(:,2)-mean(insol(:,2)))
        S_Milankovitch=S_Milan
     &       *1.5*(WW*1000/86400-mean_insolation)/std_insolation
      else
        S_Milankovitch=S_Milan*sin(2*pi*time/(41.0*1000*yr))
      end if

      return
      end


      real*8 function T_F(time)
!     The atmospheric temp in celsius for which sea ice starts freezing.
!     This temp depends on the temp of the deep ocean.
      implicit none
      include "SIS_bifurcation.h"
      real*8 time

      T_F=min(T_F_0+C_T_f*time/(1.e6*yr),-3.0)

      return
      end


c$$$      real*8 function T_deep_ocean(time)
c$$$!     The temperature of the deep ocean (celsius).
c$$$      implicit none
c$$$      include "SIS_bifurcation.h"
c$$$      real*8 time
c$$$
c$$$      T_deep_ocean=T_deep_ocean_0
c$$$     &     +C_T_deep_ocean*(min(time,-500.0)-tbeg)/(1.e6*yr)
c$$$
c$$$      return
c$$$      end
