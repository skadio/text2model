% Parameters
int: max_total_people = 100;
int: min_people_X = 20;
int: min_people_Y = 10;
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var min_people_X..max_total_people: people_X;
var min_people_Y..max_total_people: people_Y;
var 0..(max_total_people * max(cost_X, cost_Y)): total_cost;

% Constraints
constraint people_X + people_Y <= max_total_people;
constraint total_cost = cost_X * people_X + cost_Y * people_Y;

% Objective
solve minimize total_cost;