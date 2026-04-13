int: N;  % Number of different illuminations
int: M;  % Number of lamp powers
array[1..N, 1..M] of float: Coefficients;  % Coefficients relating lamp powers to illumination
array[1..N] of float: DesiredIlluminations;  % Desired level of illuminations

array[1..M] of var 0..+inf: power;  % Lamp powers

% Objective: Minimize the total absolute error between actual and desired illuminations
var float: total_error = sum(i in 1..N)(abs(sum(j in 1..M)(Coefficients[i,j] * power[j]) - DesiredIlluminations[i]));

% Solve the minimization problem
solve minimize total_error;

% Output the results
output [
    "Lamp Powers = ", show(power), "\n",
    "Total Error = ", show(total_error), "\n"
];