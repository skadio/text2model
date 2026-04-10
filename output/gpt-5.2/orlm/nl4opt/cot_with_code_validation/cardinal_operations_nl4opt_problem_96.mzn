% Parameters
int: fat_per_burger = 10;
int: cal_per_burger = 300;
int: chol_per_burger = 12;

int: fat_per_pizza = 8;
int: cal_per_pizza = 250;
int: chol_per_pizza = 10;

int: min_fat = 130;
int: min_cal = 3000;

% Variables
var 0..1000: burgers;
var 0..1000: pizza_slices;

var 0..1000000: total_chol;

% Constraints
constraint fat_per_burger * burgers + fat_per_pizza * pizza_slices >= min_fat;
constraint cal_per_burger * burgers + cal_per_pizza * pizza_slices >= min_cal;

constraint pizza_slices >= 2 * burgers;

constraint total_chol = chol_per_burger * burgers + chol_per_pizza * pizza_slices;

% Objective
solve minimize total_chol;