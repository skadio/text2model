% Parameters (with values embedded)
int: max_total_people = 100;
int: min_X_people = 20;
int: min_Y_people = 10;
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_total_people: X_people;
var 0..max_total_people: Y_people;
var 0..(cost_X*max_total_people + cost_Y*max_total_people): total_cost;

% Constraints
constraint X_people >= min_X_people;
constraint Y_people >= min_Y_people;
constraint X_people + Y_people <= max_total_people;

constraint total_cost = cost_X * X_people + cost_Y * Y_people;

% Objective
solve minimize total_cost;

output [
  "X_people = ", show(X_people), "\n",
  "Y_people = ", show(Y_people), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];