% Parameters
int: c1 = 5000;
int: c2 = 3000;
int: c3 = 4000;
int: c4 = 2000;

int: total_cap = 10000;

int: x1_lb = 0;    int: x1_ub = 3000;
int: x2_lb = 0;    int: x2_ub = 2500;
int: x3_lb = 0;    int: x3_ub = 1500;
int: x4_lb = 0;    int: x4_ub = 300;

% scale all constraints with decimals by 10 to keep integrality
int: S = 10;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_cap;

% 5*x1 >= 2000 + 3.5*x2   -> 50*x1 >= 20000 + 35*x2
constraint 50*x1 >= 20000 + 35*x2;

% 4.7*x4 <= x3 + 3500     -> 47*x4 <= 10*x3 + 35000
constraint 47*x4 <= 10*x3 + 35000;

% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000  -> 10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000
constraint 10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;