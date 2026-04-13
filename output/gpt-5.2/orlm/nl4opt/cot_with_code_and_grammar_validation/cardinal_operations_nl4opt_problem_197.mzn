% Parameters
int: antibiotics_available = 35000;
int: antibiotics_first = 30;
int: gelatine_first = 20;
int: antibiotics_second = 65;
int: gelatine_second = 60;
int: min_second = 40;

% Variables
var 0..(antibiotics_available div antibiotics_first): x_first;
var min_second..(antibiotics_available div antibiotics_second): x_second;

% Constraints
constraint antibiotics_first * x_first + antibiotics_second * x_second <= antibiotics_available;
constraint x_first > x_second;

% Objective
solve minimize gelatine_first * x_first + gelatine_second * x_second;