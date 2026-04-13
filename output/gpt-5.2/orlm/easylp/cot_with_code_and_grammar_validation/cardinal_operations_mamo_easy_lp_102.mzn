% Parameters
int: max_total_people = 100;
int: min_x_people = 20;
int: min_y_people = 10;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var 0..max_total_people: x_people;
var 0..max_total_people: y_people;
var 0..(max_total_people * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x_people >= min_x_people;
constraint y_people >= min_y_people;
constraint x_people + y_people <= max_total_people;
constraint total_cost = cost_x * x_people + cost_y * y_people;

% Objective
solve minimize total_cost;