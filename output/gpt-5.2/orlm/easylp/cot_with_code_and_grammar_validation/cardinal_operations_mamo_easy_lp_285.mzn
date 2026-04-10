% Parameters
int: max_total_tours = 50;
int: ratingX = 5;
int: ratingY = 3;
int: ratingZ = 7;
int: min_total_rating = 100;
int: min_diff_XY = 10;
int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var 0..max_total_tours: X;
var 0..max_total_tours: Y;
var 0..max_total_tours: Z;

var 0..(max_total_tours * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_tours;

constraint ratingX * X + ratingY * Y + ratingZ * Z >= min_total_rating;

constraint X >= Y + min_diff_XY;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;