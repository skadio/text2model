% Parameters
int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% Variables
array[1..num_skiers] of var 1..num_skis: assignment;
var int: total_disparity;

% Constraints
constraint
  all_different(assignment)
  /\ total_disparity = sum([abs(ski_heights[assignment[i]] - skier_heights[i]) | i in 1..num_skiers]);

% Objective
solve minimize total_disparity;