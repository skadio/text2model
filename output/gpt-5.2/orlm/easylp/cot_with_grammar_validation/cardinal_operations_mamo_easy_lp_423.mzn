% Parameters
int: capacity = 5000;
int: minSteel = 1000;
int: minAluminum = 2000;
int: costSteel = 20;
int: costAluminum = 30;

% Variables
var 0..capacity: steel;
var 0..capacity: aluminum;
var 0..(capacity * max(costSteel, costAluminum)): total_cost;

% Constraints
constraint steel >= minSteel;
constraint aluminum >= minAluminum;
constraint steel + aluminum <= capacity;

constraint total_cost = costSteel * steel + costAluminum * aluminum;

% Objective
solve minimize total_cost;