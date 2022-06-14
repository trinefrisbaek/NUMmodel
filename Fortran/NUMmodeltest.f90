program NUMmodeltest
  use NUMmodel
  use globals
  implicit none

  real(dp), allocatable:: u0(:), u00(:), dudt(:)
  real(dp):: ProdGross, ProdNet,ProdHTL,ProdBact,eHTL,Bpico,Bnano,Bmicro
  integer:: ii, i, n, nRandIter, nRandPar
  real(dp), dimension(14) :: a
  real(dp) :: b=1.1
  n=25
  nRandIter=2
  nRandPar=7
  a = (/1.4650, 1.3196, 1.1097, 1.1053, 7.3160, 7.4580, 0.0297, 0.0248, 0.0246, 0.0374, 1.2753, 1.6324, 0.1627, 0.0830 /)
  !a = (/1.1, 3.1, 2.4, 4.3 /)
  
  call initRandom(nRandIter, nRandPar, a)
  
  !allocate(u0(nGrid))
  !allocate(u00(nGrid))
  !allocate(dudt(nGrid))
  do ii = 1, nRandIter
    print*, 'Iter = ', ii
    call setupGeneralists_random(n,ii)
    if (.not.allocated(u0)) then
      allocate(u0(nGrid))
      allocate(u00(nGrid))
      allocate(dudt(nGrid))
    end if
    u00(idxN) = 150.d0
    u00(idxDOC) = 0.d0
    do i = idxB, nGrid
       u00(i) = 10.0d0 !*(i-2)
    end do
    u00(17:22) = 0.d0 ! No POM
    dudt = 0.d0
    call simulateChemostatEuler(u00, 300.d0, 10.d0, u00(1:2), 0.1d0, 1000.d0,0.1d0, logical(.false.,1))
    write(*,*) 'u',u00
  end do


  !call setupGeneralistsOnly(25)

  !allocate(u0(nGrid))
  !allocate(u00(nGrid))
  !allocate(dudt(nGrid))
  u00(idxN) = 150.d0
  u00(idxDOC) = 0.d0
  do i = idxB, nGrid
     u00(i) = 10.0d0 !*(i-2)
  end do
  u00(17:22) = 0.d0 ! No POM
  dudt = 0.d0

  !call getSinking(u00)
  
  call simulateChemostatEuler(u00, 300.d0, 10.d0, u00(1:2), 0.1d0, 1000.d0, 0.1d0, logical(.false.,1))
  !call calcDerivatives(u00, 20.d0, 10.d0, 0.1d0, dudt)
  !write(*,*) 'dudt:',dudt
  write(*,*) 'u',u00
  !call printRates()

  !write(*, '(6f10.6)') theta

  !ProdGross = 0
  !ProdNet = 0
  !ProdHTL=0
  !ProdBact = 0
  !eHTL=0
  !Bpico=0
  !Bnano=0
  !Bmicro=0

  !call getFunctions(u00, ProdGross, ProdNet,ProdHTL,ProdBact,eHTL,Bpico,Bnano,Bmicro)
  !write(*,*) ProdGross, ProdNet,ProdHTL, ProdBact, eHTL
  !write(*,*) u00
  !call calcDerivatives(u00, 60.d0, 15.d0, 0.1d0, dudt)

!!$  u0=u00
!!$  call simulateChemostatEuler(u0, 100.d0, 150.d0, 0.05d0, 300.d0, 0.01d0)
!!$  call printU(u0)
 ! call calcDerivatives(u00, 150.d0, 0.1d0)

 ! write(6,*) theta(3:5, 3:5)
 !call printRates(m, rates)
 ! write(6,*) 'xxxx'
 ! call setupGeneric( (/0.1d0, 1.0d0 /) )
!  call setupGeneralistsOnly()

  !call getFunctions(ProdGross, ProdNet,ProdHTL,eHTL,Bpico,Bnano,Bmicro)
  !write(*,*) Bpico, Bnano, Bmicro
  
end program NUMmodeltest
