% Parameters
int: max_wc = 500;
int: max_rb = 600;

int: min_w_minus_r = 100;
int: min_c_minus_b = 200;

int: cost_w = 10;
int: cost_c = 20;
int: cost_r = 30;
int: cost_b = 40;

% Variables
var 0..max_wc: wheat;
var 0..max_wc: corn;
var 0..max_rb: rice;
var 0..max_rb: barley;

var 0..(cost_w*max_wc + cost_c*max_wc + cost_r*max_rb + cost_b*max_rb): total_cost;

% Constraints
constraint wheat + corn <= max_wc;
constraint rice + barley <= max_rb;

constraint wheat >= rice + min_w_minus_r;
constraint corn >= barley + min_c_minus_b;

constraint total_cost = cost_w*wheat + cost_c*corn + cost_r*rice + cost_b*barley;

% Objective
solve minimize total_cost;