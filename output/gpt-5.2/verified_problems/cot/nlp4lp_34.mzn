% Parameters
int: T;
int: K;

array[1..T] of int: Demand;

array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;

array[1..K] of int: RunCost;
array[1..K] of float: ExtraCost;
array[1..K] of int: StartCost;

% Variables
array[1..T, 1..K] of var 0..max(NumGenerator): on;              % number of units of type k online at period t
array[1..T, 1..K] of var 0..max(NumGenerator): start;           % number of units of type k started at period t
array[1..T, 1..K] of var 0..(max(NumGenerator) * max(MaxLevel)): prod;  % total production (MW) from type k at period t

var float: TotalCost;

% Constraints
constraint forall(k in 1..K) (MinLevel[k] <= MaxLevel[k]);
constraint forall(k in 1..K) (NumGenerator[k] >= 0);

% Unit availability
constraint forall(t in 1..T, k in 1..K) (
  on[t,k] <= NumGenerator[k]
);

% Production bounds linked to online units
constraint forall(t in 1..T, k in 1..K) (
  prod[t,k] >= MinLevel[k] * on[t,k]
);
constraint forall(t in 1..T, k in 1..K) (
  prod[t,k] <= MaxLevel[k] * on[t,k]
);

% Demand satisfaction
constraint forall(t in 1..T) (
  sum(k in 1..K)(prod[t,k]) >= Demand[t]
);

% Startup accounting
constraint forall(k in 1..K) (
  start[1,k] = on[1,k]
);
constraint forall(t in 2..T, k in 1..K) (
  start[t,k] >= on[t,k] - on[t-1,k]
);
constraint forall(t in 1..T, k in 1..K) (
  start[t,k] <= on[t,k]
);

% Objective
constraint
  TotalCost =
    sum(t in 1..T, k in 1..K)(
      int2float(RunCost[k]) * int2float(on[t,k])
      + ExtraCost[k] * int2float(prod[t,k] - MinLevel[k] * on[t,k])
      + int2float(StartCost[k]) * int2float(start[t,k])
    );

solve minimize TotalCost;