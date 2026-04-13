include "globals.mzn";

% ---- Data (embedded from problem statement) ----
int: BUDGET = 10000;

% Risk coefficients
float: r1 = 0.06;
float: r2 = 0.05;
float: r3 = 0.07;
float: r4 = 0.08;

% Return rates
float: ret1 = 0.04;
float: ret2 = 0.02;

% Constraints thresholds
int: min_return_diff = 200;   % ret1*x1 - ret2*x2 >= 200
int: max_x3_minus_2x4 = 500;  % |x3 - 2*x4| <= 500

% Allocation bounds:
% The description mentions "specific lower and upper limits" but does not provide numbers.
% To keep the model runnable, we use the natural bounds implied by the budget.
int: lb1 = 0; int: ub1 = BUDGET;
int: lb2 = 0; int: ub2 = BUDGET;
int: lb3 = 0; int: ub3 = BUDGET;
int: lb4 = 0; int: ub4 = BUDGET;

% ---- Decision variables (whole dollars) ----
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

% ---- Constraints ----
constraint x1 + x2 + x3 + x4 = BUDGET;

% 0.04*x1 - 0.02*x2 >= 200  ->  4*x1 - 2*x2 >= 20000 (multiply by 10000)
constraint 4 * x1 - 2 * x2 >= 20000;

% |x3 - 2*x4| <= 500
constraint abs(x3 - 2 * x4) <= max_x3_minus_2x4;

% ---- Objective: minimize total risk ----
% Use scaled integer objective to avoid floating-point optimization:
% minimize 0.06*x1 + 0.05*x2 + 0.07*x3 + 0.08*x4
% -> minimize (6*x1 + 5*x2 + 7*x3 + 8*x4) / 100
var int: risk_scaled = 6*x1 + 5*x2 + 7*x3 + 8*x4;

solve minimize risk_scaled;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Total risk = ", show(risk_scaled), "/100 = ", show(risk_scaled / 100.0), "\n"
];