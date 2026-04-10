% Baby food mix optimization (embed all data directly)

include "globals.mzn";

% Data
int: fat_apple   = 2;
int: fol_apple   = 5;
int: fat_carrot  = 4;
int: fol_carrot  = 3;

int: min_carrot  = 2;
int: max_folate  = 100;

% Decision variables: servings (nonnegative integers)
var 0..100: apple;
var 0..100: carrot;

% Constraints
constraint apple = 3 * carrot;                       % three times as many apple as carrot
constraint carrot >= min_carrot;                     % at least 2 carrot servings
constraint fol_apple * apple + fol_carrot * carrot <= max_folate;

% Objective: maximize fat intake
var 0..1000: total_fat = fat_apple * apple + fat_carrot * carrot;
solve maximize total_fat;

output [
  "apple_servings = ", show(apple), "\n",
  "carrot_servings = ", show(carrot), "\n",
  "total_fat = ", show(total_fat), "\n",
  "total_folate = ", show(fol_apple * apple + fol_carrot * carrot), "\n"
];