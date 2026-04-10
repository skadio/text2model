% Parameters
int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 8;

int: ub1 = 500;
int: ub2 = 400;
int: ub3 = 300;
int: ub4 = 200;

int: rhs1 = 1500;   % x1 + 2*x2 <= 1500
int: rhs2 = 1000;   % 3*x1 + x3 >= 1000
int: rhs3 = 600;    % 4*x4 - x2 <= 600
int: rhs4 = -200;   % -x1 + x2 + x3 + x4 = -200  (i.e., x2+x3+x4-x1 = -200)

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + 2 * x2 <= rhs1;
constraint 3 * x1 + x3 >= rhs2;
constraint 4 * x4 - x2 <= rhs3;
constraint -x1 + x2 + x3 + x4 = rhs4;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;