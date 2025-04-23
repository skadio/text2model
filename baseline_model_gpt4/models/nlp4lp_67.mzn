include "globals.mzn";

% Parameters
int: M; % Number of types of smaller rolls
int: N; % Number of different cutting patterns
int: large_roll_width; % Large Roll Width
array[1..M] of int: demands; % Demands
array[1..M] of int: roll_width_options; % Roll Width Options
array[1..N, 1..M] of int: patterns; % The different cutting patterns applied to the large rolls

% Decision Variables
array[1..N] of var 0..large_roll_width: num_large_rolls;

% Objective
var int: total_large_rolls = sum(num_large_rolls);
minimize total_large_rolls;

% Constraints
constraint forall(i in 1..M)(
  sum(j in 1..N)(patterns[j,i]*num_large_rolls[j]) >= demands[i]
);

constraint forall(j in 1..N)(
  sum(i in 1..M)(patterns[j,i]*roll_width_options[i]) <= large_roll_width*num_large_rolls[j]
);

solve satisfy;
output ["total_large_rolls: ", show(total_large_rolls), "\n"];