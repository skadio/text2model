% Red Star Plastics Factory - Production planning with substitution
% Data embedded (no .dzn)

int: nTypes = 6;
set of int: TYPES = 1..nTypes;

array[TYPES] of int: volume_cm3 = [1500, 2500, 4000, 6000, 9000, 12000];
array[TYPES] of int: demand     = [500,  550,  700,  900,  400,  300];
array[TYPES] of int: unit_cost  = [5,    8,    10,   12,   16,   18];

int: setup_cost = 1200;

% Tight bounds to avoid huge domains (prevents solver slowdown/timeouts)
array[TYPES] of int: max_prod = [
  sum(j in 1..1)(demand[j]),
  sum(j in 1..2)(demand[j]),
  sum(j in 1..3)(demand[j]),
  sum(j in 1..4)(demand[j]),
  sum(j in 1..5)(demand[j]),
  sum(j in 1..6)(demand[j])
];

% Decision variables
array[TYPES] of var 0..max_prod[6]: produce;
array[TYPES] of var bool: activate;

% use[s,d] = units of supply type s used to satisfy demand type d
% Only allowed when s >= d (larger/equal volume can substitute)
array[TYPES, TYPES] of var 0..max_prod[6]: use;

% Constraints

% Disallow infeasible substitutions (smaller volume for larger demand)
constraint forall(s in TYPES, d in TYPES where s < d) (use[s,d] = 0);

% Link activation to production (no production unless activated)
constraint forall(t in TYPES) (
  produce[t] <= max_prod[t] * bool2int(activate[t])
);

% Flow conservation: all produced units are allocated
constraint forall(s in TYPES) (
  sum(d in TYPES)(use[s,d]) = produce[s]
);

% Demand satisfaction: each demand is met exactly
constraint forall(d in TYPES) (
  sum(s in TYPES)(use[s,d]) = demand[d]
);

% Objective: variable costs + fixed setup costs
var int: total_cost =
  sum(t in TYPES)(unit_cost[t] * produce[t]) +
  sum(t in TYPES)(setup_cost * bool2int(activate[t]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "produce=", show(produce), "\n",
  "activate=", show(activate), "\n"
];