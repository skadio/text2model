% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

int: ub12 = 1000;   % X1 + X2 <= 1000
int: lb23 = 800;    % X2 + X3 >= 800
int: diff34 = 200;  % X3 - X4 = 200
int: ub_half = 300; % X4/2 - X1 <= 300

int: X1_lb = 0; int: X1_ub = 1000;
int: X2_lb = 0; int: X2_ub = 1000;
int: X3_lb = 0; int: X3_ub = 1000;
int: X4_lb = 0; int: X4_ub = 1000;

% Variables
var X1_lb..X1_ub: X1;
var X2_lb..X2_ub: X2;
var X3_lb..X3_ub: X3;
var X4_lb..X4_ub: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= ub12;
constraint X2 + X3 >= lb23;
constraint X3 - X4 = diff34;
constraint X4 - 2*X1 <= 2*ub_half;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;