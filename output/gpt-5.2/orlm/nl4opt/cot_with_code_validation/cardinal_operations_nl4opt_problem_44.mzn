% Parameters
int: vintage_ml = 500;
int: regular_ml = 750;
int: total_ml = 100000;
int: min_vintage = 10;
int: regular_per_vintage = 4;

% Variables
var 0..(total_ml div vintage_ml): vintage;
var 0..(total_ml div regular_ml): regular;

% Constraints
constraint vintage >= min_vintage;
constraint regular >= regular_per_vintage * vintage;
constraint vintage_ml * vintage + regular_ml * regular <= total_ml;

% Objective
solve maximize vintage + regular;