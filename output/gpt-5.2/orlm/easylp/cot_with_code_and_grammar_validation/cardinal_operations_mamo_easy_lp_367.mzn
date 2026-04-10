% Parameters
int: cost_P1 = 1000;
int: cost_P2 = 2000;
int: cost_P3 = 3000;
int: cost_P4 = 4000;

int: max_P1 = 10;
int: max_P2 = 15;
int: max_P3 = 12;
int: max_P4 = 8;

% Variables
var 0..max_P1: w1;
var 0..max_P2: w2;
var 0..max_P3: w3;
var 0..max_P4: w4;

var int: total_cost;

% Constraints
constraint w1 + w2 <= 20;
constraint w2 + w3 >= 10;
constraint abs(w3 - w4) <= 5;
constraint 2*w1 + 3*w2 - w4 >= 15;

constraint total_cost = cost_P1*w1 + cost_P2*w2 + cost_P3*w3 + cost_P4*w4;

% Objective
solve minimize total_cost;