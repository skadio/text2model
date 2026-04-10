% Parameters (with values embedded)
int: limit1 = 200;          % 2*X + Y <= 200
int: limit2 = 150;          % X + 3*Y >= 150
int: diff_limit = 20;       % |X - Y| <= 20
int: costX = 100;           % $ per unit of X
int: costY = 50;            % $ per unit of Y

% Variables
var 0..200: X;              % integer units of resource for crop X
var 0..200: Y;              % integer units of resource for crop Y
var 0..(costX*200 + costY*200): total_cost;

% Constraints
constraint 2 * X + Y <= limit1;
constraint X + 3 * Y >= limit2;
constraint abs(X - Y) <= diff_limit;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;