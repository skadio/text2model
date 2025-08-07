int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

var 1..num_skis: assignment[1..num_skiers];
constraint all_different(assignment);

var int: total_disparity = sum(i in 1..num_skiers)(abs(ski_heights[assignment[i]] - skier_heights[i]));

solve minimize total_disparity;

output [
    "Assignment: ", show(assignment), "\n",
    "Total disparity: ", show(total_disparity), "\n"
];