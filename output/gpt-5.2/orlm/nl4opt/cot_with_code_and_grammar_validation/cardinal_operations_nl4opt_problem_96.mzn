% Parameters
int: fat_burger = 10;
int: cal_burger = 300;
int: chol_burger = 12;

int: fat_pizza = 8;
int: cal_pizza = 250;
int: chol_pizza = 10;

int: min_fat = 130;
int: min_cal = 3000;

% Variables
var 0..1000: burgers;
var 0..1000: pizza_slices;

% Constraints
constraint fat_burger * burgers + fat_pizza * pizza_slices >= min_fat;
constraint cal_burger * burgers + cal_pizza * pizza_slices >= min_cal;

% at least twice as many slices of pizza as burgers
constraint pizza_slices >= 2 * burgers;

% Objective
solve minimize chol_burger * burgers + chol_pizza * pizza_slices;