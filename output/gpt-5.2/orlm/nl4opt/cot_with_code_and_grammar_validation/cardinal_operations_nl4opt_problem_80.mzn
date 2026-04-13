% Parameters
int: max_color = 20;
int: max_bw = 30;
int: max_total = 35;
int: profit_color = 200;
int: profit_bw = 70;

% Variables
var 0..max_color: x_color;
var 0..max_bw: x_bw;

% Constraints
constraint x_color + x_bw <= max_total;

% Objective
solve maximize profit_color * x_color + profit_bw * x_bw;