% Parameters
int: vintage_capacity = 500;
int: regular_capacity = 750;
int: total_wine = 100000;
int: ratio = 4;
int: min_vintage = 10;

% Variables
var 0..(total_wine div vintage_capacity): vintage;
var 0..(total_wine div regular_capacity): regular;

% Constraints
constraint vintage >= min_vintage;
constraint regular >= ratio * vintage;
constraint vintage * vintage_capacity + regular * regular_capacity <= total_wine;

% Objective
solve maximize vintage + regular;