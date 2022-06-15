function mass=mass_function(radius)
% convert radius to mass
% created by: Trine Frisbæk Hansen, 2022
rho=0.4*10^-6;
mass=(rho*(4/3)*pi).*(radius).^3;
end