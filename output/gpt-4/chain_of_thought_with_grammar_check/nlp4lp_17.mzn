% Parameters
int: N; % Number of different illuminations
int: M; % Number of lamp powers
array[1..N, 1..M] of float: Coefficients; % Coefficients relating lamp powers to illumination
array[1..N] of int: DesiredIlluminations; % Desired level of illuminations

% Variables
var 0..100: objective; % Objective variable to minimize
array[1..M] of var 0..100: LampPowers; % Lamp powers

% Constraints
constraint forall(i in 1..N) (
  abs(sum(j in 1..M) (Coefficients[i,j]*LampPowers[j]) - DesiredIlluminations[i]) <= objective
);

% Objective
solve minimize objective;