% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Variables
array[1..T] of var 0..max(Demand): CoalCap;
array[1..T] of var 0..MaxNuke: NukeCap;
array[1..T] of var 0..max(Demand): TotalCap;

% Constraints
constraint forall(t in 1..T)(TotalCap[t] = CoalCap[t] + NukeCap[t] + OilCap[t]);
constraint forall(t in 1..T)(TotalCap[t] >= Demand[t]);
constraint forall(t in 1..T)(NukeCap[t] <= MaxNuke);
constraint forall(t in 1..T where t <= T - CoalLife)(sum(i in t..t+CoalLife)(CoalCap[i]) <= CoalCap[t]*CoalLife);
constraint forall(t in 1..T where t <= T - NukeLife)(sum(i in t..t+NukeLife)(NukeCap[i]) <= NukeCap[t]*NukeLife);

% Objective
var int: TotalCost = sum(t in 1..T)(CoalCap[t]*CoalCost + NukeCap[t]*NukeCost);
solve minimize TotalCost;