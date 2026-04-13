% Parameters (with values embedded)
int: max_logistics = 50;          % 3*X + 2*Y <= 50
int: min_strength = 10;           % X + Y >= 10
int: support_X = 4;               % support points per unit X
int: support_Y = 5;               % support points per unit Y

% Variables
var 0..max_logistics: X;
var 0..max_logistics: Y;
var 0..(support_X*max_logistics + support_Y*max_logistics): total_support;

% Constraints
constraint 3*X + 2*Y <= max_logistics;
constraint X + Y >= min_strength;
constraint total_support = support_X*X + support_Y*Y;

% Objective
solve minimize total_support;