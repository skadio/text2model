% Parameters (with values embedded)
int: maxTotalTours = 50;
int: ratingX = 5;
int: ratingY = 3;
int: ratingZ = 7;
int: minTotalRating = 100;
int: minXMoreThanY = 10;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var 0..maxTotalTours: X;
var 0..maxTotalTours: Y;
var 0..maxTotalTours: Z;

% Constraints
constraint X + Y + Z <= maxTotalTours;
constraint ratingX * X + ratingY * Y + ratingZ * Z >= minTotalRating;
constraint X >= Y + minXMoreThanY;

% Objective
solve minimize costX * X + costY * Y + costZ * Z;