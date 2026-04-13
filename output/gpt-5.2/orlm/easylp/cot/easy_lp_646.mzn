% Parameters (with values embedded)
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: x1_lb = 0;  int: x1_ub = 300;
int: x2_lb = 0;  int: x2_ub = 250;
int: x3_lb = 0;  int: x3_ub = 400;
int: x4_lb = 0;  int: x4_ub = 350;

int: min_x1x2 = 200;
int: max_diff_x3x4 = 50;
int: rhs_ineq3 = 100;
int: total_ub = 500;

% Variables
var x1_lb..x1_ub: X1;
var x2_lb..x2_ub: X2;
var x3_lb..x3_ub: X3;
var x4_lb..x4_ub: X4;

% Constraints
constraint X1 + X2 >= min_x1x2;

constraint abs(X3 - X4) <= max_diff_x3x4;

% 2*X2 - X1 - 0.5*X3 <= 100  ==>  4*X2 - 2*X1 - X3 <= 200
constraint 4*X2 - 2*X1 - X3 <= 2*rhs_ineq3;

% (3/4)*X1 = X4 + 150  ==>  3*X1 = 4*X4 + 600
constraint 3*X1 = 4*X4 + 600;

constraint X1 + X2 + X3 + X4 <= total_ub;

% Objective
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;