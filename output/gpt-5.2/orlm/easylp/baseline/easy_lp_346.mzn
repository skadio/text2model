% Finance portfolio allocation - embedded data

% Decision variables: dollars invested (integers)
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

% Risks per dollar invested
int: r1 = 5;
int: r2 = 7;
int: r3 = 6;
int: r4 = 8;

% Constraints
constraint 3*x1 + 4*x2 <= 5000;
constraint 2*x1 + 5*x3 <= 6000;
constraint x2 - x4 >= 1000;
constraint x1 - 3*x3 <= 2000;

% Objective: minimize total risk
var int: total_risk = r1*x1 + r2*x2 + r3*x3 + r4*x4;
solve minimize total_risk;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_risk=", show(total_risk), "\n"
];