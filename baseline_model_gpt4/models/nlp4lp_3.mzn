include "globals.mzn";

% Parameters
int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

% Decision Variables
array[1..T] of var 0..Demand[i]: CoalCap; % Coal capacity in year i
array[1..T] of var 0..Demand[i]: NukeCap; % Nuclear capacity in year i

% Constraints
constraint forall(i in 1..T) (
  CoalCap[i] + NukeCap[i] + OilCap[i] >= Demand[i] % Meet demand
);

constraint forall(i in 1..T) (
  NukeCap[i] <= MaxNuke % Nuclear capacity limit
);

constraint forall(i in 1..T) (
  if i <= CoalLife then
    sum(j in 1..i)(CoalCap[j]) <= Demand[i] % Coal plant lifetime
  else
    sum(j in (i-CoalLife+1)..i)(CoalCap[j]) <= Demand[i]
  endif
);

constraint forall(i in 1..T) (
  if i <= NukeLife then
    sum(j in 1..i)(NukeCap[j]) <= Demand[i] % Nuclear plant lifetime
  else
    sum(j in (i-NukeLife+1)..i)(NukeCap[j]) <= Demand[i]
  endif
);

% Objective
var int: total_cost = sum(i in 1..T)(CoalCap[i]*CoalCost + NukeCap[i]*NukeCost);
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n",
        "Coal capacity: ", show(CoalCap), "\n",
        "Nuclear capacity: ", show(NukeCap)];