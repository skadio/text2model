% Parameters
int: costX = 500;
int: costY = 1000;

int: min_req = 10;     % 5*X + 2*Y >= 10
int: max_lim = 25;     % 3*X + 4*Y <= 25

int: X_lb = 0;
int: X_ub = 7;
int: Y_lb = 0;
int: Y_ub = 5;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;

var 0..(costX*X_ub + costY*Y_ub): total_cost;

% Constraints
constraint 5*X + 2*Y >= min_req;
constraint 3*X + 4*Y <= max_lim;

constraint abs(X - Y) >= 1;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;