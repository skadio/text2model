% Parameters
int: max_total_tours = 50;
int: rating_X = 5;
int: rating_Y = 3;
int: rating_Z = 7;
int: min_total_rating = 100;
int: min_diff_XY = 10;

int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 700;

% Variables
var 0..max_total_tours: X;
var 0..max_total_tours: Y;
var 0..max_total_tours: Z;

var 0..(max_total_tours * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_tours;

constraint rating_X * X + rating_Y * Y + rating_Z * Z >= min_total_rating;

constraint X >= Y + min_diff_XY;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;