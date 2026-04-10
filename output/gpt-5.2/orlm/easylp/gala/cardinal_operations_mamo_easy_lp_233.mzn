% Crop planning: minimize planting cost under linear constraints
include "globals.mzn";

% Data (embedded from the problem statement)
int: costW = 10;
int: costC = 15;
int: costS = 20;

int: maxW = 400;
int: maxC = 200;
int: maxS = 300;

int: rhs1 = 500;  % 2*wheat + corn <= 500
int: rhs2 = 300;  % wheat + soybean >= 300
int: diffMax = 100; % |corn - soybean| <= 100

% Decision variables (whole acres)
var 0..maxW: wheat;
var 0..maxC: corn;
var 0..maxS: soybean;

% Constraints
constraint 2 * wheat + corn <= rhs1;
constraint wheat + soybean >= rhs2;
constraint abs(corn - soybean) <= diffMax;

% Objective: minimize total planting cost
var int: total_cost = costW*wheat + costC*corn + costS*soybean;
solve minimize total_cost;

output [
  "wheat_acres = ", show(wheat), "\n",
  "corn_acres = ", show(corn), "\n",
  "soybean_acres = ", show(soybean), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];