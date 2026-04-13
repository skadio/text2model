% Parameters (with values embedded)
int: n = 4;
set of int: LINES = 1..n;

array[LINES] of int: cost = [10, 15, 20, 25];

int: cap12 = 1000;
int: cap34 = 1500;

int: diff_req_2_vs_1plus3 = 300;
int: diff_bal_3_vs_2plus4 = 500;

% NOTE: The problem statement mentions "specific bounds on output volume" but does not provide numeric bounds.
% We therefore use safe nonnegative bounds derived from capacity constraints to keep variables finite.
int: ub_x1 = cap12;                       % from x1 + x2 <= 1000 and nonnegativity
int: ub_x2 = cap12;
int: ub_x3 = cap34 div 2;                 % from 2*x3 + 3*x4 <= 1500 and nonnegativity
int: ub_x4 = cap34 div 3;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint 2*x3 + 3*x4 <= cap34;

constraint x2 - (x1 + x3) >= diff_req_2_vs_1plus3;
constraint x3 - (x2 + x4) <= diff_bal_3_vs_2plus4;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;