% Electricity capacity planning

% Parameters (must match data.dzn names)
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;

int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Helpful bounds
int: MaxDem = max(Demand);
int: MaxCap = MaxDem * T;

% Decision variables: capacity built in each year
array[1..T] of var 0..MaxDem: BuildCoal;
array[1..T] of var 0..MaxDem: BuildNuke;

% Derived capacities available each year
array[1..T] of var 0..MaxCap: CoalCap;
array[1..T] of var 0..MaxCap: NukeCap;
array[1..T] of var 0..MaxCap: TotalCap;

% Total investment cost
var 0..((CoalCost + NukeCost) * MaxDem * T): TotalCost;

% Capacity accumulation with lifetimes
constraint
  forall(t in 1..T) (
    CoalCap[t] = sum(k in 1..t where t - k < CoalLife)(BuildCoal[k])
  );

constraint
  forall(t in 1..T) (
    NukeCap[t] = sum(k in 1..t where t - k < NukeLife)(BuildNuke[k])
  );

% Meet demand each year with total capacity
constraint
  forall(t in 1..T) (
    TotalCap[t] = OilCap[t] + CoalCap[t] + NukeCap[t]
  );

constraint
  forall(t in 1..T) (
    TotalCap[t] >= Demand[t]
  );

% Nuclear capacity limit each year
constraint
  forall(t in 1..T) (
    NukeCap[t] <= MaxNuke
  );

% Objective: minimize total capital cost
constraint
  TotalCost = CoalCost * sum(t in 1..T)(BuildCoal[t])
            + NukeCost * sum(t in 1..T)(BuildNuke[t]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "BuildCoal=", show(BuildCoal), "\n",
  "BuildNuke=", show(BuildNuke), "\n",
  "CoalCap=", show(CoalCap), "\n",
  "NukeCap=", show(NukeCap), "\n",
  "TotalCap=", show(TotalCap), "\n"
];