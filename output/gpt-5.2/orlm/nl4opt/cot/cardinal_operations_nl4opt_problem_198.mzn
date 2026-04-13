% Parameters (with values embedded)
int: train_capacity = 120;
int: tram_capacity  = 30;
int: demand = 600;

% Variables
var 0..ceil(demand div train_capacity)+demand: trains;
var 0..ceil(demand div tram_capacity)+demand: trams;

% Constraints
constraint tram_capacity * trams + train_capacity * trains >= demand;
constraint trams >= 2 * trains;

% Objective
solve minimize trains + trams;