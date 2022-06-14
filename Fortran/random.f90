module random
  use globals
  use input
  implicit none

  real(dp), dimension(:), allocatable :: rNstarRandom 
  real(dp), dimension(:), allocatable :: alphaLRandom
  real(dp), dimension(:), allocatable :: rLstarRandom 
  real(dp), dimension(:), allocatable :: alphaFRandom 
  real(dp), dimension(:), allocatable :: cLeakageRandom 
  real(dp), dimension(:), allocatable :: alphaJRandom 
  real(dp), dimension(:), allocatable :: cRRandom 

  contains
  
  subroutine load_random(nRandIter,nRandPar,randParam)
    integer,  intent(in) :: nRandIter !number of randomized sets
    integer,  intent(in) :: nRandPar !number of parameters that are randomized
    real(dp), dimension(:), intent(in) :: randParam
    if ( allocated(rNstarRandom)) then
       deallocate(rNstarRandom)
	   deallocate(alphaLRandom)
	   deallocate(rLstarRandom)
	   deallocate(alphaFRandom)
	   deallocate(cLeakageRandom)
	   deallocate(alphaJRandom)
	   deallocate(cRRandom)
    end if

    allocate(rNstarRandom(nRandIter))
	allocate(alphaLRandom(nRandIter))
	allocate(rLstarRandom(nRandIter))
	allocate(alphaFRandom(nRandIter))
	allocate(cLeakageRandom(nRandIter))
	allocate(alphaJRandom(nRandIter))
	allocate(cRRandom(nRandIter))
	
	rNstarRandom = randParam(0*nRandIter+1:1*nRandIter)
	alphaLRandom = randParam(1*nRandIter+1:2*nRandIter)
	rLstarRandom = randParam(2*nRandIter+1:3*nRandIter)
	alphaFRandom = randParam(3*nRandIter+1:4*nRandIter)
	cLeakageRandom = randParam(4*nRandIter+1:5*nRandIter)
	alphaJRandom = randParam(5*nRandIter+1:6*nRandIter)
	cRRandom = randParam(6*nRandIter+1:7*nRandIter)

    
  end subroutine load_random
 
  ! -----------------------------------------------
  ! Find problems with input
  ! -----------------------------------------------
 

end module random
