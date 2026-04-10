% Parameters
int: prot_turkey = 20;
int: carb_turkey = 30;
int: fat_turkey  = 12;

int: prot_tuna = 18;
int: carb_tuna = 25;
int: fat_tuna  = 8;

int: min_prot = 150;
int: min_carb = 200;

% Variables
var 0..1000: x_turkey; % number of turkey dinners
var 0..1000: x_tuna;   % number of tuna sandwiches

var 0..(fat_turkey*1000 + fat_tuna*1000): total_fat;

% Constraints
constraint prot_turkey * x_turkey + prot_tuna * x_tuna >= min_prot;
constraint carb_turkey * x_turkey + carb_tuna * x_tuna >= min_carb;

% At most 40% of meals are turkey: x_turkey / (x_turkey + x_tuna) <= 0.4
% Linearized: 3*x_turkey <= 2*x_tuna
constraint 3 * x_turkey <= 2 * x_tuna;

constraint total_fat = fat_turkey * x_turkey + fat_tuna * x_tuna;

% Objective
solve minimize total_fat;