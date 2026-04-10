% Medicine delivery with two machines: minimize waste
% All data embedded (no .dzn needed)

% Decision variables: minutes each machine is used (continuous, nonnegative)
var float: m1 >= 0.0;
var float: m2 >= 0.0;

% Rates (units per minute)
float: heart1 = 0.5;
float: brain1 = 0.8;
float: waste1 = 0.3;

float: heart2 = 0.3;
float: brain2 = 1.0;
float: waste2 = 0.5;

% Requirements
float: heart_max = 8.0;
float: brain_min = 4.0;

% Constraints
constraint heart1*m1 + heart2*m2 <= heart_max;
constraint brain1*m1 + brain2*m2 >= brain_min;

% Objective: minimize total waste
var float: total_waste = waste1*m1 + waste2*m2;

solve minimize total_waste;

output [
  "Minutes machine 1 = ", show(m1), "\n",
  "Minutes machine 2 = ", show(m2), "\n",
  "Heart medicine     = ", show(heart1*m1 + heart2*m2), "\n",
  "Brain medicine     = ", show(brain1*m1 + brain2*m2), "\n",
  "Total waste        = ", show(total_waste), "\n"
];