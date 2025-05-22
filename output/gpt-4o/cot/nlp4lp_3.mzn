% Parameters
int: T;
set of int: YEARS = 1..T;

array[YEARS] of int: Demand;
array[YEARS] of int: OilCap;

int: CoalCost;
int: NukeCost;

int: MaxNuke;

int: CoalLife;
int: NukeLife;

% A generous upper bound for yearly build decisions
int: MaxBuild = sum(Demand);

% Decision variables: capacity started in year t
array[YEARS] of var 0..MaxBuild: CoalBuild;
array[YEARS] of var 0..MaxBuild: NukeBuild;

% Meet demand in every year
constraint
  forall(t in YEARS)(
    OilCap[t]
    + sum(s in 1..t where t <= s + CoalLife - 1)(CoalBuild[s])
    + sum(s in 1..t where t <= s + NukeLife - 1)(NukeBuild[s])
    >= Demand[t]
  );

% Nuclear capacity limit in every year
constraint
  forall(t in YEARS)(
    sum(s in 1..t where t <= s + NukeLife - 1)(NukeBuild[s]) <= MaxNuke
  );

% Objective: minimise total capital cost
solve minimize
  sum(t in YEARS)(CoalBuild[t] * CoalCost + NukeBuild[t] * NukeCost);