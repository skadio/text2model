int: N;                     % Number of different illuminations
int: M;                     % Number of lamp powers

array[1..N, 1..M] of float: Coefficients;          % Coefficients relating lamp powers to illumination
array[1..N] of float: DesiredIlluminations;        % Desired level of illuminations

var float: power[1..M] >= 0;                       % Lamp powers (non‑negative)

% Compute the illumination produced by the chosen powers
array[1..N] of float: produced = 
  [ sum([Coefficients[i,j] * power[j] | j in 1..M]) | i in 1..N ];

% Absolute error for each segment
array[1..N] of float: error = 
  [ abs(produced[i] - DesiredIlluminations[i]) | i in 1..N ];

% Objective: minimise the total absolute error
solve :: minimize sum(error);

output [
  "Lamp powers: ", show(power), "\n",
  "Produced illuminations: ", show(produced), "\n",
  "Desired illuminations: ", show(DesiredIlluminations), "\n",
  "Absolute errors: ", show(error), "\n"
];