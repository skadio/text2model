include "globals.mzn";

int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

/* Decision: which ski is assigned to each skier (index into ski_heights) */
array[1..num_skiers] of var 1..num_skis: ski_of_skier;

/* Each ski can be used by at most one skier */
constraint all_different(ski_of_skier);

/* Disparities (absolute differences in heights) */
array[1..num_skiers] of var int: disparity;
constraint forall(i in 1..num_skiers) (
  disparity[i] = abs(skier_heights[i] - ski_heights[ski_of_skier[i]])
);

var int: total_disparity = sum(i in 1..num_skiers)(disparity[i]);

solve minimize total_disparity;

output [
  "Total disparity = ", show(total_disparity), "\n",
  "ski_of_skier = ", show(ski_of_skier), "\n",
  "assigned_ski_heights = ", show([ ski_heights[ski_of_skier[i]] | i in 1..num_skiers ]), "\n",
  "disparity = ", show(disparity), "\n"
];