% Parameters
int: train_capacity = 120;
int: tram_capacity  = 30;
int: min_people     = 600;

% Variables
var 0..ceil(min_people div train_capacity) + ceil(min_people div tram_capacity): trains;
var 0..ceil(min_people div tram_capacity): trams;
var 0..ceil(min_people div train_capacity) + ceil(min_people div tram_capacity): total_units;

% Constraints
constraint trams >= 2 * trains;

constraint train_capacity * trains + tram_capacity * trams >= min_people;

constraint total_units = trains + trams;

% Objective
solve minimize total_units;