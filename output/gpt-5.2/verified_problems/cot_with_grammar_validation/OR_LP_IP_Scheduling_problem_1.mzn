include "globals.mzn";

int: num_skis;
int: num_skiers;

array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

array[1..num_skiers] of var 1..num_skis: assign;
array[1..num_skiers] of var int: disparity;

constraint all_different(assign);

constraint forall(i in 1..num_skiers) (
  disparity[i] = abs(skier_heights[i] - ski_heights[assign[i]])
);

solve minimize sum(i in 1..num_skiers)(disparity[i]);