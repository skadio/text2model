include "globals.mzn";

% Data (embedded as requested)
int: BUDGET = 10000;

int: c1 = 500;
int: c2 = 400;
int: c3 = 300;

int: RHS1 = 2000;  % (1/2)x1 - (1/4)x2 >= 2000
int: BAL  = 500;   % |x3 - x1| <= 500

% Decision variables: whole-dollar amounts invested in each option
var 0..BUDGET: x1;
var 0..BUDGET: x2;
var 0..BUDGET: x3;

% Total invested cannot exceed budget
constraint x1 + x2 + x3 <= BUDGET;

% (1/2)x1 - (1/4)x2 >= 2000  -> multiply by 4 to keep integers: 2*x1 - x2 >= 8000
constraint 2 * x1 - x2 >= 4 * RHS1;

% |x3 - x1| <= 500
constraint x3 - x1 <= BAL;
constraint x1 - x3 <= BAL;

% Objective: minimize total cost
var 0..(c1*BUDGET + c2*BUDGET + c3*BUDGET): total_cost;
constraint total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];