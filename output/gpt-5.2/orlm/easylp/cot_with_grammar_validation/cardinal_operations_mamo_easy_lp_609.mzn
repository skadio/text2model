% Parameters
int: c1 = 1000;
int: c2 = 2000;
int: c3 = 3000;
int: c4 = 4000;

int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

int: cap12 = 500;
int: cap34 = 800;

int: rhs_x1_x3 = 50;    % 1/2 x1 - 1/4 x3 >= 50  => 2*x1 - x3 >= 200
int: rhs_x4_x2 = 100;   % 3/4 x4 - x2 >= 100     => 3*x4 - 4*x2 >= 400

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Half of X1 must be at least one-fourth more than X3 by no less than 50:
% (1/2)x1 - (1/4)x3 >= 50  -> 2*x1 - x3 >= 200
constraint 2*x1 - x3 >= 4*rhs_x1_x3;

% (3/4)x4 - x2 >= 100 -> 3*x4 - 4*x2 >= 400
constraint 3*x4 - 4*x2 >= 4*rhs_x4_x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;