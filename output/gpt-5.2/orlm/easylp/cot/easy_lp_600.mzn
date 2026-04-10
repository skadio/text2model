% Parameters (with values embedded)
int: BUDGET = 100000;

int: X1_min = 10000; int: X1_max = 60000;
int: X2_min = 20000; int: X2_max = 80000;
int: X3_min = 15000; int: X3_max = 50000;
int: X4_min = 200;

% Costs (use cents to keep integer objective)
int: c1 = 5;   % 0.05 dollars per $1 invested
int: c2 = 8;   % 0.08
int: c3 = 12;  % 0.12
int: c4 = 15;  % 0.15

% Variables
var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;
var X4_min..BUDGET: X4; % no upper limit given; budget provides a valid bound

var 0..(c1*X1_max + c2*X2_max + c3*X3_max + c4*BUDGET): total_cost_cents;

% Constraints
constraint X1 + X2 + X3 + X4 <= BUDGET;

% 0.60*X1 - 0.40*X2 >= 0  ->  3*X1 - 2*X2 >= 0
constraint 3 * X1 - 2 * X2 >= 0;

% (X3 + X4) not less than (X1 + X2) by more than 30000
% X3 + X4 >= X1 + X2 - 30000
constraint X3 + X4 - X1 - X2 >= -30000;

% 0.70*X3 - 0.50*X4 <= 500  ->  7*X3 - 5*X4 <= 5000
constraint 7 * X3 - 5 * X4 <= 5000;

constraint total_cost_cents = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost_cents;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Total cost ($) = ", show(total_cost_cents div 100), ".", 
  if (total_cost_cents mod 100) < 10 then "0" else "" endif, show(total_cost_cents mod 100), "\n"
];