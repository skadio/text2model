% Parameters
int: cow_capacity = 20;
int: elephant_capacity = 50;
int: min_bricks = 1000;

% Variables
var 0..ceil(min_bricks div cow_capacity): cows;
var 0..ceil(min_bricks div elephant_capacity): elephants;
var 0..(ceil(min_bricks div cow_capacity) + ceil(min_bricks div elephant_capacity)): total_animals;

% Constraints
constraint elephants <= cows;
constraint cows <= 2 * elephants;

constraint cow_capacity * cows + elephant_capacity * elephants >= min_bricks;

constraint total_animals = cows + elephants;

% Objective
solve minimize total_animals;