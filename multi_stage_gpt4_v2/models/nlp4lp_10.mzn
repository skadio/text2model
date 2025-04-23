% Parameters
int: N; % Number of different illuminations
int: M; % Number of lamp powers
array[1..N, 1..M] of float: Coefficients; % Coefficients relating lamp powers to illumination
array[1..N] of float: DesiredIlluminations; % Desired level of illuminations

% Variables
array[1..M] of var float: LampPowers; % Powers of each lamp

% Constraints

% The power of each lamp should be non-negative
constraint forall(j in 1..M) (
    LampPowers[j] >= 0
);

% Objective

% Minimize the absolute error between the illuminations which are a result of choosing the lamp powers and the desired illuminations
solve minimize sum(i in 1..N) (abs(sum(j in 1..M) (Coefficients[i,j] * LampPowers[j]) - DesiredIlluminations[i]));