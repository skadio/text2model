% Parameters
int: costX = 5;
int: costY = 10;

int: min_prod = 200;        % 2*X + Y >= 200
int: max_resource = 150;    % X + 3*Y <= 150

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..100000: total_cost;

% Constraints
constraint 2 * X + Y >= min_prod;
constraint X + 3 * Y <= max_resource;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;