!----------------------------------------------------------------------------------------------------
!> @brief internal microstructure state for all plasticity constitutive models
!----------------------------------------------------------------------------------------------------
submodule(constitutive) constitutive_mech

  integer(kind(ELASTICITY_undefined_ID)), dimension(:),   allocatable :: &
    phase_elasticity                                                                                !< elasticity of each phase
  integer(kind(SOURCE_undefined_ID)),     dimension(:,:), allocatable :: &
    phase_stiffnessDegradation                                                                      !< active stiffness degradation mechanisms of each phase


  interface

    module function plastic_none_init()          result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_none_init

    module function plastic_isotropic_init()     result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_isotropic_init

    module function plastic_phenopowerlaw_init() result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_phenopowerlaw_init

    module function plastic_kinehardening_init() result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_kinehardening_init

    module function plastic_dislotwin_init()     result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_dislotwin_init

    module function plastic_dislotungsten_init() result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_dislotungsten_init

    module function plastic_nonlocal_init()      result(myPlasticity)
      logical, dimension(:), allocatable :: &
        myPlasticity
    end function plastic_nonlocal_init


    module subroutine plastic_isotropic_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress

      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                         intent(in) :: &
        instance, &
        of
    end subroutine plastic_isotropic_LpAndItsTangent

    pure module subroutine plastic_phenopowerlaw_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress
      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                         intent(in) :: &
        instance, &
        of
    end subroutine plastic_phenopowerlaw_LpAndItsTangent

    pure module subroutine plastic_kinehardening_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress

      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                         intent(in) :: &
        instance, &
        of
    end subroutine plastic_kinehardening_LpAndItsTangent

    module subroutine plastic_dislotwin_LpAndItsTangent(Lp,dLp_dMp,Mp,T,instance,of)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress

      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      real(pReal),                     intent(in) :: &
        T
      integer,                         intent(in) :: &
        instance, &
        of
    end subroutine plastic_dislotwin_LpAndItsTangent

    pure module subroutine plastic_dislotungsten_LpAndItsTangent(Lp,dLp_dMp,Mp,T,instance,of)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress

      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      real(pReal),                     intent(in) :: &
        T
      integer,                         intent(in) :: &
        instance, &
        of
    end subroutine plastic_dislotungsten_LpAndItsTangent

    module subroutine plastic_nonlocal_LpAndItsTangent(Lp,dLp_dMp, &
                                                       Mp,Temperature,instance,of,ip,el)
      real(pReal), dimension(3,3),     intent(out) :: &
        Lp                                                                                          !< plastic velocity gradient
      real(pReal), dimension(3,3,3,3), intent(out) :: &
        dLp_dMp                                                                                     !< derivative of Lp with respect to the Mandel stress

      real(pReal), dimension(3,3),     intent(in) :: &
        Mp                                                                                          !< Mandel stress
      real(pReal),                     intent(in) :: &
        Temperature
      integer,                         intent(in) :: &
        instance, &
        of, &
        ip, &                                                                                       !< current integration point
        el                                                                                          !< current element number
    end subroutine plastic_nonlocal_LpAndItsTangent

        module subroutine plastic_isotropic_dotState(Mp,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_isotropic_dotState

    module subroutine plastic_phenopowerlaw_dotState(Mp,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_phenopowerlaw_dotState

    module subroutine plastic_kinehardening_dotState(Mp,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_kinehardening_dotState

    module subroutine plastic_dislotwin_dotState(Mp,T,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      real(pReal),                  intent(in) :: &
        T
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_dislotwin_dotState

    module subroutine plastic_disloTungsten_dotState(Mp,T,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      real(pReal),                  intent(in) :: &
        T
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_disloTungsten_dotState

    module subroutine plastic_nonlocal_dotState(Mp, F, Fp, Temperature,timestep, &
                                                        instance,of,ip,el)
      real(pReal), dimension(3,3), intent(in) :: &
        Mp                                                                                          !< MandelStress
      real(pReal), dimension(3,3,homogenization_maxNconstituents,discretization_nIPs,discretization_Nelems), intent(in) :: &
        F, &                                                                                        !< deformation gradient
        Fp                                                                                          !< plastic deformation gradient
      real(pReal), intent(in) :: &
        Temperature, &                                                                              !< temperature
        timestep                                                                                    !< substepped crystallite time increment
      integer, intent(in) :: &
        instance, &
        of, &
        ip, &                                                                                       !< current integration point
        el                                                                                          !< current element number
    end subroutine plastic_nonlocal_dotState


    module subroutine plastic_dislotwin_dependentState(T,instance,of)
      integer,       intent(in) :: &
        instance, &
        of
      real(pReal),   intent(in) :: &
        T
    end subroutine plastic_dislotwin_dependentState

    module subroutine plastic_dislotungsten_dependentState(instance,of)
      integer,       intent(in) :: &
        instance, &
        of
    end subroutine plastic_dislotungsten_dependentState

    module subroutine plastic_nonlocal_dependentState(F, Fp, instance, of, ip, el)
      real(pReal), dimension(3,3), intent(in) :: &
        F, &                                                                                        !< deformation gradient
        Fp                                                                                          !< plastic deformation gradient
      integer, intent(in) :: &
        instance, &
        of, &
        ip, &                                                                                       !< current integration point
        el                                                                                          !< current element number
    end subroutine plastic_nonlocal_dependentState

        module subroutine plastic_kinehardening_deltaState(Mp,instance,of)
      real(pReal), dimension(3,3),  intent(in) :: &
        Mp                                                                                          !< Mandel stress
      integer,                      intent(in) :: &
        instance, &
        of
    end subroutine plastic_kinehardening_deltaState

    module subroutine plastic_nonlocal_deltaState(Mp,instance,of,ip,el)
      real(pReal), dimension(3,3), intent(in) :: &
        Mp
      integer, intent(in) :: &
        instance, &
        of, &
        ip, &
        el
    end subroutine plastic_nonlocal_deltaState

    module subroutine plastic_isotropic_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_isotropic_results

    module subroutine plastic_phenopowerlaw_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_phenopowerlaw_results

    module subroutine plastic_kinehardening_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_kinehardening_results

    module subroutine plastic_dislotwin_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_dislotwin_results

    module subroutine plastic_dislotungsten_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_dislotungsten_results

    module subroutine plastic_nonlocal_results(instance,group)
      integer,          intent(in) :: instance
      character(len=*), intent(in) :: group
    end subroutine plastic_nonlocal_results


  end interface


contains


!--------------------------------------------------------------------------------------------------
!> @brief Initialize mechanical field related constitutive models
!> @details Initialize elasticity, plasticity and stiffness degradation models.
!--------------------------------------------------------------------------------------------------
module subroutine mech_init

  integer :: &
    p, &
    stiffDegradationCtr
  class(tNode), pointer :: &
    phases, &
    phase, &
    mech, &
    elastic, &
    stiffDegradation

  print'(/,a)', ' <<<+-  constitutive_mech init  -+>>>'

!-------------------------------------------------------------------------------------------------
! initialize elasticity (hooke)                         !ToDO: Maybe move to elastic submodule along with function homogenizedC?
  phases => config_material%get('phase')
  allocate(phase_elasticity(phases%length), source = ELASTICITY_undefined_ID)
  allocate(phase_elasticityInstance(phases%length), source = 0)
  allocate(phase_NstiffnessDegradations(phases%length),source=0)
  allocate(output_constituent(phases%length))

  do p = 1, phases%length
    phase   => phases%get(p)
    mech    => phase%get('mechanics')
#if defined(__GFORTRAN__)
    output_constituent(p)%label  = output_asStrings(mech)
#else
    output_constituent(p)%label  = mech%get_asStrings('output',defaultVal=emptyStringArray)
#endif
    elastic => mech%get('elasticity')
    if(elastic%get_asString('type') == 'hooke') then
      phase_elasticity(p) = ELASTICITY_HOOKE_ID
    else
      call IO_error(200,ext_msg=elastic%get_asString('type'))
    endif
    stiffDegradation => mech%get('stiffness_degradation',defaultVal=emptyList)                      ! check for stiffness degradation mechanisms
    phase_NstiffnessDegradations(p) = stiffDegradation%length
  enddo

  allocate(phase_stiffnessDegradation(maxval(phase_NstiffnessDegradations),phases%length), &
                        source=STIFFNESS_DEGRADATION_undefined_ID)

  if(maxVal(phase_NstiffnessDegradations)/=0) then
    do p = 1, phases%length
      phase => phases%get(p)
      mech    => phase%get('mechanics')
      stiffDegradation => mech%get('stiffness_degradation',defaultVal=emptyList)
      do stiffDegradationCtr = 1, stiffDegradation%length
        if(stiffDegradation%get_asString(stiffDegradationCtr) == 'damage') &
            phase_stiffnessDegradation(stiffDegradationCtr,p) = STIFFNESS_DEGRADATION_damage_ID
      enddo
    enddo
  endif


! initialize plasticity
  allocate(plasticState(phases%length))
  allocate(phase_plasticity(phases%length),source = PLASTICITY_undefined_ID)
  allocate(phase_plasticityInstance(phases%length),source = 0)
  allocate(phase_localPlasticity(phases%length),   source=.true.)

  where(plastic_none_init())              phase_plasticity = PLASTICITY_NONE_ID
  where(plastic_isotropic_init())         phase_plasticity = PLASTICITY_ISOTROPIC_ID
  where(plastic_phenopowerlaw_init())     phase_plasticity = PLASTICITY_PHENOPOWERLAW_ID
  where(plastic_kinehardening_init())     phase_plasticity = PLASTICITY_KINEHARDENING_ID
  where(plastic_dislotwin_init())         phase_plasticity = PLASTICITY_DISLOTWIN_ID
  where(plastic_dislotungsten_init())     phase_plasticity = PLASTICITY_DISLOTUNGSTEN_ID
  where(plastic_nonlocal_init())          phase_plasticity = PLASTICITY_NONLOCAL_ID

  do p = 1, phases%length
    phase_elasticityInstance(p) = count(phase_elasticity(1:p) == phase_elasticity(p))
    phase_plasticityInstance(p) = count(phase_plasticity(1:p) == phase_plasticity(p))
  enddo

end subroutine mech_init


!--------------------------------------------------------------------------------------------------
!> @brief checks if a plastic module is active or not
!--------------------------------------------------------------------------------------------------
module function plastic_active(plastic_label)  result(active_plastic)

  character(len=*), intent(in)       :: plastic_label                                               !< type of plasticity model
  logical, dimension(:), allocatable :: active_plastic

  class(tNode), pointer :: &
    phases, &
    phase, &
    mech, &
    pl
  integer :: p

  phases => config_material%get('phase')
  allocate(active_plastic(phases%length), source = .false. )
  do p = 1, phases%length
    phase => phases%get(p)
    mech  => phase%get('mechanics')
    pl    => mech%get('plasticity')
    if(pl%get_asString('type') == plastic_label) active_plastic(p) = .true.
  enddo

end function plastic_active


!--------------------------------------------------------------------------------------------------
!> @brief returns the 2nd Piola-Kirchhoff stress tensor and its tangent with respect to
!> the elastic and intermediate deformation gradients using Hooke's law
!--------------------------------------------------------------------------------------------------
module subroutine constitutive_hooke_SandItsTangents(S, dS_dFe, dS_dFi, &
                                              Fe, Fi, ipc, ip, el)

  integer, intent(in) :: &
    ipc, &                                                                                          !< component-ID of integration point
    ip, &                                                                                           !< integration point
    el                                                                                              !< element
  real(pReal),   intent(in),  dimension(3,3) :: &
    Fe, &                                                                                           !< elastic deformation gradient
    Fi                                                                                              !< intermediate deformation gradient
  real(pReal),   intent(out), dimension(3,3) :: &
    S                                                                                               !< 2nd Piola-Kirchhoff stress tensor in lattice configuration
  real(pReal),   intent(out), dimension(3,3,3,3) :: &
    dS_dFe, &                                                                                       !< derivative of 2nd P-K stress with respect to elastic deformation gradient
    dS_dFi                                                                                          !< derivative of 2nd P-K stress with respect to intermediate deformation gradient
  real(pReal), dimension(3,3) :: E
  real(pReal), dimension(3,3,3,3) :: C
  integer :: &
    ho, &                                                                                           !< homogenization
    d                                                                                               !< counter in degradation loop
  integer :: &
    i, j

  ho = material_homogenizationAt(el)
  C = math_66toSym3333(constitutive_homogenizedC(ipc,ip,el))

  DegradationLoop: do d = 1, phase_NstiffnessDegradations(material_phaseAt(ipc,el))
    degradationType: select case(phase_stiffnessDegradation(d,material_phaseAt(ipc,el)))
      case (STIFFNESS_DEGRADATION_damage_ID) degradationType
        C = C * damage(ho)%p(material_homogenizationMemberAt(ip,el))**2
    end select degradationType
  enddo DegradationLoop

  E = 0.5_pReal*(matmul(transpose(Fe),Fe)-math_I3)                                                  !< Green-Lagrange strain in unloaded configuration
  S = math_mul3333xx33(C,matmul(matmul(transpose(Fi),E),Fi))                                        !< 2PK stress in lattice configuration in work conjugate with GL strain pulled back to lattice configuration

  do i =1, 3;do j=1,3
    dS_dFe(i,j,1:3,1:3) = matmul(Fe,matmul(matmul(Fi,C(i,j,1:3,1:3)),transpose(Fi)))                !< dS_ij/dFe_kl = C_ijmn * Fi_lm * Fi_on * Fe_ko
    dS_dFi(i,j,1:3,1:3) = 2.0_pReal*matmul(matmul(E,Fi),C(i,j,1:3,1:3))                             !< dS_ij/dFi_kl = C_ijln * E_km * Fe_mn
  enddo; enddo

end subroutine constitutive_hooke_SandItsTangents


!--------------------------------------------------------------------------------------------------
!> @brief calls microstructure function of the different plasticity constitutive models
!--------------------------------------------------------------------------------------------------
module subroutine constitutive_plastic_dependentState(F, Fp, ipc, ip, el)

  integer, intent(in) :: &
    ipc, &                                                                                          !< component-ID of integration point
    ip, &                                                                                           !< integration point
    el                                                                                              !< element
  real(pReal),   intent(in), dimension(3,3) :: &
    F, &                                                                                            !< elastic deformation gradient
    Fp                                                                                              !< plastic deformation gradient

  integer :: &
    ho, &                                                                                           !< homogenization
    tme, &                                                                                          !< thermal member position
    instance, of

  ho  = material_homogenizationAt(el)
  tme = material_homogenizationMemberAt(ip,el)
  of  = material_phasememberAt(ipc,ip,el)
  instance = phase_plasticityInstance(material_phaseAt(ipc,el))

  plasticityType: select case (phase_plasticity(material_phaseAt(ipc,el)))
    case (PLASTICITY_DISLOTWIN_ID) plasticityType
      call plastic_dislotwin_dependentState(temperature(ho)%p(tme),instance,of)
    case (PLASTICITY_DISLOTUNGSTEN_ID) plasticityType
      call plastic_dislotungsten_dependentState(instance,of)
    case (PLASTICITY_NONLOCAL_ID) plasticityType
      call plastic_nonlocal_dependentState (F,Fp,instance,of,ip,el)
  end select plasticityType

end subroutine constitutive_plastic_dependentState


!--------------------------------------------------------------------------------------------------
!> @brief  contains the constitutive equation for calculating the velocity gradient
! ToDo: Discuss whether it makes sense if crystallite handles the configuration conversion, i.e.
! Mp in, dLp_dMp out
!--------------------------------------------------------------------------------------------------
module subroutine constitutive_plastic_LpAndItsTangents(Lp, dLp_dS, dLp_dFi, &
                                     S, Fi, ipc, ip, el)
  integer, intent(in) :: &
    ipc, &                                                                                          !< component-ID of integration point
    ip, &                                                                                           !< integration point
    el                                                                                              !< element
  real(pReal),   intent(in),  dimension(3,3) :: &
    S, &                                                                                            !< 2nd Piola-Kirchhoff stress
    Fi                                                                                              !< intermediate deformation gradient
  real(pReal),   intent(out), dimension(3,3) :: &
    Lp                                                                                              !< plastic velocity gradient
  real(pReal),   intent(out), dimension(3,3,3,3) :: &
    dLp_dS, &
    dLp_dFi                                                                                         !< derivative of Lp with respect to Fi

  real(pReal), dimension(3,3,3,3) :: &
    dLp_dMp                                                                                         !< derivative of Lp with respect to Mandel stress
  real(pReal), dimension(3,3) :: &
    Mp                                                                                              !< Mandel stress work conjugate with Lp
  integer :: &
    ho, &                                                                                           !< homogenization
    tme                                                                                             !< thermal member position
  integer :: &
    i, j, instance, of

  ho = material_homogenizationAt(el)
  tme = material_homogenizationMemberAt(ip,el)

  Mp = matmul(matmul(transpose(Fi),Fi),S)
  of = material_phasememberAt(ipc,ip,el)
  instance = phase_plasticityInstance(material_phaseAt(ipc,el))

  plasticityType: select case (phase_plasticity(material_phaseAt(ipc,el)))

    case (PLASTICITY_NONE_ID) plasticityType
      Lp = 0.0_pReal
      dLp_dMp = 0.0_pReal

    case (PLASTICITY_ISOTROPIC_ID) plasticityType
      call plastic_isotropic_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)

    case (PLASTICITY_PHENOPOWERLAW_ID) plasticityType
      call plastic_phenopowerlaw_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)

    case (PLASTICITY_KINEHARDENING_ID) plasticityType
      call plastic_kinehardening_LpAndItsTangent(Lp,dLp_dMp,Mp,instance,of)

    case (PLASTICITY_NONLOCAL_ID) plasticityType
      call plastic_nonlocal_LpAndItsTangent(Lp,dLp_dMp,Mp, temperature(ho)%p(tme),instance,of,ip,el)

    case (PLASTICITY_DISLOTWIN_ID) plasticityType
      call plastic_dislotwin_LpAndItsTangent(Lp,dLp_dMp,Mp,temperature(ho)%p(tme),instance,of)

    case (PLASTICITY_DISLOTUNGSTEN_ID) plasticityType
      call plastic_dislotungsten_LpAndItsTangent(Lp,dLp_dMp,Mp,temperature(ho)%p(tme),instance,of)

  end select plasticityType

  do i=1,3; do j=1,3
    dLp_dFi(i,j,1:3,1:3) = matmul(matmul(Fi,S),transpose(dLp_dMp(i,j,1:3,1:3))) + &
                           matmul(matmul(Fi,dLp_dMp(i,j,1:3,1:3)),S)
    dLp_dS(i,j,1:3,1:3)  = matmul(matmul(transpose(Fi),Fi),dLp_dMp(i,j,1:3,1:3))                     ! ToDo: @PS: why not:   dLp_dMp:(FiT Fi)
  enddo; enddo

end subroutine constitutive_plastic_LpAndItsTangents


!--------------------------------------------------------------------------------------------------
!> @brief contains the constitutive equation for calculating the rate of change of microstructure
!--------------------------------------------------------------------------------------------------
module function constitutive_collectDotState(FpArray, subdt, ipc, ip, el,phase,of) result(broken)

  integer, intent(in) :: &
    ipc, &                                                                                          !< component-ID of integration point
    ip, &                                                                                           !< integration point
    el, &                                                                                           !< element
    phase, &
    of
  real(pReal),  intent(in) :: &
    subdt                                                                                           !< timestep
  real(pReal),  intent(in), dimension(3,3,homogenization_maxNconstituents,discretization_nIPs,discretization_Nelems) :: &
    FpArray                                                                                         !< plastic deformation gradient
  real(pReal),              dimension(3,3) :: &
    Mp
  integer :: &
    ho, &                                                                                           !< homogenization
    tme, &                                                                                          !< thermal member position
    i, &                                                                                            !< counter in source loop
    instance
  logical :: broken
  ho = material_homogenizationAt(el)
  tme = material_homogenizationMemberAt(ip,el)
  instance = phase_plasticityInstance(phase)

  Mp = matmul(matmul(transpose(constitutive_mech_Fi(phase)%data(1:3,1:3,of)),&
                     constitutive_mech_Fi(phase)%data(1:3,1:3,of)),crystallite_S(1:3,1:3,ipc,ip,el))

  plasticityType: select case (phase_plasticity(phase))

    case (PLASTICITY_ISOTROPIC_ID) plasticityType
      call plastic_isotropic_dotState(Mp,instance,of)

    case (PLASTICITY_PHENOPOWERLAW_ID) plasticityType
      call plastic_phenopowerlaw_dotState(Mp,instance,of)

    case (PLASTICITY_KINEHARDENING_ID) plasticityType
      call plastic_kinehardening_dotState(Mp,instance,of)

    case (PLASTICITY_DISLOTWIN_ID) plasticityType
      call plastic_dislotwin_dotState(Mp,temperature(ho)%p(tme),instance,of)

    case (PLASTICITY_DISLOTUNGSTEN_ID) plasticityType
      call plastic_disloTungsten_dotState(Mp,temperature(ho)%p(tme),instance,of)

    case (PLASTICITY_NONLOCAL_ID) plasticityType
      call plastic_nonlocal_dotState(Mp,crystallite_partitionedF0,FpArray,temperature(ho)%p(tme),subdt, &
                                          instance,of,ip,el)
  end select plasticityType
  broken = any(IEEE_is_NaN(plasticState(phase)%dotState(:,of)))


end function constitutive_collectDotState


!--------------------------------------------------------------------------------------------------
!> @brief for constitutive models having an instantaneous change of state
!> will return false if delta state is not needed/supported by the constitutive model
!--------------------------------------------------------------------------------------------------
module function constitutive_deltaState(S, Fi, ipc, ip, el, phase, of) result(broken)

  integer, intent(in) :: &
    ipc, &                                                                                          !< component-ID of integration point
    ip, &                                                                                           !< integration point
    el, &                                                                                           !< element
    phase, &
    of
  real(pReal),   intent(in), dimension(3,3) :: &
    S, &                                                                                            !< 2nd Piola Kirchhoff stress
    Fi                                                                                              !< intermediate deformation gradient
  real(pReal),               dimension(3,3) :: &
    Mp
  integer :: &
    instance, &
    myOffset, &
    mySize
  logical :: &
    broken

  Mp  = matmul(matmul(transpose(Fi),Fi),S)
  instance = phase_plasticityInstance(phase)

  plasticityType: select case (phase_plasticity(phase))

    case (PLASTICITY_KINEHARDENING_ID) plasticityType
      call plastic_kinehardening_deltaState(Mp,instance,of)
      broken = any(IEEE_is_NaN(plasticState(phase)%deltaState(:,of)))

    case (PLASTICITY_NONLOCAL_ID) plasticityType
      call plastic_nonlocal_deltaState(Mp,instance,of,ip,el)
      broken = any(IEEE_is_NaN(plasticState(phase)%deltaState(:,of)))

    case default
      broken = .false.

  end select plasticityType

  if(.not. broken) then
    select case(phase_plasticity(phase))
      case (PLASTICITY_NONLOCAL_ID,PLASTICITY_KINEHARDENING_ID)

        myOffset = plasticState(phase)%offsetDeltaState
        mySize   = plasticState(phase)%sizeDeltaState
        plasticState(phase)%state(myOffset + 1:myOffset + mySize,of) = &
        plasticState(phase)%state(myOffset + 1:myOffset + mySize,of) + plasticState(phase)%deltaState(1:mySize,of)
    end select
  endif

end function constitutive_deltaState


module subroutine mech_results(group,ph)

  character(len=*), intent(in) :: group
  integer,          intent(in) :: ph

  if (phase_plasticity(ph) /= PLASTICITY_NONE_ID) &
    call results_closeGroup(results_addGroup(group//'plastic/'))

  select case(phase_plasticity(ph))

    case(PLASTICITY_ISOTROPIC_ID)
      call plastic_isotropic_results(phase_plasticityInstance(ph),group//'plastic/')

    case(PLASTICITY_PHENOPOWERLAW_ID)
      call plastic_phenopowerlaw_results(phase_plasticityInstance(ph),group//'plastic/')

    case(PLASTICITY_KINEHARDENING_ID)
      call plastic_kinehardening_results(phase_plasticityInstance(ph),group//'plastic/')

    case(PLASTICITY_DISLOTWIN_ID)
      call plastic_dislotwin_results(phase_plasticityInstance(ph),group//'plastic/')

    case(PLASTICITY_DISLOTUNGSTEN_ID)
      call plastic_dislotungsten_results(phase_plasticityInstance(ph),group//'plastic/')

    case(PLASTICITY_NONLOCAL_ID)
      call plastic_nonlocal_results(phase_plasticityInstance(ph),group//'plastic/')

  end select

  call crystallite_results(group,ph)

end subroutine mech_results

    module subroutine mech_restart_read(fileHandle)
      integer(HID_T), intent(in) :: fileHandle
    end subroutine mech_restart_read


!--------------------------------------------------------------------------------------------------
!> @brief calculation of stress (P) with time integration based on a residuum in Lp and
!> intermediate acceleration of the Newton-Raphson correction
!--------------------------------------------------------------------------------------------------
function integrateStress(ipc,ip,el,timeFraction) result(broken)

  integer, intent(in)::         el, &                                                               ! element index
                                      ip, &                                                         ! integration point index
                                      ipc                                                           ! grain index
  real(pReal), optional, intent(in) :: timeFraction                                                 ! fraction of timestep

  real(pReal), dimension(3,3)::       F, &                                                          ! deformation gradient at end of timestep
                                      Fp_new, &                                                     ! plastic deformation gradient at end of timestep
                                      invFp_new, &                                                  ! inverse of Fp_new
                                      invFp_current, &                                              ! inverse of Fp_current
                                      Lpguess, &                                                    ! current guess for plastic velocity gradient
                                      Lpguess_old, &                                                ! known last good guess for plastic velocity gradient
                                      Lp_constitutive, &                                            ! plastic velocity gradient resulting from constitutive law
                                      residuumLp, &                                                 ! current residuum of plastic velocity gradient
                                      residuumLp_old, &                                             ! last residuum of plastic velocity gradient
                                      deltaLp, &                                                    ! direction of next guess
                                      Fi_new, &                                                     ! gradient of intermediate deformation stages
                                      invFi_new, &
                                      invFi_current, &                                              ! inverse of Fi_current
                                      Liguess, &                                                    ! current guess for intermediate velocity gradient
                                      Liguess_old, &                                                ! known last good guess for intermediate velocity gradient
                                      Li_constitutive, &                                            ! intermediate velocity gradient resulting from constitutive law
                                      residuumLi, &                                                 ! current residuum of intermediate velocity gradient
                                      residuumLi_old, &                                             ! last residuum of intermediate velocity gradient
                                      deltaLi, &                                                    ! direction of next guess
                                      Fe, &                                                         ! elastic deformation gradient
                                      S, &                                                          ! 2nd Piola-Kirchhoff Stress in plastic (lattice) configuration
                                      A, &
                                      B, &
                                      temp_33
  real(pReal), dimension(9) ::        temp_9                                                        ! needed for matrix inversion by LAPACK
  integer,     dimension(9) ::        devNull_9                                                     ! needed for matrix inversion by LAPACK
  real(pReal), dimension(9,9) ::      dRLp_dLp, &                                                   ! partial derivative of residuum (Jacobian for Newton-Raphson scheme)
                                      dRLi_dLi                                                      ! partial derivative of residuumI (Jacobian for Newton-Raphson scheme)
  real(pReal), dimension(3,3,3,3)::   dS_dFe, &                                                     ! partial derivative of 2nd Piola-Kirchhoff stress
                                      dS_dFi, &
                                      dFe_dLp, &                                                    ! partial derivative of elastic deformation gradient
                                      dFe_dLi, &
                                      dFi_dLi, &
                                      dLp_dFi, &
                                      dLi_dFi, &
                                      dLp_dS, &
                                      dLi_dS
  real(pReal)                         steplengthLp, &
                                      steplengthLi, &
                                      dt, &                                                         ! time increment
                                      atol_Lp, &
                                      atol_Li, &
                                      devNull
  integer                             NiterationStressLp, &                                         ! number of stress integrations
                                      NiterationStressLi, &                                         ! number of inner stress integrations
                                      ierr, &                                                       ! error indicator for LAPACK
                                      o, &
                                      p, &
                                      m, &
                                      jacoCounterLp, &
                                      jacoCounterLi                                                 ! counters to check for Jacobian update
  logical :: error,broken

  broken = .true.

  if (present(timeFraction)) then
    dt = crystallite_subdt(ipc,ip,el) * timeFraction
    F  = crystallite_subF0(1:3,1:3,ipc,ip,el) &
       + (crystallite_subF(1:3,1:3,ipc,ip,el) - crystallite_subF0(1:3,1:3,ipc,ip,el)) * timeFraction
  else
    dt = crystallite_subdt(ipc,ip,el)
    F  = crystallite_subF(1:3,1:3,ipc,ip,el)
  endif

  call constitutive_plastic_dependentState(crystallite_partitionedF(1:3,1:3,ipc,ip,el), &
                                   crystallite_Fp(1:3,1:3,ipc,ip,el),ipc,ip,el)

  p = material_phaseAt(ipc,el)
  m = material_phaseMemberAt(ipc,ip,el)

  Lpguess = crystallite_Lp(1:3,1:3,ipc,ip,el)                                                       ! take as first guess
  Liguess = constitutive_mech_Li(p)%data(1:3,1:3,m)                                                      ! take as first guess

  call math_invert33(invFp_current,devNull,error,crystallite_subFp0(1:3,1:3,ipc,ip,el))
  if (error) return ! error
  call math_invert33(invFi_current,devNull,error,crystallite_subFi0(1:3,1:3,ipc,ip,el))
  if (error) return ! error

  A = matmul(F,invFp_current)                                                                       ! intermediate tensor needed later to calculate dFe_dLp

  jacoCounterLi  = 0
  steplengthLi   = 1.0_pReal
  residuumLi_old = 0.0_pReal
  Liguess_old    = Liguess

  NiterationStressLi = 0
  LiLoop: do
    NiterationStressLi = NiterationStressLi + 1
    if (NiterationStressLi>num%nStress) return ! error

    invFi_new = matmul(invFi_current,math_I3 - dt*Liguess)
    Fi_new    = math_inv33(invFi_new)

    jacoCounterLp  = 0
    steplengthLp   = 1.0_pReal
    residuumLp_old = 0.0_pReal
    Lpguess_old    = Lpguess

    NiterationStressLp = 0
    LpLoop: do
      NiterationStressLp = NiterationStressLp + 1
      if (NiterationStressLp>num%nStress) return ! error

      B  = math_I3 - dt*Lpguess
      Fe = matmul(matmul(A,B), invFi_new)
      call constitutive_hooke_SandItsTangents(S, dS_dFe, dS_dFi, &
                                        Fe, Fi_new, ipc, ip, el)

      call constitutive_plastic_LpAndItsTangents(Lp_constitutive, dLp_dS, dLp_dFi, &
                                         S, Fi_new, ipc, ip, el)

      !* update current residuum and check for convergence of loop
      atol_Lp = max(num%rtol_crystalliteStress * max(norm2(Lpguess),norm2(Lp_constitutive)), &      ! absolute tolerance from largest acceptable relative error
                    num%atol_crystalliteStress)                                                     ! minimum lower cutoff
      residuumLp = Lpguess - Lp_constitutive

      if (any(IEEE_is_NaN(residuumLp))) then
        return ! error
      elseif (norm2(residuumLp) < atol_Lp) then                                                     ! converged if below absolute tolerance
        exit LpLoop
      elseif (NiterationStressLp == 1 .or. norm2(residuumLp) < norm2(residuumLp_old)) then          ! not converged, but improved norm of residuum (always proceed in first iteration)...
        residuumLp_old = residuumLp                                                                 ! ...remember old values and...
        Lpguess_old    = Lpguess
        steplengthLp   = 1.0_pReal                                                                  ! ...proceed with normal step length (calculate new search direction)
      else                                                                                          ! not converged and residuum not improved...
        steplengthLp = num%subStepSizeLp * steplengthLp                                             ! ...try with smaller step length in same direction
        Lpguess      = Lpguess_old &
                     + deltaLp * stepLengthLp
        cycle LpLoop
      endif

      calculateJacobiLi: if (mod(jacoCounterLp, num%iJacoLpresiduum) == 0) then
        jacoCounterLp = jacoCounterLp + 1

        do o=1,3; do p=1,3
          dFe_dLp(o,1:3,p,1:3) = - dt * A(o,p)*transpose(invFi_new)                                 ! dFe_dLp(i,j,k,l) = -dt * A(i,k) invFi(l,j)
        enddo; enddo
        dRLp_dLp = math_eye(9) &
                 - math_3333to99(math_mul3333xx3333(math_mul3333xx3333(dLp_dS,dS_dFe),dFe_dLp))
        temp_9 = math_33to9(residuumLp)
        call dgesv(9,1,dRLp_dLp,9,devNull_9,temp_9,9,ierr)                                          ! solve dRLp/dLp * delta Lp = -res for delta Lp
        if (ierr /= 0) return ! error
        deltaLp = - math_9to33(temp_9)
      endif calculateJacobiLi

      Lpguess = Lpguess &
              + deltaLp * steplengthLp
    enddo LpLoop

    call constitutive_LiAndItsTangents(Li_constitutive, dLi_dS, dLi_dFi, &
                                       S, Fi_new, ipc, ip, el)

    !* update current residuum and check for convergence of loop
    atol_Li = max(num%rtol_crystalliteStress * max(norm2(Liguess),norm2(Li_constitutive)), &        ! absolute tolerance from largest acceptable relative error
                  num%atol_crystalliteStress)                                                       ! minimum lower cutoff
    residuumLi = Liguess - Li_constitutive
    if (any(IEEE_is_NaN(residuumLi))) then
      return ! error
    elseif (norm2(residuumLi) < atol_Li) then                                                       ! converged if below absolute tolerance
      exit LiLoop
    elseif (NiterationStressLi == 1 .or. norm2(residuumLi) < norm2(residuumLi_old)) then            ! not converged, but improved norm of residuum (always proceed in first iteration)...
      residuumLi_old = residuumLi                                                                   ! ...remember old values and...
      Liguess_old    = Liguess
      steplengthLi   = 1.0_pReal                                                                    ! ...proceed with normal step length (calculate new search direction)
    else                                                                                            ! not converged and residuum not improved...
      steplengthLi = num%subStepSizeLi * steplengthLi                                               ! ...try with smaller step length in same direction
      Liguess      = Liguess_old &
                   + deltaLi * steplengthLi
      cycle LiLoop
    endif

    calculateJacobiLp: if (mod(jacoCounterLi, num%iJacoLpresiduum) == 0) then
      jacoCounterLi = jacoCounterLi + 1

      temp_33 = matmul(matmul(A,B),invFi_current)
      do o=1,3; do p=1,3
        dFe_dLi(1:3,o,1:3,p) = -dt*math_I3(o,p)*temp_33                                             ! dFe_dLp(i,j,k,l) = -dt * A(i,k) invFi(l,j)
        dFi_dLi(1:3,o,1:3,p) = -dt*math_I3(o,p)*invFi_current
      enddo; enddo
      do o=1,3; do p=1,3
        dFi_dLi(1:3,1:3,o,p) = matmul(matmul(Fi_new,dFi_dLi(1:3,1:3,o,p)),Fi_new)
      enddo; enddo
      dRLi_dLi  = math_eye(9) &
                - math_3333to99(math_mul3333xx3333(dLi_dS,  math_mul3333xx3333(dS_dFe, dFe_dLi) &
                                                          + math_mul3333xx3333(dS_dFi, dFi_dLi)))  &
                - math_3333to99(math_mul3333xx3333(dLi_dFi, dFi_dLi))
      temp_9 = math_33to9(residuumLi)
      call dgesv(9,1,dRLi_dLi,9,devNull_9,temp_9,9,ierr)                                            ! solve dRLi/dLp * delta Li = -res for delta Li
      if (ierr /= 0) return ! error
      deltaLi = - math_9to33(temp_9)
    endif calculateJacobiLp

    Liguess = Liguess &
            + deltaLi * steplengthLi
  enddo LiLoop

  invFp_new = matmul(invFp_current,B)
  call math_invert33(Fp_new,devNull,error,invFp_new)
  if (error) return ! error

  p = material_phaseAt(ipc,el)
  m = material_phaseMemberAt(ipc,ip,el)

  crystallite_P    (1:3,1:3,ipc,ip,el) = matmul(matmul(F,invFp_new),matmul(S,transpose(invFp_new)))
  crystallite_S    (1:3,1:3,ipc,ip,el) = S
  crystallite_Lp   (1:3,1:3,ipc,ip,el) = Lpguess
  constitutive_mech_Li(p)%data(1:3,1:3,m) = Liguess
  crystallite_Fp   (1:3,1:3,ipc,ip,el) = Fp_new / math_det33(Fp_new)**(1.0_pReal/3.0_pReal)         ! regularize
  constitutive_mech_Fi(p)%data(1:3,1:3,m) = Fi_new
  crystallite_Fe   (1:3,1:3,ipc,ip,el) = matmul(matmul(F,invFp_new),invFi_new)
  broken = .false.

end function integrateStress


!--------------------------------------------------------------------------------------------------
!> @brief integrate stress, state with adaptive 1st order explicit Euler method
!> using Fixed Point Iteration to adapt the stepsize
!--------------------------------------------------------------------------------------------------
module subroutine integrateStateFPI(g,i,e)

  integer, intent(in) :: &
    e, &                                                                                            !< element index in element loop
    i, &                                                                                            !< integration point index in ip loop
    g                                                                                               !< grain index in grain loop
  integer :: &
    NiterationState, &                                                                              !< number of iterations in state loop
    p, &
    c, &
    s, &
    size_pl
  integer, dimension(maxval(phase_Nsources)) :: &
    size_so
  real(pReal) :: &
    zeta
  real(pReal), dimension(max(constitutive_plasticity_maxSizeDotState,constitutive_source_maxSizeDotState)) :: &
    r                                                                                               ! state residuum
  real(pReal), dimension(constitutive_plasticity_maxSizeDotState,2) :: &
    plastic_dotState
  real(pReal), dimension(constitutive_source_maxSizeDotState,2,maxval(phase_Nsources)) :: source_dotState
  logical :: &
    broken

  p = material_phaseAt(g,e)
  c = material_phaseMemberAt(g,i,e)

  broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                        crystallite_subdt(g,i,e), g,i,e,p,c)
  if(broken) return

  size_pl = plasticState(p)%sizeDotState
  plasticState(p)%state(1:size_pl,c) = plasticState(p)%subState0(1:size_pl,c) &
                                     + plasticState(p)%dotState (1:size_pl,c) &
                                     * crystallite_subdt(g,i,e)
  plastic_dotState(1:size_pl,2) = 0.0_pReal

  iteration: do NiterationState = 1, num%nState

    if(nIterationState > 1) plastic_dotState(1:size_pl,2) = plastic_dotState(1:size_pl,1)
    plastic_dotState(1:size_pl,1) = plasticState(p)%dotState(:,c)

    broken = integrateStress(g,i,e)
    if(broken) exit iteration

    broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                          crystallite_subdt(g,i,e), g,i,e,p,c)
    if(broken) exit iteration

    zeta = damper(plasticState(p)%dotState(:,c),plastic_dotState(1:size_pl,1),&
                                                plastic_dotState(1:size_pl,2))
    plasticState(p)%dotState(:,c) = plasticState(p)%dotState(:,c) * zeta &
                                  + plastic_dotState(1:size_pl,1) * (1.0_pReal - zeta)
    r(1:size_pl) = plasticState(p)%state    (1:size_pl,c) &
                 - plasticState(p)%subState0(1:size_pl,c)  &
                 - plasticState(p)%dotState (1:size_pl,c) * crystallite_subdt(g,i,e)
    plasticState(p)%state(1:size_pl,c) = plasticState(p)%state(1:size_pl,c) &
                                       - r(1:size_pl)
    crystallite_converged(g,i,e) = converged(r(1:size_pl), &
                                             plasticState(p)%state(1:size_pl,c), &
                                             plasticState(p)%atol(1:size_pl))

    if(crystallite_converged(g,i,e)) then
      broken = constitutive_deltaState(crystallite_S(1:3,1:3,g,i,e), &
                                       constitutive_mech_Fi(p)%data(1:3,1:3,c),g,i,e,p,c)
      exit iteration
    endif

  enddo iteration


  contains

  !--------------------------------------------------------------------------------------------------
  !> @brief calculate the damping for correction of state and dot state
  !--------------------------------------------------------------------------------------------------
  real(pReal) pure function damper(current,previous,previous2)

  real(pReal), dimension(:), intent(in) ::&
    current, previous, previous2

  real(pReal) :: dot_prod12, dot_prod22

  dot_prod12 = dot_product(current  - previous,  previous - previous2)
  dot_prod22 = dot_product(previous - previous2, previous - previous2)
  if ((dot_product(current,previous) < 0.0_pReal .or. dot_prod12 < 0.0_pReal) .and. dot_prod22 > 0.0_pReal) then
    damper = 0.75_pReal + 0.25_pReal * tanh(2.0_pReal + 4.0_pReal * dot_prod12 / dot_prod22)
  else
    damper = 1.0_pReal
  endif

  end function damper

end subroutine integrateStateFPI


!--------------------------------------------------------------------------------------------------
!> @brief integrate state with 1st order explicit Euler method
!--------------------------------------------------------------------------------------------------
module subroutine integrateStateEuler(g,i,e)

  integer, intent(in) :: &
    e, &                                                                                            !< element index in element loop
    i, &                                                                                            !< integration point index in ip loop
    g                                                                                               !< grain index in grain loop
  integer :: &
    p, &
    c, &
    sizeDotState
  logical :: &
    broken

  p = material_phaseAt(g,e)
  c = material_phaseMemberAt(g,i,e)

  broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                    crystallite_subdt(g,i,e), g,i,e,p,c)
  if(broken) return

  sizeDotState = plasticState(p)%sizeDotState
  plasticState(p)%state(1:sizeDotState,c) = plasticState(p)%subState0(1:sizeDotState,c) &
                                          + plasticState(p)%dotState (1:sizeDotState,c) &
                                            * crystallite_subdt(g,i,e)

  broken = constitutive_deltaState(crystallite_S(1:3,1:3,g,i,e), &
                                   constitutive_mech_Fi(p)%data(1:3,1:3,c),g,i,e,p,c)
  if(broken) return

  broken = integrateStress(g,i,e)
  crystallite_converged(g,i,e) = .not. broken

end subroutine integrateStateEuler


!--------------------------------------------------------------------------------------------------
!> @brief integrate stress, state with 1st order Euler method with adaptive step size
!--------------------------------------------------------------------------------------------------
module subroutine integrateStateAdaptiveEuler(g,i,e)

  integer, intent(in) :: &
    e, &                                                                                            !< element index in element loop
    i, &                                                                                            !< integration point index in ip loop
    g                                                                                               !< grain index in grain loop
  integer :: &
    p, &
    c, &
    sizeDotState
  logical :: &
    broken

  real(pReal), dimension(constitutive_plasticity_maxSizeDotState) :: residuum_plastic


  p = material_phaseAt(g,e)
  c = material_phaseMemberAt(g,i,e)

  broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                        crystallite_subdt(g,i,e), g,i,e,p,c)
  if(broken) return

  sizeDotState = plasticState(p)%sizeDotState

  residuum_plastic(1:sizeDotState) = - plasticState(p)%dotstate(1:sizeDotState,c) * 0.5_pReal * crystallite_subdt(g,i,e)
  plasticState(p)%state(1:sizeDotState,c) = plasticState(p)%subState0(1:sizeDotState,c) &
                                          + plasticState(p)%dotstate(1:sizeDotState,c) * crystallite_subdt(g,i,e)

  broken = constitutive_deltaState(crystallite_S(1:3,1:3,g,i,e), &
                                   constitutive_mech_Fi(p)%data(1:3,1:3,c),g,i,e,p,c)
  if(broken) return

  broken = integrateStress(g,i,e)
  if(broken) return

  broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                        crystallite_subdt(g,i,e), g,i,e,p,c)
  if(broken) return


  sizeDotState = plasticState(p)%sizeDotState
  crystallite_converged(g,i,e) = converged(residuum_plastic(1:sizeDotState) &
                                           + 0.5_pReal * plasticState(p)%dotState(:,c) * crystallite_subdt(g,i,e), &
                                           plasticState(p)%state(1:sizeDotState,c), &
                                           plasticState(p)%atol(1:sizeDotState))

end subroutine integrateStateAdaptiveEuler


!---------------------------------------------------------------------------------------------------
!> @brief Integrate state (including stress integration) with the classic Runge Kutta method
!---------------------------------------------------------------------------------------------------
module subroutine integrateStateRK4(g,i,e)

  integer, intent(in) :: g,i,e

  real(pReal), dimension(3,3), parameter :: &
    A = reshape([&
      0.5_pReal, 0.0_pReal, 0.0_pReal, &
      0.0_pReal, 0.5_pReal, 0.0_pReal, &
      0.0_pReal, 0.0_pReal, 1.0_pReal],&
      shape(A))
  real(pReal), dimension(3), parameter :: &
    C = [0.5_pReal, 0.5_pReal, 1.0_pReal]
  real(pReal), dimension(4), parameter :: &
    B = [1.0_pReal/6.0_pReal, 1.0_pReal/3.0_pReal, 1.0_pReal/3.0_pReal, 1.0_pReal/6.0_pReal]

  call integrateStateRK(g,i,e,A,B,C)

end subroutine integrateStateRK4


!---------------------------------------------------------------------------------------------------
!> @brief Integrate state (including stress integration) with the Cash-Carp method
!---------------------------------------------------------------------------------------------------
module subroutine integrateStateRKCK45(g,i,e)

  integer, intent(in) :: g,i,e

  real(pReal), dimension(5,5), parameter :: &
    A = reshape([&
      1._pReal/5._pReal,       .0_pReal,             .0_pReal,               .0_pReal,                  .0_pReal, &
      3._pReal/40._pReal,      9._pReal/40._pReal,   .0_pReal,               .0_pReal,                  .0_pReal, &
      3_pReal/10._pReal,       -9._pReal/10._pReal,  6._pReal/5._pReal,      .0_pReal,                  .0_pReal, &
      -11._pReal/54._pReal,    5._pReal/2._pReal,    -70.0_pReal/27.0_pReal, 35.0_pReal/27.0_pReal,     .0_pReal, &
      1631._pReal/55296._pReal,175._pReal/512._pReal,575._pReal/13824._pReal,44275._pReal/110592._pReal,253._pReal/4096._pReal],&
      shape(A))
  real(pReal), dimension(5), parameter :: &
    C = [0.2_pReal, 0.3_pReal, 0.6_pReal, 1.0_pReal, 0.875_pReal]
  real(pReal), dimension(6), parameter :: &
    B = &
      [37.0_pReal/378.0_pReal, .0_pReal, 250.0_pReal/621.0_pReal, &
      125.0_pReal/594.0_pReal, .0_pReal, 512.0_pReal/1771.0_pReal], &
    DB = B - &
      [2825.0_pReal/27648.0_pReal,    .0_pReal,                18575.0_pReal/48384.0_pReal,&
      13525.0_pReal/55296.0_pReal, 277.0_pReal/14336.0_pReal,  1._pReal/4._pReal]

  call integrateStateRK(g,i,e,A,B,C,DB)

end subroutine integrateStateRKCK45


!--------------------------------------------------------------------------------------------------
!> @brief Integrate state (including stress integration) with an explicit Runge-Kutta method or an
!! embedded explicit Runge-Kutta method
!--------------------------------------------------------------------------------------------------
subroutine integrateStateRK(g,i,e,A,B,CC,DB)


  real(pReal), dimension(:,:), intent(in) :: A
  real(pReal), dimension(:),   intent(in) :: B, CC
  real(pReal), dimension(:),   intent(in), optional :: DB

  integer, intent(in) :: &
    e, &                                                                                            !< element index in element loop
    i, &                                                                                            !< integration point index in ip loop
    g                                                                                               !< grain index in grain loop
  integer :: &
    stage, &                                                                                        ! stage index in integration stage loop
    n, &
    p, &
    c, &
    sizeDotState
  logical :: &
    broken
  real(pReal), dimension(constitutive_plasticity_maxSizeDotState,size(B))                    :: plastic_RKdotState

  p = material_phaseAt(g,e)
  c = material_phaseMemberAt(g,i,e)

  broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                        crystallite_subdt(g,i,e), g,i,e,p,c)
  if(broken) return

  do stage = 1,size(A,1)
    sizeDotState = plasticState(p)%sizeDotState
    plastic_RKdotState(1:sizeDotState,stage) = plasticState(p)%dotState(:,c)
    plasticState(p)%dotState(:,c) = A(1,stage) * plastic_RKdotState(1:sizeDotState,1)

    do n = 2, stage
      sizeDotState = plasticState(p)%sizeDotState
      plasticState(p)%dotState(:,c) = plasticState(p)%dotState(:,c) &
                                    + A(n,stage) * plastic_RKdotState(1:sizeDotState,n)
    enddo

    sizeDotState = plasticState(p)%sizeDotState
    plasticState(p)%state(1:sizeDotState,c) = plasticState(p)%subState0(1:sizeDotState,c) &
                                            + plasticState(p)%dotState (1:sizeDotState,c) &
                                              * crystallite_subdt(g,i,e)

    broken = integrateStress(g,i,e,CC(stage))
    if(broken) exit

    broken = constitutive_collectDotState(crystallite_partitionedFp0, &
                                          crystallite_subdt(g,i,e)*CC(stage), g,i,e,p,c)
    if(broken) exit

  enddo
  if(broken) return

  sizeDotState = plasticState(p)%sizeDotState

  plastic_RKdotState(1:sizeDotState,size(B)) = plasticState (p)%dotState(:,c)
  plasticState(p)%dotState(:,c) = matmul(plastic_RKdotState(1:sizeDotState,1:size(B)),B)
  plasticState(p)%state(1:sizeDotState,c) = plasticState(p)%subState0(1:sizeDotState,c) &
                                          + plasticState(p)%dotState (1:sizeDotState,c) &
                                            * crystallite_subdt(g,i,e)
  if(present(DB)) &
    broken = .not. converged( matmul(plastic_RKdotState(1:sizeDotState,1:size(DB)),DB) &
                                             * crystallite_subdt(g,i,e), &
                                        plasticState(p)%state(1:sizeDotState,c), &
                                        plasticState(p)%atol(1:sizeDotState))

  if(broken) return

  broken = constitutive_deltaState(crystallite_S(1:3,1:3,g,i,e), &
                                   constitutive_mech_Fi(p)%data(1:3,1:3,c),g,i,e,p,c)
  if(broken) return

  broken = integrateStress(g,i,e)
  crystallite_converged(g,i,e) = .not. broken


end subroutine integrateStateRK



!--------------------------------------------------------------------------------------------------
!> @brief writes crystallite results to HDF5 output file
!--------------------------------------------------------------------------------------------------
subroutine crystallite_results(group,ph)

  character(len=*), intent(in) :: group
  integer,          intent(in) :: ph

  integer :: ou
  real(pReal), allocatable, dimension(:,:,:) :: selected_tensors
  real(pReal), allocatable, dimension(:,:)   :: selected_rotations
  character(len=:), allocatable              :: structureLabel


    call results_closeGroup(results_addGroup(group//'/mechanics/'))

    do ou = 1, size(output_constituent(ph)%label)

      select case (output_constituent(ph)%label(ou))
        case('F')
          selected_tensors = select_tensors(crystallite_partitionedF,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'deformation gradient','1')
        case('F_e')
          selected_tensors = select_tensors(crystallite_Fe,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'elastic deformation gradient','1')
        case('F_p')
          selected_tensors = select_tensors(crystallite_Fp,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'plastic deformation gradient','1')
        case('F_i')
          call results_writeDataset(group//'/mechanics/',constitutive_mech_Fi(ph)%data,output_constituent(ph)%label(ou),&
                                   'inelastic deformation gradient','1')
        case('L_p')
          selected_tensors = select_tensors(crystallite_Lp,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'plastic velocity gradient','1/s')
        case('L_i')
          call results_writeDataset(group//'/mechanics/',constitutive_mech_Li(ph)%data,output_constituent(ph)%label(ou),&
                                   'inelastic velocity gradient','1/s')
        case('P')
          selected_tensors = select_tensors(crystallite_P,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'First Piola-Kirchhoff stress','Pa')
        case('S')
          selected_tensors = select_tensors(crystallite_S,ph)
          call results_writeDataset(group//'/mechanics/',selected_tensors,output_constituent(ph)%label(ou),&
                                   'Second Piola-Kirchhoff stress','Pa')
        case('O')
          select case(lattice_structure(ph))
            case(lattice_ISO_ID)
              structureLabel = 'aP'
            case(lattice_FCC_ID)
              structureLabel = 'cF'
            case(lattice_BCC_ID)
              structureLabel = 'cI'
            case(lattice_BCT_ID)
              structureLabel = 'tI'
            case(lattice_HEX_ID)
              structureLabel = 'hP'
            case(lattice_ORT_ID)
              structureLabel = 'oP'
          end select
          selected_rotations = select_rotations(crystallite_orientation,ph)
          call results_writeDataset(group//'/mechanics/',selected_rotations,output_constituent(ph)%label(ou),&
                                   'crystal orientation as quaternion','q_0 (q_1 q_2 q_3)')
          call results_addAttribute('Lattice',structureLabel,group//'/mechanics/'//output_constituent(ph)%label(ou))
      end select
    enddo


  contains

  !------------------------------------------------------------------------------------------------
  !> @brief select tensors for output
  !------------------------------------------------------------------------------------------------
  function select_tensors(dataset,instance)

    integer, intent(in) :: instance
    real(pReal), dimension(:,:,:,:,:), intent(in) :: dataset
    real(pReal), allocatable, dimension(:,:,:) :: select_tensors
    integer :: e,i,c,j

    allocate(select_tensors(3,3,count(material_phaseAt==instance)*discretization_nIPs))

    j=0
    do e = 1, size(material_phaseAt,2)
      do i = 1, discretization_nIPs
        do c = 1, size(material_phaseAt,1)                                                          !ToDo: this needs to be changed for varying Ngrains
          if (material_phaseAt(c,e) == instance) then
            j = j + 1
            select_tensors(1:3,1:3,j) = dataset(1:3,1:3,c,i,e)
          endif
        enddo
      enddo
    enddo

  end function select_tensors


!--------------------------------------------------------------------------------------------------
!> @brief select rotations for output
!--------------------------------------------------------------------------------------------------
  function select_rotations(dataset,instance)

    integer, intent(in) :: instance
    type(rotation), dimension(:,:,:), intent(in) :: dataset
    real(pReal), allocatable, dimension(:,:) :: select_rotations
    integer :: e,i,c,j

    allocate(select_rotations(4,count(material_phaseAt==instance)*homogenization_maxNconstituents*discretization_nIPs))

    j=0
    do e = 1, size(material_phaseAt,2)
      do i = 1, discretization_nIPs
        do c = 1, size(material_phaseAt,1)                                                          !ToDo: this needs to be changed for varying Ngrains
           if (material_phaseAt(c,e) == instance) then
             j = j + 1
             select_rotations(1:4,j) = dataset(c,i,e)%asQuaternion()
           endif
        enddo
      enddo
   enddo

 end function select_rotations

end subroutine crystallite_results


end submodule constitutive_mech

