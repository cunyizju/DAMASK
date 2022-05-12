!--------------------------------------------------------------------------------------------------
!> @author Martin Diehl, Max-Planck-Institut für Eisenforschung GmbH
!> @brief Handling of UNIX signals.
!--------------------------------------------------------------------------------------------------
module signals
  use prec
  use system_routines

  implicit none
  private

  logical, volatile, public, protected :: &
    signals_SIGTERM = .false., &                                                                    !< termination signal
    signals_SIGUSR1 = .false., &                                                                    !< 1. user-defined signal
    signals_SIGUSR2 = .false.                                                                       !< 2. user-defined signal

  public :: &
    signals_init, &
    signals_setSIGTERM, &
    signals_setSIGUSR1, &
    signals_setSIGUSR2

contains


!--------------------------------------------------------------------------------------------------
!> @brief Register signal handlers.
!--------------------------------------------------------------------------------------------------
subroutine signals_init()

  call signalterm_c(c_funloc(catchSIGTERM))
  call signalusr1_c(c_funloc(catchSIGUSR1))
  call signalusr2_c(c_funloc(catchSIGUSR2))

end subroutine signals_init


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGTERM to .true.
!> @details This function can be registered to catch signals send to the executable.
!--------------------------------------------------------------------------------------------------
subroutine catchSIGTERM(signal) bind(C)

  integer(C_INT), value :: signal


  print'(a,i0)', ' received signal ',signal
  call signals_setSIGTERM(.true.)

end subroutine catchSIGTERM


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGUSR1 to .true.
!> @details This function can be registered to catch signals send to the executable.
!--------------------------------------------------------------------------------------------------
subroutine catchSIGUSR1(signal) bind(C)

  integer(C_INT), value :: signal


  print'(a,i0)', ' received signal ',signal
  call signals_setSIGUSR1(.true.)

end subroutine catchSIGUSR1


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGUSR2 to .true.
!> @details This function can be registered to catch signals send to the executable.
!--------------------------------------------------------------------------------------------------
subroutine catchSIGUSR2(signal) bind(C)

  integer(C_INT), value :: signal


  print'(a,i0,a)', ' received signal ',signal
  call signals_setSIGUSR2(.true.)

end subroutine catchSIGUSR2


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGTERM.
!--------------------------------------------------------------------------------------------------
subroutine signals_setSIGTERM(state)

  logical, intent(in) :: state


  signals_SIGTERM = state
  print*, 'set SIGTERM to',state

end subroutine signals_setSIGTERM


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGUSR.
!--------------------------------------------------------------------------------------------------
subroutine signals_setSIGUSR1(state)

  logical, intent(in) :: state


  signals_SIGUSR1 = state
  print*, 'set SIGUSR1 to',state

end subroutine signals_setSIGUSR1


!--------------------------------------------------------------------------------------------------
!> @brief Set global variable signals_SIGUSR2.
!--------------------------------------------------------------------------------------------------
subroutine signals_setSIGUSR2(state)

  logical, intent(in) :: state


  signals_SIGUSR2 = state
  print*, 'set SIGUSR2 to',state

end subroutine signals_setSIGUSR2


end module signals
