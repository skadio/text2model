% Parameters
int: total_cap = 100;

int: lb1 = 0; int: ub1 = 100;
int: lb2 = 0; int: ub2 = 100;
int: lb3 = 0; int: ub3 = 100;

% Costs in tenths of a dollar to keep integrality (0.5->5, 0.3->3, 0.7->7)
int: c1_10 = 5;
int: c2_10 = 3;
int: c3_10 = 7;

% Variables
var lb1..ub1: X1;
var lb2..ub2: X2;
var lb3..ub3: X3;

var 0..(c1_10*ub1 + c2_10*ub2 + c3_10*ub3): total_cost_10;

% Constraints
constraint X1 + X2 + X3 <= total_cap;

% 2*X1 >= 0.5*X2 + 30  ->  4*X1 - X2 >= 60
constraint 4*X1 - X2 >= 60;

% X1 - 0.5*X3 <= 20  ->  2*X1 - X3 <= 40
constraint 2*X1 - X3 <= 40;

constraint total_cost_10 = c1_10*X1 + c2_10*X2 + c3_10*X3;

% Objective
solve minimize total_cost_10;