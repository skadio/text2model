% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: cap12 = 1000;
int: cap34 = 1500;

int: rhs_diff1 = 300;  % x2 - (x1 + x3) >= 300
int: rhs_diff2 = 500;  % x3 - (x2 + x4) <= 500

% NOTE: The problem statement mentions "specific bounds on output volume" but does not provide numeric bounds.
% We therefore use safe, implied non-negativity and capacity-based upper bounds.
int: ub1 = cap12;       % from x1 + x2 <= 1000 and x2 >= 0
int: ub2 = cap12;       % from x1 + x2 <= 1000 and x1 >= 0
int: ub3 = cap34 div 2; % from 2*x3 + 3*x4 <= 1500 and x4 >= 0
int: ub4 = cap34 div 3; % from 2*x3 + 3*x4 <= 1500 and x3 >= 0

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;

constraint 2 * x3 + 3 * x4 <= cap34;

constraint x2 - (x1 + x3) >= rhs_diff1;

constraint x3 - (x2 + x4) <= rhs_diff2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;