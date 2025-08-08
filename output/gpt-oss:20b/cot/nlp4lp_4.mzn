% Parameters
int: Period;
array[1..7] of int: Demand;
int: MaxN = sum(Demand);
int: Days = Period * 7;

% Variables
array[1..MaxN] of var 0..7: x;
array[1..MaxN] of var bool: active;

% Constraints
constraint
  % Active nurses must work at least one day
  forall(n in 1..MaxN) (active[n] -> x[n] >= 1);

constraint
  forall(d in 1..Days) (
    sum(n in 1..MaxN) (
      bool2int(active[n] /\ (((d-1) mod 7) + 1 <= x[n]))
    ) >= Demand[(((d-1) mod 7) + 1)]
  );

% Objective
solve minimize sum(n in 1..MaxN) bool2int(active[n]);