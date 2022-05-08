!--------------------------------------------------------------------------------------------------
!> @author Martin Diehl, KU Leuven
!> @brief Polynomial representation for variable data
!--------------------------------------------------------------------------------------------------
module polynomials
  use prec
  use IO
  use YAML_parse
  use YAML_types

  implicit none
  private

  type, public :: tPolynomial
    real(pReal), dimension(:), allocatable :: coef
    real(pReal) :: x_ref = huge(0.0_pReal)
    contains
    procedure, public :: at => eval
    procedure, public :: der1_at => eval_der1
  end type tPolynomial

  interface polynomial
    module procedure polynomial_from_dict
    module procedure polynomial_from_coef
  end interface polynomial

  public :: &
    polynomial, &
    polynomials_init

contains


!--------------------------------------------------------------------------------------------------
!> @brief Run self-test.
!--------------------------------------------------------------------------------------------------
subroutine polynomials_init()

  print'(/,1x,a)', '<<<+-  polynomials init  -+>>>'; flush(IO_STDOUT)

  call selfTest()

end subroutine polynomials_init


!--------------------------------------------------------------------------------------------------
!> @brief Initialize a Polynomial from Coefficients.
!--------------------------------------------------------------------------------------------------
pure function polynomial_from_coef(coef,x_ref) result(p)

  real(pReal), dimension(0:), intent(in) :: coef
  real(pReal), intent(in) :: x_ref
  type(tPolynomial) :: p


  p%coef = coef
  p%x_ref = x_ref

end function polynomial_from_coef


