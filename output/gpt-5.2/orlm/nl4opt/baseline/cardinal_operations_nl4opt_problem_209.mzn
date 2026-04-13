% Package delivery with camels and horses
% Minimize total animals subject to package, food, and climate constraints

int: camel_capacity = 50;
int: horse_capacity = 60;

int: camel_food = 20;
int: horse_food = 30;

int: min_packages = 1000;
int: max_food = 450;

% Decision variables
var 0..1000: camels;
var 0..1000: horses;

constraint camel_capacity * camels + horse_capacity * horses >= min_packages;
constraint camel_food * camels + horse_food * horses <= max_food;
constraint horses <= camels;

solve minimize camels + horses;

output [
  "camels=", show(camels), "\n",
  "horses=", show(horses), "\n",
  "total_animals=", show(camels + horses), "\n",
  "packages=", show(camel_capacity * camels + horse_capacity * horses), "\n",
  "food_used=", show(camel_food * camels + horse_food * horses), "\n"
];