% Parameters
int: BUDGET = 100000;

int: X1_MIN = 10000;
int: X1_MAX = 60000;

int: X2_MIN = 20000;
int: X2_MAX = 80000;

int: X3_MIN = 15000;
int: X3_MAX = 50000;

int: X4_MIN = 200;
int: X4_MAX = BUDGET; % implied upper bound from total budget

% Costs (scaled to cents to avoid floating point): multiply by 100
int: C1 = 5;    % 0.05 * 100
int: C2 = 8;    % 0.08 * 100
int: C3 = 12;   % 0.12 * 100
int: C4 = 15;   % 0.15 * 100

% Variables
var X1_MIN..X1_MAX: X1;
var X2_MIN..X2_MAX: X2;
var X3_MIN..X3_MAX: X3;
var X4_MIN..X4_MAX: X4;

var 0..(BUDGET * max([C1, C2, C3, C4])): total_cost_cents;

% Constraints
constraint X1 + X2 + X3 + X4 <= BUDGET;

% 0.60*X1 - 0.40*X2 >= 0  ->  60*X1 - 40*X2 >= 0
constraint 60 * X1 - 40 * X2 >= 0;

% (X3 + X4) should not be less than (X1 + X2) by more than 30000:
% (X1+X2) - (X3+X4) <= 30000
constraint (X1 + X2) - (X3 + X4) <= 30000;

% 0.70*X3 - 0.50*X4 <= 500  ->  70*X3 - 50*X4 <= 500*100
constraint 70 * X3 - 50 * X4 <= 50000;

constraint total_cost_cents = C1 * X1 + C2 * X2 + C3 * X3 + C4 * X4;

% Objective (minimization)
solve minimize total_cost_cents;

% Safe formatting (avoid var condition in string if-then-else)
output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=",
  show(total_cost_cents div 100), ".",
  show_int(2, total_cost_cents mod 100),
  "\n"
];