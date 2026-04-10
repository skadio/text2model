% Parameters
int: camel_capacity = 50;
int: horse_capacity = 60;

int: camel_food = 20;
int: horse_food = 30;

int: min_packages = 1000;
int: food_available = 450;

% Variables
var 0..(food_available div camel_food): camels;
var 0..(food_available div horse_food): horses;

% Constraints
constraint
  camel_capacity * camels + horse_capacity * horses >= min_packages;

constraint
  camel_food * camels + horse_food * horses <= food_available;

constraint
  horses <= camels;

% Objective
solve minimize camels + horses;