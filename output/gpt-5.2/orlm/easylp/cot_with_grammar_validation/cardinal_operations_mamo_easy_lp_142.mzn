% Parameters
int: max_logistics = 50;
int: min_strength = 10;

int: coeff_log_X = 3;
int: coeff_log_Y = 2;

int: support_X = 4;
int: support_Y = 5;

% Variables
var 0..max_logistics: X;
var 0..max_logistics: Y;
var 0..(support_X * max_logistics + support_Y * max_logistics): total_support;

% Constraints
constraint coeff_log_X * X + coeff_log_Y * Y <= max_logistics;
constraint X + Y >= min_strength;
constraint total_support = support_X * X + support_Y * Y;

% Objective
solve minimize total_support;