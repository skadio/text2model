% Parameters
int: r1 = 4;
int: r2 = 3;
int: r3 = 5;
int: r4 = 6;

int: cap12 = 1000;
int: cap34 = 800;

int: req12_num = 300;   % 0.5*x1 + 0.25*x2 >= 300
int: req12_den = 4;     % multiply by 4 => 2*x1 + 1*x2 >= 1200

int: req34_num = 250;   % 0.75*x3 + 0.6*x4 >= 250
int: req34_den = 20;    % multiply by 20 => 15*x3 + 12*x4 >= 5000

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(r1*cap12 + r2*cap12 + r3*cap34 + r4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + x2 >= req12_num * req12_den;      % 2*x1 + x2 >= 1200
constraint 15*x3 + 12*x4 >= req34_num * req34_den;  % 15*x3 + 12*x4 >= 5000

constraint total_cost = r1*x1 + r2*x2 + r3*x3 + r4*x4;

% Objective
solve minimize total_cost;