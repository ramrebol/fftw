PROGRAM fftw_test
  !
  USE decimal
  USE fftw_module
  !
  IMPLICIT NONE
  !
  REAL(KIND=dp),    ALLOCATABLE :: AA(:,:), AA_new(:,:)
  COMPLEX(KIND=dp), ALLOCATABLE :: ATF(:,:)
  INTEGER                       :: NN, MM, ii, jj
  !
  OPEN(unit=10,file='ex1.dat',status='old',action='read')
  READ(10,*) NN,MM ! <- NNxMM is the size of the matrix inside the file vel1.dat
  !
  ALLOCATE( AA(NN,MM), AA_new(NN,MM), ATF(NN,MM) )
  AA = 0.0_dp;  AA_new = 0.0_dp;  ATF = 0.0_dp
  !
  DO ii=1,NN
     READ(10,*) ( AA(ii,jj), jj=1,MM ) ! AA is the original matrix (real)
  END DO
  CLOSE(10)
  !
  PRINT*,'MIN and MAX value of AA' !<- just to verify that is not null
  PRINT*, MINVAL( AA ), MAXVAL( AA )
  !
  CALL fft(NN,MM,AA,ATF) ! ATF (complex) is the fft of AA (real)
  !
  CALL ifft(NN,MM,ATF,AA_new) ! AA_new is the inverse fft AA, so must be == AA
  !
  PRINT*,'MIN and MAX value of AA_new' !<- just to verify that is not null
  PRINT*, MINVAL( AA_new ), MAXVAL( AA_new )
  !
  PRINT*,'Max and min val of (AA-AA_new)'!<- just to compare some way the result
  PRINT*, MINVAL( AA - AA_new ), MAXVAL( AA-AA_new )
  PRINT*,' ------------------------------------------------------------------- '
  !
  DEALLOCATE( AA, ATF )
  !
END PROGRAM fftw_test
