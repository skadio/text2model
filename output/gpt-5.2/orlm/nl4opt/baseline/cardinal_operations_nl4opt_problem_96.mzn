% Minimize cholesterol intake subject to nutrition requirements

int: fat_burger = 10;
int: cal_burger = 300;
int: chol_burger = 12;

int: fat_pizza = 8;
int: cal_pizza = 250;
int: chol_pizza = 10;

int: min_fat = 130;
int: min_cal = 3000;

% Decision variables: number of burgers and pizza slices (nonnegative integers)
var 0..1000: burgers;
var 0..1000: pizza;

% Constraints
constraint fat_burger * burgers + fat_pizza * pizza >= min_fat;
constraint cal_burger * burgers + cal_pizza * pizza >= min_cal;

% At least twice as many pizza slices as burgers
constraint pizza >= 2 * burgers;

% Objective: minimize cholesterol intake
var int: total_chol = chol_burger * burgers + chol_pizza * pizza;
solve minimize total_chol;

output [
  "burgers = ", show(burgers), "\n",
  "pizza = ", show(pizza), "\n",
  "total_cholesterol = ", show(total_chol), "\n",
  "total_fat = ", show(fat_burger * burgers + fat_pizza * pizza), "\n",
  "total_calories = ", show(cal_burger * burgers + cal_pizza * pizza), "\n"
];