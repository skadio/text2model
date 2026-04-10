% Minimize total number of animals (cows + elephants)
% subject to carrying capacity and ratio constraints.

int: cow_cap = 20;
int: ele_cap = 50;
int: bricks_needed = 1000;

% Upper bounds chosen safely for this problem
int: max_animals = bricks_needed div min(cow_cap, ele_cap) + 100; % safe
var 0..max_animals: cows;
var 0..max_animals: elephants;

constraint elephants <= cows;          % elephants cannot exceed cows
constraint cows <= 2 * elephants;      % at most twice as many cows as elephants
constraint cow_cap * cows + ele_cap * elephants >= bricks_needed;

var 0..2*max_animals: total_animals = cows + elephants;
solve minimize total_animals;

output [
  "cows=", show(cows), "\n",
  "elephants=", show(elephants), "\n",
  "total_animals=", show(total_animals), "\n",
  "bricks_carried=", show(cow_cap*cows + ele_cap*elephants), "\n"
];