!--------------------------------------------------------------------------------------------------
!> @brief Initialize a Polynomial from a Dictionary with Coefficients.
!--------------------------------------------------------------------------------------------------
function polynomial_from_dict(dict,y,x) result(p)

  type(tDict), intent(in) :: dict
  character(len=*), intent(in) :: y, x
  type(tPolynomial) :: p

  real(pReal), dimension(:), allocatable :: coef
  real(pReal) :: x_ref
  integer :: i, o
  character(len=1) :: o_s


  allocate(coef(1),source=dict%get_asFloat(y))

  if (dict%contains(y//','//x)) then
    x_ref = dict%get_asFloat(x//'_ref')
    coef = [coef,dict%get_asFloat(y//','//x)]
  end if
  do o = 2,4
    write(o_s,'(I0.0)') o
    if (dict%contains(y//','//x//'^'//o_s)) then
      x_ref = dict%get_asFloat(x//'_ref')
      coef = [coef,[(0.0_pReal,i=size(coef),o-1)],dict%get_asFloat(y//','//x//'^'//o_s)]
    end if
  end do

  p = Polynomial(coef,x_ref)

end function polynomial_from_dict


!--------------------------------------------------------------------------------------------------
!> @brief Evaluate a Polynomial.
!--------------------------------------------------------------------------------------------------
pure function eval(self,x) result(y)

  class(tPolynomial), intent(in) :: self
  real(pReal), intent(in) :: x
  real(pReal) :: y

  integer :: i


  y = 0.0_pReal
  do i = ubound(self%coef,1), 0, -1
#ifndef __INTEL_COMPILER
    y = y*(x-self%x_ref) +self%coef(i)
#else
    y = IEEE_FMA(y,x-self%x_ref,self%coef(i))
#endif
  enddo

end function eval


!--------------------------------------------------------------------------------------------------
!> @brief Evaluate a first derivative of Polynomial.
!--------------------------------------------------------------------------------------------------
pure function eval_der1(self,x) result(y)

  class(tPolynomial), intent(in) :: self
  real(pReal), intent(in) :: x
  real(pReal) :: y

  integer :: i


  y = 0.0_pReal
  do i = 1, ubound(self%coef,1)
    y = y + real(i,pReal)*self%coef(i) * (x-self%x_ref)**(i-1)
  enddo

end function eval_der1


!--------------------------------------------------------------------------------------------------
!> @brief Check correctness of polynomical functionality.
!--------------------------------------------------------------------------------------------------
subroutine selfTest()

  type(tPolynomial) :: p1, p2
  real(pReal), dimension(5) :: coef
  integer :: i
  real(pReal) :: x_ref, x, y
  class(tNode), pointer :: dict
  character(len=pStringLen), dimension(size(coef)) :: coef_s
  character(len=pStringLen) :: x_ref_s, x_s, YAML_s


  call random_number(coef)
  call random_number(x_ref)
  call random_number(x)

  coef = coef*10_pReal -0.5_pReal
  x_ref = x_ref*10_pReal -0.5_pReal
  x = x*10_pReal -0.5_pReal

  p1 = polynomial([coef(1)],x_ref)
  if (dNeq(p1%at(x),coef(1)))      error stop 'polynomial: eval(constant)'

  p1 = polynomial(coef,x_ref)
  if (dNeq(p1%at(x_ref),coef(1)))  error stop 'polynomial: @ref'

  do i = 1, size(coef_s)
    write(coef_s(i),*) coef(i)
  end do
  write(x_ref_s,*) x_ref
  write(x_s,*) x
  YAML_s = 'C: '//trim(adjustl(coef_s(1)))//IO_EOL//&
           'C,T: '//trim(adjustl(coef_s(2)))//IO_EOL//&
           'C,T^2: '//trim(adjustl(coef_s(3)))//IO_EOL//&
           'C,T^3: '//trim(adjustl(coef_s(4)))//IO_EOL//&
           'C,T^4: '//trim(adjustl(coef_s(5)))//IO_EOL//&
           'T_ref: '//trim(adjustl(x_ref_s))//IO_EOL
  Dict => YAML_parse_str(trim(YAML_s))
  p2 = polynomial(dict%asDict(),'C','T')
  if (dNeq(p1%at(x),p2%at(x),1.0e-10_pReal))                      error stop 'polynomials: init'
  y = coef(1)+coef(2)*(x-x_ref)+coef(3)*(x-x_ref)**2+coef(4)*(x-x_ref)**3+coef(5)*(x-x_ref)**4
  if (dNeq(p1%at(x),y,1.0e-7_pReal))                             error stop 'polynomials: eval(full)'

  YAML_s = 'C: 0.0'//IO_EOL//&
           'C,T: '//trim(adjustl(coef_s(2)))//IO_EOL//&
           'T_ref: '//trim(adjustl(x_ref_s))//IO_EOL
  Dict => YAML_parse_str(trim(YAML_s))
  p1 = polynomial(dict%asDict(),'C','T')
  if (dNeq(p1%at(x_ref+x),-p1%at(x_ref-x),1.0e-10_pReal))         error stop 'polynomials: eval(linear)'
  if (dNeq(p1%der1_at(x),p1%der1_at(5.0_pReal*x),1.0e-10_pReal))  error stop 'polynomials: eval_der(linear)'

  YAML_s = 'C: 0.0'//IO_EOL//&
           'C,T^2: '//trim(adjustl(coef_s(3)))//IO_EOL//&
           'T_ref: '//trim(adjustl(x_ref_s))//IO_EOL
  Dict => YAML_parse_str(trim(YAML_s))
  p1 = polynomial(dict%asDict(),'C','T')
  if (dNeq(p1%at(x_ref+x),p1%at(x_ref-x),1e-10_pReal))            error stop 'polynomials: eval(quadratic)'
  if (dNeq(p1%der1_at(x_ref+x),-p1%der1_at(x_ref-x),1e-10_pReal)) error stop 'polynomials: eval_der(quadratic)'

  YAML_s = 'Y: '//trim(adjustl(coef_s(1)))//IO_EOL//&
           'Y,X^3: '//trim(adjustl(coef_s(2)))//IO_EOL//&
           'X_ref: '//trim(adjustl(x_ref_s))//IO_EOL
  Dict => YAML_parse_str(trim(YAML_s))
  p1 = polynomial(dict%asDict(),'Y','X')
  if (dNeq(p1%at(x_ref+x)-coef(1),-(p1%at(x_ref-x)-coef(1)),1.0e-8_pReal))          error stop 'polynomials: eval(cubic)'

  YAML_s = 'Y: '//trim(adjustl(coef_s(1)))//IO_EOL//&
           'Y,X^4: '//trim(adjustl(coef_s(2)))//IO_EOL//&
           'X_ref: '//trim(adjustl(x_ref_s))//IO_EOL
  Dict => YAML_parse_str(trim(YAML_s))
  p1 = polynomial(dict%asDict(),'Y','X')
  if (dNeq(p1%at(x_ref+x),p1%at(x_ref-x),1.0e-6_pReal))           error stop 'polynomials: eval(quartic)'


end subroutine selfTest

end module polynomials
