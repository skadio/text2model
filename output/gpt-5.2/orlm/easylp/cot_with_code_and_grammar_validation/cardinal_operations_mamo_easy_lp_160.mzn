% Parameters
int: max_props = 100;
int: profit_X = 5000;
int: profit_Y = 3000;

int: area_coeff_X = 60;
int: area_coeff_Y = 30;
int: min_area = 3000;

% Variables
var 0..max_props: X;
var 0..max_props: Y;

var 0..(profit_X*max_props + profit_Y*max_props): total_profit;

% Constraints
constraint X + Y <= max_props;

constraint area_coeff_X * X + area_coeff_Y * Y >= min_area;

constraint total_profit = profit_X * X + profit_Y * Y;

% Objective
solve maximize total_profit;