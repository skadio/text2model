% Crop planning cost minimization (all data embedded)

int: cost_wheat = 10;
int: cost_corn = 15;
int: cost_soy = 20;

int: ub_wheat = 400;
int: ub_corn  = 200;
int: ub_soy   = 300;

var 0..ub_wheat: wheat;
var 0..ub_corn:  corn;
var 0..ub_soy:   soy;

% Constraints
constraint 2*wheat + corn <= 500;
constraint wheat + soy >= 300;
constraint abs(corn - soy) <= 100;

% Objective
var int: total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;
solve minimize total_cost;

output [
  "wheat_acres=", show(wheat), "\n",
  "corn_acres=", show(corn), "\n",
  "soy_acres=", show(soy), "\n",
  "total_cost=", show(total_cost), "\n"
];