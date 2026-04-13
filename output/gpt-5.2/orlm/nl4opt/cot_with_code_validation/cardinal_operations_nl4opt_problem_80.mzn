% Parameters
int: max_color = 20;
int: max_bw = 30;
int: max_total = 35;
int: profit_color = 200;
int: profit_bw = 70;

% Variables
var 0..max_color: x_color;
var 0..max_bw: x_bw;
var 0..(max_color + max_bw): x_total;
var 0..(profit_color*max_color + profit_bw*max_bw): total_profit;

% Constraints
constraint x_total = x_color + x_bw;
constraint x_total <= max_total;
constraint total_profit = profit_color * x_color + profit_bw * x_bw;

% Objective
solve maximize total_profit;