% Parameters
int: max_hours = 20;
int: hours_X = 5;
int: hours_Y = 3;

int: prod_X = 2;
int: prod_Y = 4;
int: min_productivity = 10;

int: cost_X = 50;
int: cost_Y = 80;

% Variables
var 0..max_hours div hours_X: X;
var 0..max_hours div hours_Y: Y;

var 0..(cost_X*(max_hours div hours_X) + cost_Y*(max_hours div hours_Y)): total_cost;

% Constraints
constraint hours_X * X + hours_Y * Y <= max_hours;
constraint prod_X * X + prod_Y * Y >= min_productivity;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;