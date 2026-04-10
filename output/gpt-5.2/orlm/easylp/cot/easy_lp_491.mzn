% Parameters (with values embedded)
int: support_per_X = 1000;
int: support_per_Y = 2000;

int: strength_coeff_X = 5;
int: strength_coeff_Y = 10;
int: min_strength = 50000;

int: cap_coeff_X = 3;
int: cap_coeff_Y = 4;
int: max_cap = 30000;

int: min_diff_X_minus_Y = 1000;

% Variable bounds derived from constraints:
% 3X + 4Y <= 30000 implies X <= 10000 and Y <= 7500 (with nonnegativity).
int: X_max = 10000;
int: Y_max = 7500;

% Variables
var 0..X_max: X;
var 0..Y_max: Y;
var 0..(support_per_X * X_max + support_per_Y * Y_max): total_support;

% Constraints
constraint strength_coeff_X * X + strength_coeff_Y * Y >= min_strength;
constraint cap_coeff_X * X + cap_coeff_Y * Y <= max_cap;
constraint X - Y >= min_diff_X_minus_Y;

constraint total_support = support_per_X * X + support_per_Y * Y;

% Objective
solve minimize total_support;