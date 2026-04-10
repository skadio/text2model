include "float.mzn";

int: T;
int: K;

array[1..T] of int: Demand;

array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;

array[1..K] of int: RunCost;
array[1..K] of float: ExtraCost;
array[1..K] of int: StartCost;

set of int: PERIODS = 1..T;
set of int: GENS = 1..K;

% Decision variables:
% on[t,k] = number of units of type k running in period t
array[PERIODS, GENS] of var 0..max(NumGenerator): on;

% prod[t,k] = total power produced by type k in period t (MW)
array[PERIODS, GENS] of var 0..max(NumGenerator) * max(MaxLevel): prod;

% start[t,k] = number of units of type k started up at beginning of period t
array[PERIODS, GENS] of var 0..max(NumGenerator): start;

% Constraints: generator availability
constraint
  forall(t in PERIODS, k in GENS) (
    on[t,k] <= NumGenerator[k]
  );

% Constraints: generator production level bounds (aggregate)
constraint
  forall(t in PERIODS, k in GENS) (
    prod[t,k] >= on[t,k] * MinLevel[k] /\
    prod[t,k] <= on[t,k] * MaxLevel[k]
  );

% Constraints: meet demand
constraint
  forall(t in PERIODS) (
    sum(k in GENS)(prod[t,k]) >= Demand[t]
  );

% Start-up counting
constraint
  forall(k in GENS) (
    start[1,k] = on[1,k]
  );

constraint
  forall(t in 2..T, k in GENS) (
    start[t,k] >= on[t,k] - on[t-1,k] /\
    start[t,k] >= 0
  );

% Objective: minimize total cost
% Running cost: RunCost per unit on at min level + ExtraCost per MW above min level
var float: total_cost =
  sum(t in PERIODS, k in GENS)(
      float(RunCost[k] * on[t,k])
    + ExtraCost[k] * float(prod[t,k] - on[t,k] * MinLevel[k])
    + float(StartCost[k] * start[t,k])
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "on=\n", show(on), "\n",
  "prod=\n", show(prod), "\n",
  "start=\n", show(start), "\n"
];