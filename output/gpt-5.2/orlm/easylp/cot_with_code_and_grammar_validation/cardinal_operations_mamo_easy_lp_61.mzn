% Parameters
int: a_effX = 5;
int: a_effY = 10;
int: eff_min = 50;

int: q_effX = 3;
int: q_effY = 4;
int: q_max = 36;

int: costX = 20;
int: costY = 30;

% Variables
var 0..100: x;
var 0..100: y;
var 0..100000: total_cost;

% Constraints
constraint a_effX * x + a_effY * y >= eff_min;
constraint q_effX * x + q_effY * y <= q_max;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;