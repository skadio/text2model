% Parameters
int: bricks_per_cow = 20;              % bricks a cow can carry
int: bricks_per_elephant = 50;         % bricks an elephant can carry
int: min_bricks_needed = 1000;         % minimum bricks to transport

% Variables
var 0..min_bricks_needed: cows;              % number of cows used
var 0..min_bricks_needed: elephants;         % number of elephants used
var 0..2*min_bricks_needed: total_animals;   % total animals (objective helper)

% Constraints
% --- Capacity constraint: ensure enough bricks are transported ---
constraint
  bricks_per_cow * cows + bricks_per_elephant * elephants >= min_bricks_needed;

% --- Traffic constraints: balance between cows and elephants ---
% Elephants cannot exceed cows
constraint
  elephants <= cows;

% At most twice as many cows as elephants
constraint
  cows <= 2 * elephants;

% --- Definition constraint: total animals helper variable ---
constraint
  total_animals = cows + elephants;

% Objective
solve minimize total_animals;