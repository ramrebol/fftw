MODULE fftw_module
  !
  ! Contains the forward and inverse discrete fourier transform of a matrix
  ! using the library fftw3:
  !
  !     www.fftw.org
  !
  ! You may load different examples (matrices) in the OPEN command below.
  !
  ! -------------------------------------
  ! Ramiro Rebolledo Cormack
  ! ramrebol@gmail.com / rebolledo@usp.br
  ! 31/03/2021
  !
  USE decimal
  !
CONTAINS
  !
  SUBROUTINE fft(NX,NY,AA,ATF)
    !
    ! Calculate the forward Discrete Fourier transform ATF of the matriz AA
    ! Both matrices have the same size, but AA (the input) is real
    ! and ATF (the output) is complex
    !
    USE, INTRINSIC :: iso_c_binding
    IMPLICIT none
    INCLUDE 'fftw3.f03'
    !   include 'aslfftw3.f03'
    !
    INTEGER(C_INT),            INTENT(in)  :: Nx, Ny
    COMPLEX(C_DOUBLE_COMPLEX), ALLOCATABLE :: zin(:), zout(:)
    TYPE(C_PTR)                            :: planf
    !
    INTEGER                                :: ii, yy, ix, iy
    REAL(KIND=dp)                          :: AA(:,:)
    COMPLEX(KIND=dp)                       :: ATF(:,:)
    !
    ALLOCATE( zin(NX * NY), zout(NX * NY) )
    !
    ! Plan Creation (out-of-place forward and backward FFT)
    planf = fftw_plan_dft_2d(NY, NX, zin, zout, FFTW_FORWARD, FFTW_ESTIMATE)
    IF ( .NOT. C_ASSOCIATED(planf) ) THEN
       PRINT*, "plan creation error!!"
       STOP
    END IF
    !
    zin = CMPLX( RESHAPE( AA, (/ NX*NY /) ) , KIND=dp )
    !
    ! FFT Execution (forward)
    CALL FFTW_EXECUTE_DFT(planf, zin, zout)
    !
    DO iy = 1, Ny
       DO ix = 1, Nx
          ii = ix + nx*(iy-1)
          ATF(ix,iy) = zout(ii)
       END DO
    END DO
    !
    ! Plan Destruction
    CALL FFTW_DESTROY_PLAN(planf)
    CALL FFTW_CLEANUP
    !
    DEALLOCATE( zin, zout )
    !
  END SUBROUTINE fft
  !
  !
  SUBROUTINE ifft(NX,NY,ATF,AA)
    !
    ! Calculate the inverse Discrete Fourier transform ATF of the matriz AA
    ! Both matrices have the same size, but AA ATF (the input) is complex
    ! and AA (the output) is real
    !
    USE, INTRINSIC :: iso_c_binding
    IMPLICIT none
    INCLUDE 'fftw3.f03'
    !   include 'aslfftw3.f03'
    !
    INTEGER(C_INT),            INTENT(in)  :: Nx, Ny
    COMPLEX(C_DOUBLE_COMPLEX), ALLOCATABLE :: zin(:), zout(:)
    TYPE(C_PTR)                            :: planb
    !
    INTEGER                                :: ii, yy, ix, iy
    REAL(KIND=dp)                          :: AA(:,:)
    COMPLEX(KIND=dp)                       :: ATF(:,:)
    !
    ALLOCATE( zin(NX * NY), zout(NX * NY) )
    !
    ! Plan Creation (out-of-place forward and backward FFT)
   planb = fftw_plan_dft_2d(NY, NX, zin, zout, FFTW_BACKWARD, FFTW_ESTIMATE)
    IF ( .NOT. C_ASSOCIATED(planb) ) THEN
       PRINT*, "plan creation error!!"
       STOP
    END IF
    !
    zin = RESHAPE( ATF, (/ NX*NY /) )
    !
    ! FFT Execution (backward)
    CALL FFTW_EXECUTE_DFT(planb, zin, zout)
    !
    DO iy = 1, Ny
       DO ix = 1, Nx
          ii = ix + nx*(iy-1)
          AA(ix,iy) = dble( zout(ii) )/REAL( Nx*Ny, KIND=dp )
       END DO
    END DO
    !
    ! Plan Destruction
    CALL FFTW_DESTROY_PLAN(planb)
    CALL FFTW_CLEANUP
    !
    DEALLOCATE( zin, zout )
    !
  END SUBROUTINE ifft
  !
END MODULE fftw_module
