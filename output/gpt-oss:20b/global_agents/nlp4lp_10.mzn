%--------------------------------------------------------------------
%  Lamp power optimisation – minimise total absolute illumination error
%--------------------------------------------------------------------
int: N;                           % number of segments / illuminations
int: M;                           % number of lamps
array[1..N, 1..M] of float: coeff;        % coeff[i,j] – influence of lamp j on segment i
array[1..N] of float: desired;            % desired illumination for each segment

%--------------------------------------------------------------------
% Decision variables
%--------------------------------------------------------------------
array[1..M] of var 0.0..+inf: power;      % lamp powers (non‑negative real)

%--------------------------------------------------------------------
% Derived variables
%--------------------------------------------------------------------
array[1..N] of var float: illum = 
    [ sum(j in 1..M)( coeff[i,j] * power[j]) | i in 1..N ];

array[1..N] of var float: err = 
    [ abs( illum[i] - desired[i] ) | i in 1..N ];

var float: totalError = sum(i in 1..N)( err[i] );

%--------------------------------------------------------------------
% Objective
%--------------------------------------------------------------------
solve minimize totalError;

%--------------------------------------------------------------------
% Output
%--------------------------------------------------------------------
output [
    "Lamp powers: ", show(power), "\n",
    "Illuminations: ", show(illum), "\n",
    "Errors: ", show(err), "\n",
    "Total absolute error: ", show(totalError), "\n"
];