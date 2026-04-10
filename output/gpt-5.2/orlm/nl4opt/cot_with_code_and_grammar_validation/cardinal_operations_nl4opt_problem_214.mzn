% Parameters
int: cap_large = 30;
int: cap_small = 10;
int: min_cars = 300;

% Variables
var 0..ceil(int2float(min_cars) / int2float(cap_large)) + min_cars div cap_small: nLarge;
var 0..min_cars div cap_small + min_cars div cap_large: nSmall;
var 0..(ceil(int2float(min_cars) / int2float(cap_large)) + min_cars div cap_small) + (min_cars div cap_small + min_cars div cap_large): nPlanes;

% Constraints
constraint nLarge < nSmall;
constraint cap_large * nLarge + cap_small * nSmall >= min_cars;
constraint nPlanes = nLarge + nSmall;

% Objective
solve minimize nPlanes;