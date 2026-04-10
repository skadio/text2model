include "alldifferent.mzn";

int: num_skis;
int: num_skiers;

array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

array[1..num_skiers] of var 1..num_skis: assigned_ski;
array[1..num_skiers] of var int: disparity;

constraint num_skiers <= num_skis;

constraint alldifferent(assigned_ski);

constraint forall(i in 1..num_skiers) (
  disparity[i] = abs(skier_heights[i] - ski_heights[assigned_ski[i]])
);

solve minimize sum(i in 1..num_skiers)(disparity[i]);