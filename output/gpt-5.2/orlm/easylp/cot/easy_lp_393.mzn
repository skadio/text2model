% Parameters (with values embedded)
int: cost_T = 500;
int: cost_P = 300;
int: cost_S = 200;
int: cost_R = 100;

int: max_TP = 50;
int: max_SR = 30;

int: min_T = 15;
int: min_P = 10;
int: min_S = 5;
int: min_R = 2;

% Variables
var min_T..max_TP: T;
var min_P..max_TP: P;
var min_S..max_SR: S;
var min_R..max_SR: R;

var int: total_cost;

% Constraints
constraint T + P <= max_TP;
constraint S + R <= max_SR;

constraint total_cost = cost_T*T + cost_P*P + cost_S*S + cost_R*R;

% Objective
solve minimize total_cost;