% Input Data Nomenclature
int: M; % Number of types of smaller rolls
int: N; % Number of different cutting patterns
int: large_roll_width; % Large Roll Width
array[1..M] of int: demands; % Demands
array[1..M] of float: roll_width_options; % Roll Width Options
array[1..N, 1..M] of int: patterns; % The different cutting patterns applied to the large rolls

% Variables
array[1..N] of var 0..large_roll_width: large_rolls;

% Constraints
constraint forall(i in 1..M)(
  sum(j in 1..N)(patterns[j,i]*large_rolls[j]) >= demands[i]
);

% Objective
var int: total_large_rolls = sum(large_rolls);
solve minimize total_large_rolls;

% Output
output ["Total number of large rolls needed: ", show(total_large_rolls)];