include "globals.mzn";

% Data (embedded, per instructions)
int: cow_capacity = 20;
int: ele_capacity = 50;
int: bricks_needed = 1000;

% Decision variables
var 0..bricks_needed: cows;
var 0..bricks_needed: elephants;

% Constraints
constraint cow_capacity * cows + ele_capacity * elephants >= bricks_needed;

% Traffic/ratio constraints:
% elephants cannot exceed cows; and cows cannot exceed twice elephants
constraint elephants <= cows;
constraint cows <= 2 * elephants;

% Objective: minimize total animals
var 0..2*bricks_needed: total_animals = cows + elephants;

solve minimize total_animals;

output [
  "cows = ", show(cows), "\n",
  "elephants = ", show(elephants), "\n",
  "total_animals = ", show(total_animals), "\n",
  "bricks_carried = ", show(cow_capacity*cows + ele_capacity*elephants), "\n"
];