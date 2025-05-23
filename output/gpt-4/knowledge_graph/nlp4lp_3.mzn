include "globals.mzn";

% Parameters
int: T; % The number of years for which planning is to be conducted
array[1..T] of int: Demand; % The demand in period t
array[1..T] of int: OilCap; % The maximum oil capacity in period t
int: CoalCost; % The cost of coal per unit
int: NukeCost; % The cost of nuclear energy per unit
int: MaxNuke; % The maximum nuclear capacity
int: CoalLife; % The lifetime of a coal plant
int: NukeLife; % The lifetime of a nuclear plant

% Variables
array[1..T] of var 0..MaxNuke: NukeCap; % The nuclear capacity in period t
array[1..T] of var 0..sum(Demand): CoalCap; % The coal capacity in period t

% Constraints
constraint forall(t in 1..T) (
    OilCap[t] + NukeCap[t] + CoalCap[t] >= Demand[t] % The total capacity must meet the demand
);

constraint forall(t in 1..T) (
    NukeCap[t] <= MaxNuke % The nuclear capacity must not exceed the maximum nuclear capacity
);

constraint forall(t in 1..T-CoalLife+1) (
    sum(i in t..t+CoalLife-1) (CoalCap[i]) <= CoalCap[t] % The coal capacity must last for its lifetime
);

constraint forall(t in 1..T-NukeLife+1) (
    sum(i in t..t+NukeLife-1) (NukeCap[i]) <= NukeCap[t] % The nuclear capacity must last for its lifetime
);

% Objective
var int: total_cost = sum(t in 1..T) (CoalCap[t]*CoalCost + NukeCap[t]*NukeCost);
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n",
        "Coal capacity: ", show(CoalCap), "\n",
        "Nuclear capacity: ", show(NukeCap)];