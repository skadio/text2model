% Parameters (with values embedded)
int: max_trips = 50;
int: min_balance = 30;
int: costX = 100;
int: costY = 200;

% Variables
var 0..max_trips: X;
var 0..max_trips: Y;
var 0..(costX*max_trips + costY*max_trips): total_cost;

% Constraints
constraint X + Y <= max_trips;
constraint 2*X + 3*Y >= min_balance;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;