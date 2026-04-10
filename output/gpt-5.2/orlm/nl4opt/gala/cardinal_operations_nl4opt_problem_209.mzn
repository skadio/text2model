include "globals.mzn";

% Data (embedded from problem statement)
int: camel_capacity = 50;
int: horse_capacity = 60;
int: camel_food = 20;
int: horse_food = 30;

int: min_packages = 1000;
int: food_available = 450;

% Decision variables
var 0..1000: camels;
var 0..1000: horses;

% Constraints
constraint camel_capacity * camels + horse_capacity * horses >= min_packages;
constraint camel_food * camels + horse_food * horses <= food_available;
constraint horses <= camels;

% Objective: minimize total animals used
var 0..2000: total_animals = camels + horses;
solve minimize total_animals;

output [
  "camels = ", show(camels), "\n",
  "horses = ", show(horses), "\n",
  "total_animals = ", show(total_animals), "\n",
  "packages_delivered = ", show(camel_capacity*camels + horse_capacity*horses), "\n",
  "food_used = ", show(camel_food*camels + horse_food*horses), "\n"
];