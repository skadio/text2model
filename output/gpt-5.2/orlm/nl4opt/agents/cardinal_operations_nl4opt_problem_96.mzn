% Parameters
int: fat_per_burger = 10;
int: cal_per_burger = 300;
int: chol_per_burger = 12;

int: fat_per_pizza = 8;
int: cal_per_pizza = 250;
int: chol_per_pizza = 10;

int: min_fat = 130;
int: min_cal = 3000;

% Pizza-to-burger ratio requirement: pizza >= 2 * burgers
int: pizza_per_burger_min = 2;

% Variables
var 0..1000: burgers;      % number of burgers to eat (nonnegative integer)
var 0..1000: pizza_slices; % number of pizza slices to eat (nonnegative integer)
var 0..100000: total_chol; % total cholesterol intake to minimize

% Constraints

% --- Nutritional minimum requirements (fat and calories) ---
constraint
  fat_per_burger * burgers + fat_per_pizza * pizza_slices >= min_fat;

constraint
  cal_per_burger * burgers + cal_per_pizza * pizza_slices >= min_cal;

% --- Diet composition requirement: at least twice as many pizza slices as burgers ---
constraint
  pizza_slices >= pizza_per_burger_min * burgers;

% --- Define total cholesterol intake from chosen foods ---
constraint
  total_chol = chol_per_burger * burgers + chol_per_pizza * pizza_slices;

% Objective
solve minimize total_chol;