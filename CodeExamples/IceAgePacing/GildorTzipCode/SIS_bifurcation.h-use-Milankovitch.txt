!-------------------------------!      
!     all parameters in MKS     !
!-------------------------------!

      integer neq, max_output, noutputs, ncalls

      parameter (neq=2,max_output=10000)

      real*8 Sv, yr, C_T_f, T_F_0, T_deep_ocean_0, C_T_deep_ocean,T_rain
     &     ,H_s, sigma_SB ,P_0 ,P_1 ,delta
     &     ,S_0, S_Milan_input, S_Milan, S_Temperature, S_isostatic
     &     ,alpha_s ,alpha_L, alpha_C, alpha_total, TEND, TBEG
     &     ,C_p,rho0, a_ocn, a_lnd, a_total, V_ocn
     &     ,I0_s ,C_ocn, pi,emissivity
     &     ,domain_length_NS,domain_width_EW
     &     ,lnd_width_fraction,ocn_width_fraction
     &     ,output_interval,initial_ice,initial_temperature
      real*8 output_array(max_output,2)
      real*8 insolation_data(-200000:0)  ! for storing milankovitch radiation
      logical switch_precipitation, use_milankovitch, read_insolation
     &     ,with_albedo_bug

      parameter(
     &     Sv=1.e6                                ! m^3/sec
     &     ,pi=3.14159265                         ! nondim
     &     ,yr=3600.0*24.0*365.0                  ! sec
     &     ,TBEG=-1500.0*(1.e3*yr)                ! start time of run
     &     ,TEND=0.0*(1.e3*yr)                    ! end time of run
     &     ,output_interval=1.e3*yr               ! sec
     &     ,initial_ice=10*(2000.e3)**2*2.e3       ! m^3
     &     ,initial_temperature=10.0              ! deg celsius
     &     ,C_T_f=10.0                             ! nondim, sensitivity of freezin point t_f to Temperature_deep_ocean
     &     ,T_F_0=2.0                             ! used in  parameterization of freezin point t_f
     &     ,T_rain=15.0                           ! degree c.  temp above which precipitation starts turning to rain.
     &     ,H_s=350.0                             ! watts/m^2, solar constant
     &     ,sigma_SB=5.67e-8                      ! watts m^-2 K^-4, Stephan Boltzman
     &     ,P_0=0.06*Sv                           ! Sv, precipitation parameterization
     &     ,P_1=40.0                              ! nondim, precipitation parameterization
     &     ,delta=0.2                             ! nondim, precipitation parameterization
     &     ,S_0=0.15*Sv                           ! m^3/sec, ablation parameterization
     &     ,S_Milan_input=0.08*Sv                 ! m^3/sec, ablation parameterization
     &     ,S_Temperature=0.0015*Sv               ! m^3/sec, ablation parameterization
     &     ,S_isostatic=0.0*Sv                    ! m^3/sec, ablation parameterization
     &     ,alpha_s=0.65                          ! nondim, albedo of sea ice
     &     ,alpha_L=0.7                           ! nondim, albedo of land ice
     &     ,alpha_C=0.27                          ! nondim, albedo of clouds
     &     ,C_p=4000.0                            ! J Kg^-1 K^-1
     &     ,rho0=1028.0                           ! kg/m^3
     &     ,lnd_width_fraction=0.5                ! nondim, model geomoetry
     &     ,ocn_width_fraction=1-lnd_width_fraction ! nondim, model geomoetry
     &     ,domain_length_NS=5000*1.e3            ! m, model geomoetry
     &     ,domain_width_EW =8000*1.e3            ! m, model geomoetry
     &     ,a_lnd=domain_length_NS*domain_width_EW*lnd_width_fraction ! m^2
     &     ,a_ocn=domain_length_NS*domain_width_EW*ocn_width_fraction ! m^2
     &     ,V_ocn=a_ocn*8.e2                      ! m^3, upper ocean volume
     &     ,I0_s=0.3*a_ocn                        ! m^2, sea ice area when it's on.
     &     ,C_ocn=C_p*V_ocn*rho0                  ! upper ocean heat capacity
     &     ,emissivity=0.64                       ! nondim
     &     ,switch_precipitation=.false.          ! logical
     &     ,use_milankovitch=.true.               ! logical
     &     ,read_insolation=.true.                ! logical
     &     ,with_albedo_bug=.false.               ! logical
     &     )

      common/cSIS/output_array,noutputs,ncalls,insolation_data,S_Milan
     &     ,alpha_total
