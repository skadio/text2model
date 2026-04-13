% Parameters
int: N = 4;
set of int: V = 1..N;

array[V] of int: avail = [700, 500, 600, 800];
array[V] of int: cost  = [50, 60, 70, 80];

int: op1_cap = 1000; % x1 + x2
int: op2_cap = 1200; % x3 + x4
int: heavy_min = 800; % x1 + x3
int: req_min   = 600; % x2 + x4

% Variables
array[V] of var 0..800: x; % allocation of each vehicle type (bounded by max availability)

var int: total_cost;

% Constraints
constraint forall(i in V) (x[i] <= avail[i]);

constraint x[1] + x[2] <= op1_cap;
constraint x[3] + x[4] <= op2_cap;

constraint x[1] + x[3] >= heavy_min;
constraint x[2] + x[4] >= req_min;

constraint total_cost = sum(i in V)(cost[i] * x[i]);

% Objective
solve minimize total_cost;