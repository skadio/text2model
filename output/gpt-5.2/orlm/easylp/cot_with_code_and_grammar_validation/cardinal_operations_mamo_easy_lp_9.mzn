% Parameters
int: budget = 5000;
int: impact_req = 20000;

int: impact_x = 10;
int: impact_y = 30;

int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint X + Y <= budget;
constraint impact_x * X + impact_y * Y >= impact_req;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;