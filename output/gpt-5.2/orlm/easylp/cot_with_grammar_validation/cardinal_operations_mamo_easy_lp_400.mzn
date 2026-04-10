% Parameters
int: max12 = 200;
int: max34 = 150;

int: req12 = 1000;
int: req34 = 750;

int: c1 = 5000;
int: c2 = 7000;
int: c3 = 10000;
int: c4 = 3000;

% Use scaled coefficients to avoid fractions: 7.5*x3 + 5*x4 >= 750  <=>  15*x3 + 10*x4 >= 1500
int: a1 = 5;
int: a2 = 10;

int: b3 = 15;
int: b4 = 10;
int: req34_scaled = 1500;

% Variables
var 0..max12: x1;
var 0..max12: x2;

var 0..max34: x3;
var 0..max34: x4;

var 0..(c1*max12 + c2*max12 + c3*max34 + c4*max34): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint a1*x1 + a2*x2 >= req12;
constraint b3*x3 + b4*x4 >= req34_scaled;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;