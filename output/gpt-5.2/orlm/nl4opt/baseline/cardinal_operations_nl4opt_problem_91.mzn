% Diet optimization: minimize fat subject to protein/carbs requirements and turkey share limit.

int: prot_turkey = 20;
int: carbs_turkey = 30;
int: fat_turkey = 12;

int: prot_tuna = 18;
int: carbs_tuna = 25;
int: fat_tuna = 8;

int: min_protein = 150;
int: min_carbs = 200;

% Decision variables: number of meals (nonnegative integers)
var 0..1000: x_turkey;
var 0..1000: x_tuna;

% Constraints
constraint prot_turkey * x_turkey + prot_tuna * x_tuna >= min_protein;
constraint carbs_turkey * x_turkey + carbs_tuna * x_tuna >= min_carbs;

% At most 40% of meals are turkey:
% x_turkey / (x_turkey + x_tuna) <= 0.4  =>  5*x_turkey <= 2*(x_turkey + x_tuna)
% which simplifies to 3*x_turkey <= 2*x_tuna
constraint 3 * x_turkey <= 2 * x_tuna;

% Objective: minimize total fat intake
var int: total_fat = fat_turkey * x_turkey + fat_tuna * x_tuna;

solve minimize total_fat;

output [
  "turkey_dinners = ", show(x_turkey), "\n",
  "tuna_sandwiches = ", show(x_tuna), "\n",
  "total_protein = ", show(prot_turkey*x_turkey + prot_tuna*x_tuna), "\n",
  "total_carbs = ", show(carbs_turkey*x_turkey + carbs_tuna*x_tuna), "\n",
  "total_fat = ", show(total_fat), "\n"
];