% Parameters
int: M; % Number of types of smaller rolls
int: N; % Number of different cutting patterns
int: large_roll_width; % Large Roll Width
array[1..M] of int: demands; % Demands
array[1..M] of float: roll_width_options; % Roll Width Options
array[1..N, 1..M] of int: patterns; % The different cutting patterns applied to the large rolls

% Variables
array[1..N] of var 0..sum(demands): num_large_rolls; % Number of large rolls cut according to each pattern

% Constraints
% The total number of small rolls of each type produced must meet the demand
constraint forall(i in 1..M)(
    sum(j in 1..N)(patterns[j,i]*num_large_rolls[j]) >= demands[i]
);

% The total width of the small rolls produced from each large roll must not exceed the width of the large roll
constraint forall(j in 1..N)(
    sum(i in 1..M)(patterns[j,i]*roll_width_options[i]) <= large_roll_width
);

% Objective
% Minimize the number of large rolls used
solve minimize sum(num_large_rolls);