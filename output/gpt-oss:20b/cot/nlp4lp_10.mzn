% Parameters
int: N;
int: M;
array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

% Variables
var float: power[1..M] >= 0;
var float: illumination[1..N] = [ sum(Coefficients[i,j] * power[j]) | i in 1..N ];
var float: error[1..N] = [ abs(illumination[i] - DesiredIlluminations[i]) | i in 1..N ];

% Constraints
% (No additional constraints beyond variable bounds)

% Objective
solve minimize sum(error);