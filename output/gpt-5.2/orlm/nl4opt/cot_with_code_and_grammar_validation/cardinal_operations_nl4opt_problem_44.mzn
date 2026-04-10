% Parameters
int: vintage_ml = 500;
int: regular_ml = 750;
int: total_ml = 100000;
int: reg_to_vintage_min_ratio = 4;
int: min_vintage = 10;

% Variables
var 0..(total_ml div vintage_ml): v; % number of vintage bottles
var 0..(total_ml div regular_ml): r; % number of regular bottles

% Constraints
constraint vintage_ml * v + regular_ml * r <= total_ml;
constraint r >= reg_to_vintage_min_ratio * v;
constraint v >= min_vintage;

% Objective
solve maximize v + r;