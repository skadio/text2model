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

% Variables
array[YEARS] of var 0..max(Demand): BuildCoal;
array[YEARS] of var 0..max(Demand): BuildNuke;

array[YEARS] of var 0..(max(Demand) + max(OilCap)): CoalCap;
array[YEARS] of var 0..(max(Demand) + max(OilCap)): NukeCap;
array[YEARS] of var 0..(max(Demand) + max(OilCap)): TotalCap;

var 0..(T * max(Demand) * max(CoalCost, NukeCost)): TotalCost;

% Constraints
constraint forall(t in YEARS) (
  CoalCap[t] = sum(k in YEARS where k <= t /\ t - k < CoalLife)(BuildCoal[k])
);

constraint forall(t in YEARS) (
  NukeCap[t] = sum(k in YEARS where k <= t /\ t - k < NukeLife)(BuildNuke[k])
);

constraint forall(t in YEARS) (
  TotalCap[t] = OilCap[t] + CoalCap[t] + NukeCap[t]
);

constraint forall(t in YEARS) (
  TotalCap[t] >= Demand[t]
);

constraint forall(t in YEARS) (
  NukeCap[t] <= MaxNuke
);

constraint TotalCost = sum(t in YEARS) (CoalCost * BuildCoal[t] + NukeCost * BuildNuke[t]);

% Objective
solve minimize TotalCost;