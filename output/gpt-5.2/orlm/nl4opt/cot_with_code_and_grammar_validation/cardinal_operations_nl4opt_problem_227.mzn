% Parameters
int: regular_hours = 10;
int: regular_cost  = 300;
int: emergency_hours = 6;
int: emergency_cost  = 100;

int: min_total_hours = 300;
int: budget = 7000;

% Variables
var 0..(budget div regular_cost): regular;
var 0..(budget div emergency_cost): emergency;

% Constraints
constraint regular_hours * regular + emergency_hours * emergency >= min_total_hours;
constraint regular_cost  * regular + emergency_cost  * emergency <= budget;

% Objective
solve minimize regular + emergency;