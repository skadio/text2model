include "globals.mzn";

% Data (embedded from problem statement)
int: protein_fish = 10;
int: iron_fish    = 12;
int: fat_fish     = 7;

int: protein_chicken = 15;
int: iron_chicken    = 8;
int: fat_chicken     = 10;

int: min_protein = 130;
int: min_iron    = 120;

% Decision variables: number of meals (nonnegative integers)
% Upper bounds chosen safely (tight enough for fast solving)
var 0..100: fish;
var 0..100: chicken;

% Nutrition constraints
constraint protein_fish * fish + protein_chicken * chicken >= min_protein;
constraint iron_fish    * fish + iron_chicken    * chicken >= min_iron;

% Preference: at least twice as many chicken meals as fish meals
constraint chicken >= 2 * fish;

% Objective: minimize total fat intake
var 0..10000: total_fat = fat_fish * fish + fat_chicken * chicken;

solve minimize total_fat;

output [
  "fish = ", show(fish), "\n",
  "chicken = ", show(chicken), "\n",
  "total_fat = ", show(total_fat), "\n",
  "protein = ", show(protein_fish * fish + protein_chicken * chicken), "\n",
  "iron = ", show(iron_fish * fish + iron_chicken * chicken), "\n"
];