% Parameters
int: prot_turkey = 20;
int: carb_turkey = 30;
int: fat_turkey  = 12;

int: prot_tuna = 18;
int: carb_tuna = 25;
int: fat_tuna  = 8;

int: min_protein = 150;
int: min_carbs   = 200;

% Variables
var 0..1000: x_turkey; % number of turkey dinners
var 0..1000: x_tuna;   % number of tuna sandwiches

var 0..1000000: total_fat;

% Constraints
constraint
  prot_turkey * x_turkey + prot_tuna * x_tuna >= min_protein;

constraint
  carb_turkey * x_turkey + carb_tuna * x_tuna >= min_carbs;

% At most 40% turkey: x_turkey <= 0.4 * (x_turkey + x_tuna)
% Multiply by 5 to avoid fractions: 5*x_turkey <= 2*(x_turkey + x_tuna) -> 3*x_turkey <= 2*x_tuna
constraint
  3 * x_turkey <= 2 * x_tuna;

constraint
  total_fat = fat_turkey * x_turkey + fat_tuna * x_tuna;

% Objective
solve minimize total_fat;