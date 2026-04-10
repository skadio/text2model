% Parameters
int: min_laminate = 15000;
int: min_carpet = 5000;
int: min_total = 50000;

int: max_laminate = 40000;
int: max_carpet = 20000;

float: profit_laminate = 2.1;
float: profit_carpet = 3.3;

% Variables
var 0..max_laminate: x_laminate;
var 0..max_carpet: x_carpet;

% Constraints
constraint x_laminate >= min_laminate;
constraint x_carpet >= min_carpet;
constraint x_laminate + x_carpet >= min_total;

% Objective
solve maximize profit_laminate * x_laminate + profit_carpet * x_carpet;