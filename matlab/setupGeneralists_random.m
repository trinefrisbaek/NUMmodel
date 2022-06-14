%
% Sets up a spectrum of generalists.
%
% In:
%  n - number of size classes
%  bParallel - Whether to prepare parallel execution (for global runs)
%
function p = setupGeneralists_random(n, bParallel, iRand)

arguments
    n int32 {mustBeInteger, mustBePositive} = 10;
    bParallel logical = false;
    iRand int32 {mustBeInteger, mustBePositive} = 10;
end

loadNUMmodelLibrary(bParallel);

calllib(loadNUMmodelLibrary(), 'f_setupgeneralists_random', int32(n), iRand);
if bParallel
    h = gcp('nocreate');
    poolsize = h.NumWorkers;
    parfor i=1:poolsize
        calllib(loadNUMmodelLibrary(), 'f_setupgeneralists_random',int32(n), iRand);
    end
end

% Nutrients:
p = setupNutrients_N_DOC;

% Generalists:
p = parametersAddgroup(1,p,n);

p = getMass(p);

p.u0(1:2) = [150, 0]; % Initial conditions (and deep layer concentrations)
p.u0(p.idxB:p.n) = 1;