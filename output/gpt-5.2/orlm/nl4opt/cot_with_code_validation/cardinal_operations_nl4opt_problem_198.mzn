% Parameters
int: train_capacity = 120;
int: tram_capacity  = 30;
int: demand         = 600;

% Variables
var 0..(demand div train_capacity + 1): trains;
var 0..(demand div tram_capacity + 1): trams;

% Constraints
constraint tram_capacity * trams + train_capacity * trains >= demand;
constraint trams >= 2 * trains;

% Objective
solve minimize trains + trams;