% Parameters (with values embedded)
int: cow_capacity = 20;
int: elephant_capacity = 50;
int: min_bricks = 1000;

% Variables
var 0..50: cows;
var 0..50: elephants;
var 0..100: total_animals;

% Constraints
constraint total_animals = cows + elephants;
constraint cow_capacity * cows + elephant_capacity * elephants >= min_bricks;
constraint elephants <= cows;
constraint cows <= 2 * elephants;

% Objective
solve minimize total_animals;