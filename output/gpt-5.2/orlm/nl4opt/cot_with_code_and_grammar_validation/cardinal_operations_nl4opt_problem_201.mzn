% Parameters
int: cust_throw = 15;
int: cust_climb = 8;
int: cost_throw = 2;
int: cost_climb = 3;
int: budget = 100;

int: min_climb = 5;
int: throw_at_least_twice_climb_factor = 2;

% Variables
var 0..budget div cost_throw: x_throw;
var min_climb..budget div cost_climb: x_climb;

var 0..(cust_throw*(budget div cost_throw) + cust_climb*(budget div cost_climb)): total_customers;

% Constraints
constraint
  cost_throw * x_throw + cost_climb * x_climb <= budget;

constraint
  x_throw >= throw_at_least_twice_climb_factor * x_climb;

constraint
  total_customers = cust_throw * x_throw + cust_climb * x_climb;

% Objective
solve maximize total_customers;