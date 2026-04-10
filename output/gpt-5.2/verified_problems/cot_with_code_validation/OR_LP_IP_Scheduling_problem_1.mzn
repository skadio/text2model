% Parameters
int: num_skis;
int: num_skiers;

array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% Variables
array[1..num_skiers] of var 1..num_skis: assign; % assign[i] = ski index used by skier i
array[1..num_skiers] of var 0..max(abs(skier_heights), abs(ski_heights)): disparity;

% Constraints
constraint num_skiers <= num_skis;
constraint all_different(assign);

constraint forall(i in 1..num_skiers) (
  disparity[i] = abs(skier_heights[i] - ski_heights[assign[i]])
);

% Objective
solve minimize sum(i in 1..num_skiers)(disparity[i]);