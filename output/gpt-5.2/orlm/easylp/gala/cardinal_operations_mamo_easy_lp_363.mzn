% Crop planning / cost minimization (all data embedded)

include "globals.mzn";

% Decision variables: acres planted (nonnegative integers)
var int: wheat;
var int: corn;
var int: soybean;
var int: potatoes;

% Basic nonnegativity
constraint wheat >= 0 /\ corn >= 0 /\ soybean >= 0 /\ potatoes >= 0;

% Constraints
constraint wheat + corn >= 1000;
constraint soybean + potatoes <= 800;
constraint wheat >= soybean + 200;
constraint corn + potatoes <= 500;

% Objective: minimize total cost
var int: total_cost = 2*wheat + 3*corn + 1*soybean + 4*potatoes;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "wheat = ", show(wheat), " acres\n",
  "corn = ", show(corn), " acres\n",
  "soybean = ", show(soybean), " acres\n",
  "potatoes = ", show(potatoes), " acres\n"
];