% Parameters
int: BUDGET = 100;
int: DEMAND_MIN = 50;
int: RISK_MAX = 30;

int: c1 = 5;
int: c2 = 4;
int: c3 = 3;

int: a1 = 2;
int: a2 = 3;

int: r1 = 4;
int: r3 = 5;

% Supplier maximum limits (not numerically specified; assume budget is the max per supplier)
int: max1 = BUDGET;
int: max2 = BUDGET;
int: max3 = BUDGET;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;

var 0..(c1*max1 + c2*max2 + c3*max3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET;

constraint a1*x1 + a2*x2 >= DEMAND_MIN;

constraint r1*x1 - r3*x3 <= RISK_MAX;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;