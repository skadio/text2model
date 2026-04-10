% Parameters
int: cow_capacity = 20;          % bricks per cow
int: elephant_capacity = 50;     % bricks per elephant
int: min_bricks = 1000;          % minimum number of bricks to transport

% Variables
var 0..min_bricks: cows;            % number of cows used (non-negative)
var 0..min_bricks: elephants;       % number of elephants used (non-negative)
var 0..2*min_bricks: total_animals; % total animals (safe upper bound)

% Constraints
% Total animals definition
constraint
  total_animals = cows + elephants;

% Minimum transport requirement (capacity constraint)
constraint
  cow_capacity * cows + elephant_capacity * elephants >= min_bricks;

% Traffic constraints: elephants cannot exceed cows
constraint
  elephants <= cows;

% Traffic constraints: cows cannot exceed twice the number of elephants
constraint
  cows <= 2 * elephants;

% Objective
solve minimize total_animals;