%
% Sets up a spectrum of generalists.
%
% In:
%  n - number of size classes
%  bParallel - Whether to prepare parallel execution (for global runs)
%
function loadparameters(nRandIter,nRandPar,randParam, bParallel)

arguments
    nRandIter int32 {mustBeInteger, mustBePositive} = 10;
    nRandPar int32 {mustBeInteger, mustBePositive} = 1;
    randParam (1,:) {mustBeNumeric} = (1:1);
    bParallel logical = false;
end

loadNUMmodelLibrary(bParallel);

calllib(loadNUMmodelLibrary(), 'f_initrandom', int32(nRandIter), int32(nRandPar), randParam);
if bParallel
    h = gcp('nocreate');
    poolsize = h.NumWorkers;
    parfor i=1:poolsize
        calllib(loadNUMmodelLibrary(), 'f_initrandom', int32(nRandIter), int32(nRandPar), randParam);
    end
end
end

