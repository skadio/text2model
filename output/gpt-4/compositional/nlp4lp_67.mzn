% Parameters
int: M; % Number of types of smaller rolls
int: N; % Number of different cutting patterns
int: large_roll_width; % Large Roll Width
array[1..M] of int: demands; % Demands
array[1..M] of int: roll_width_options; % Roll Width Options
array[1..M, 1..N] of int: patterns; % The different cutting patterns applied to the large rolls

% Variables
var 0..large_roll_width: min_large_rolls_needed; % Minimum number of large rolls needed to fulfill all the orders
array[1..N] of var 0..large_roll_width: pattern_usage; % Number of times each cutting pattern is used

% Constraints

% The total number of large rolls used should be equal to the sum of the usage of each pattern
constraint min_large_rolls_needed = sum(pattern_usage);

% The number of small rolls produced of each type should meet the demand
constraint forall(i in 1..M)(
  sum(j in 1..N)(patterns[i,j] * pattern_usage[j]) >= demands[i]
);

% The total width of the small rolls produced by each pattern should not exceed the width of the large roll
constraint forall(j in 1..N)(
  sum(i in 1..M)(patterns[i,j] * roll_width_options[i]) <= large_roll_width
);

% Objective
solve minimize min_large_rolls_needed;