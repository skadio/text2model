% Parameters
int: num_skis;
int: num_skiers;

array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% Variables
array[1..num_skiers] of var 1..num_skis: assign; % assign[i] = ski index used by skier i
array[1..num_skiers] of var int: disparity;

% Constraints
constraint all_different(assign);

constraint
  forall(i in 1..num_skiers) (
    disparity[i] = abs(skier_heights[i] - ski_heights[assign[i]])
  );

constraint forall(i in 1..num_skiers) (disparity[i] >= 0);

% Objective
solve minimize sum(i in 1..num_skiers)(disparity[i]);