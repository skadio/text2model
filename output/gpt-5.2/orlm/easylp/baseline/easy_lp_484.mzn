% Emission reduction planning (all data embedded)

% Decision variables: whole-number reductions
var 0..1000: co2;
var 0..1000: ch4;

% Constraints
constraint co2 + ch4 <= 1000;
constraint 2 * co2 - ch4 >= 200;

% (1/2)*co2 + ch4 = 400  ->  co2 + 2*ch4 = 800 (avoids fractions)
constraint co2 + 2 * ch4 = 800;

% Objective: minimize total cost
var int: total_cost = 4 * co2 + 3 * ch4;
solve minimize total_cost;

output [
  "co2_reduction=", show(co2), "\n",
  "ch4_reduction=", show(ch4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];