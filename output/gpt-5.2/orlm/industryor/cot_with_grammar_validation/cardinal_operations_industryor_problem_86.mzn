% Parameters
int: ref_demand = 3000;
int: nonref_demand = 4000;

int: A_ref_cap = 20;
int: A_nonref_cap = 40;

int: B_total_cap = 60;
int: B_ref_cap = B_total_cap div 2;      % equal split
int: B_nonref_cap = B_total_cap div 2;

int: cost_A = 30;
int: cost_B = 40;

int: max_trucks = (ref_demand + nonref_demand) div min(A_ref_cap + A_nonref_cap, B_total_cap) + 100;

% Variables
var 0..max_trucks: nA;
var 0..max_trucks: nB;

var 0..(cost_A * max_trucks + cost_B * max_trucks): total_cost;

% Constraints
constraint A_ref_cap * nA + B_ref_cap * nB >= ref_demand;
constraint A_nonref_cap * nA + B_nonref_cap * nB >= nonref_demand;

constraint total_cost = cost_A * nA + cost_B * nB;

% Objective
solve minimize total_cost;