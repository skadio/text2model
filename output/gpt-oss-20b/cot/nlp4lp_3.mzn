% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Derived parameter for bounds
int: maxCap = max(Demand) + max(OilCap);

% Variables
var 0..maxCap: coal_added[1..T];
var 0..maxCap: nuke_added[1..T];

% Constraints
constraint
  forall(t in 1..T) (
    OilCap[t] +
    sum(s in 1..t) coal_added[s] * (if t <= s + CoalLife - 1 then 1 else 0) +
    sum(s in 1..t) nuke_added[s] * (if t <= s + NukeLife - 1 then 1 else 0) >= Demand[t]
  );

constraint
  forall(t in 1..T) (
    sum(s in 1..t) nuke_added[s] * (if t <= s + NukeLife - 1 then 1 else 0) <= MaxNuke
  );

% Objective
solve minimize
  sum(t in 1..T) (CoalCost * coal_added[t] + NukeCost * nuke_added[t]);