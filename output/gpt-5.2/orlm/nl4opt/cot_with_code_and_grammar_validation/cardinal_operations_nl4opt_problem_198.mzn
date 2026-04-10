% Parameters
int: train_capacity = 120;
int: tram_capacity = 30;
int: demand = 600;

% Variables
var 0..ceil(demand div train_capacity): trains;
var 0..ceil(demand div tram_capacity): trams;

% Constraints
constraint trams >= 2 * trains;
constraint train_capacity * trains + tram_capacity * trams >= demand;

% Objective
solve minimize trains + trams;