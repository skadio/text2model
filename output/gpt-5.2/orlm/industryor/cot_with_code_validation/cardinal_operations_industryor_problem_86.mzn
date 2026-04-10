% Parameters
int: A_ref_cap = 20;
int: A_nonref_cap = 40;
int: B_total_cap = 60;
int: B_ref_cap = B_total_cap div 2;
int: B_nonref_cap = B_total_cap div 2;

int: demand_ref = 3000;
int: demand_nonref = 4000;

int: cost_A = 30;
int: cost_B = 40;

% Variables
int: maxA = (demand_ref + A_ref_cap - 1) div A_ref_cap;
int: maxB = (demand_ref + B_ref_cap - 1) div B_ref_cap;

var 0..maxA: xA; % number of Type A trucks
var 0..maxB: xB; % number of Type B trucks

% Constraints
constraint A_ref_cap * xA + B_ref_cap * xB >= demand_ref;
constraint A_nonref_cap * xA + B_nonref_cap * xB >= demand_nonref;

% Objective
var int: total_cost = cost_A * xA + cost_B * xB;
solve minimize total_cost;