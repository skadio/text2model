% Parameters
int: max_total = 5000;
int: min_effectiveness = 2000;

int: max_x1 = 3000;
int: max_x2 = 2500;
int: max_x3 = 1500;

int: cost_x1 = 50;
int: cost_x2 = 75;
int: cost_x3 = 60;

% Effectiveness weights (scaled by 10 to keep integers):
% 0.5 = 5/10, 0.4 = 4/10, 0.6 = 6/10
int: w1 = 5;
int: w2 = 4;
int: w3 = 6;
int: w_scale = 10;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total;

constraint w1*x1 + w2*x2 + w3*x3 >= min_effectiveness * w_scale;

constraint abs(2*x2 - (x1 + x3)) <= 100;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;