include "globals.mzn";

/* Data */
int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

/* Decision variables */
array[1..num_skiers] of var 1..num_skis: ski_index;
constraint all_different(ski_index);

/* Disparity for each skier */
array[1..num_skiers] of var int: disparity;
constraint
  forall(i in 1..num_skiers) (
    disparity[i] = abs(ski_heights[ski_index[i]] - skier_heights[i])
  );

/* Objective: minimize total disparity */
var int: total_disparity = sum(i in 1..num_skiers)(disparity[i]);

solve minimize total_disparity;

/* Output */
output [
  "Total disparity = ", show(total_disparity), "\n",
  "Assignments (ski indices): ", show(ski_index), "\n",
  "Disparities per skier: ", show(disparity), "\n"
];