% Parameters (with values embedded)
int: fat_burger = 10;
int: cal_burger = 300;
int: chol_burger = 12;

int: fat_pizza = 8;
int: cal_pizza = 250;
int: chol_pizza = 10;

int: min_fat = 130;
int: min_cal = 3000;

% Variable upper bounds derived from calorie requirement (feasible, safe bounds)
% If only burgers: ceil(3000/300)=10; if only pizza: ceil(3000/250)=12
int: max_burgers = 10;
int: max_pizza = 30; % safe bound; also implied by pizza >= 2*burgers with max_burgers=10

% Variables
var 0..max_burgers: burgers;
var 0..max_pizza: pizza_slices;

% Constraints
constraint fat_burger * burgers + fat_pizza * pizza_slices >= min_fat;
constraint cal_burger * burgers + cal_pizza * pizza_slices >= min_cal;
constraint pizza_slices >= 2 * burgers;

% Objective
solve minimize chol_burger * burgers + chol_pizza * pizza_slices;