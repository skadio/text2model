% Portfolio allocation (whole dollars) minimizing total risk

int: BUDGET = 10000;

set of int: I = 1..4;

% Risk coefficients
array[I] of float: risk = [0.06, 0.05, 0.07, 0.08];

% Return rates
array[I] of float: ret = [0.04, 0.02, 0.0, 0.0];

% Bounds (not specified in the description; choose non-restrictive defaults)
array[I] of int: lb = [0, 0, 0, 0];
array[I] of int: ub = [BUDGET, BUDGET, BUDGET, BUDGET];

array[I] of var int: x;
constraint forall(i in I)(lb[i] <= x[i] /\ x[i] <= ub[i]);

% Budget constraint
constraint sum(i in I)(x[i]) = BUDGET;

% Return constraint: 0.04*x1 - 0.02*x2 >= 200
% Use integer scaling to avoid floating-point in constraints:
% 0.04 = 4/100, 0.02 = 2/100  => 4*x1 - 2*x2 >= 200*100 = 20000
constraint 4*x[1] - 2*x[2] >= 20000;

% Exposure constraint: |x3 - 2*x4| <= 500
constraint abs(x[3] - 2*x[4]) <= 500;

% Objective: minimize total risk = sum(risk_i * x_i)
var float: total_risk = sum(i in I)(risk[i] * int2float(x[i]));
solve minimize total_risk;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "x3=", show(x[3]), "\n",
  "x4=", show(x[4]), "\n",
  "total_risk=", show(total_risk), "\n"
];