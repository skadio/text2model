% Parameters (with values embedded)
int: red_available = 80;
int: blue_available = 70;
int: smelly_max = 10;

int: red_per_exp1 = 3;
int: blue_per_exp1 = 4;
int: green_per_exp1 = 5;
int: smelly_per_exp1 = 1;

int: red_per_exp2 = 5;
int: blue_per_exp2 = 3;
int: green_per_exp2 = 6;
int: smelly_per_exp2 = 2;

% Variables
var 0..min(red_available div red_per_exp1, blue_available div blue_per_exp1): x1; % number of experiment 1
var 0..min(red_available div red_per_exp2, blue_available div blue_per_exp2): x2; % number of experiment 2

% Constraints
constraint red_per_exp1 * x1 + red_per_exp2 * x2 <= red_available;
constraint blue_per_exp1 * x1 + blue_per_exp2 * x2 <= blue_available;
constraint smelly_per_exp1 * x1 + smelly_per_exp2 * x2 <= smelly_max;

% Objective
solve maximize green_per_exp1 * x1 + green_per_exp2 * x2;