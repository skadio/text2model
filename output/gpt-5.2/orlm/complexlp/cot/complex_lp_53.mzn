% Parameters (with values embedded)
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES] of int: initial = [483, 265, 130, 361];
array[CITIES] of int: demand   = [346, 221, 217, 293];

array[CITIES, CITIES] of int: cost =
[|  0,  2, 19, 13
 | 34,  0, 10, 48
 | 46, 22,  0, 46
 | 48, 15, 23,  0 |];

int: total_initial = sum(i in CITIES)(initial[i]);
int: total_demand  = sum(i in CITIES)(demand[i]);

% Variables
int: MAXFLOW = total_initial;
array[CITIES, CITIES] of var 0..MAXFLOW: x; % vaccines shipped from i to j

% Constraints
constraint total_initial >= total_demand; % feasibility: enough vaccines overall

% No self-shipping
constraint forall(i in CITIES)(x[i,i] = 0);

% Supply limits: cannot ship out more than initial stock
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= initial[i]
);

% Demand satisfaction: final stock in each city must meet demand
% final[i] = initial[i] - outgoing + incoming
constraint forall(i in CITIES)(
  initial[i] - sum(j in CITIES)(x[i,j]) + sum(j in CITIES)(x[j,i]) >= demand[i]
);

% Objective
var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);
solve minimize total_cost;