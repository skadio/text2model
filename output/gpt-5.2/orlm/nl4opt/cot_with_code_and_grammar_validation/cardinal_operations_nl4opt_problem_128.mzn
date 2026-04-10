% Parameters
int: cap_glass = 500;
int: cap_plastic = 750;
int: total_water = 250000;
int: min_glass = 20;
int: plastic_ratio = 3;

% Variables
var 0..(total_water div cap_glass): glass;
var 0..(total_water div cap_plastic): plastic;

% Constraints
constraint cap_glass * glass + cap_plastic * plastic <= total_water;
constraint plastic >= plastic_ratio * glass;
constraint glass >= min_glass;

% Objective
solve maximize glass + plastic;