% Parameters
int: total_antibiotics = 35000;
int: abx_first = 30;
int: abx_second = 65;
int: gel_first = 20;
int: gel_second = 60;
int: min_second = 40;

% Variables
var 0..(total_antibiotics div abx_first): x_first;
var 0..(total_antibiotics div abx_second): x_second;

% Constraints
constraint abx_first * x_first + abx_second * x_second <= total_antibiotics;
constraint x_first > x_second;
constraint x_second >= min_second;

% Objective
solve minimize gel_first * x_first + gel_second * x_second;