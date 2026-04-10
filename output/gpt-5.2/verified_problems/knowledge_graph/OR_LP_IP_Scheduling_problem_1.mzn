int: num_skis;
int: num_skiers;

array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

array[1..num_skiers] of var 1..num_skis: assigned_ski;

constraint
  all_different(assigned_ski);

array[1..num_skiers] of var int: disparity;
constraint
  forall(i in 1..num_skiers) (
    disparity[i] = abs(skier_heights[i] - ski_heights[assigned_ski[i]])
  );

var int: total_disparity = sum(i in 1..num_skiers)(disparity[i]);

solve minimize total_disparity;

output [
  "total_disparity = ", show(total_disparity), "\n",
  "assigned_ski = ", show(assigned_ski), "\n",
  "disparity = ", show(disparity), "\n"
];