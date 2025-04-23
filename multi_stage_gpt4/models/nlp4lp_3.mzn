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

% The total capacity (oil, coal, and nuclear) should meet the demand for each year
constraint forall(t in 1..T) (
    OilCap[t] + CoalCap[t] + NukeCap[t] >= Demand[t]
);

% The nuclear capacity should not exceed the maximum nuclear capacity for each year
constraint forall(t in 1..T) (
    NukeCap[t] <= MaxNuke
);

% The coal capacity should not exceed the demand minus the oil and nuclear capacity for each year
constraint forall(t in 1..T) (
    CoalCap[t] <= Demand[t] - OilCap[t] - NukeCap[t]
);

% The coal capacity should last for its lifetime
constraint forall(t in 1..T-CoalLife) (
    CoalCap[t] = CoalCap[t+CoalLife]
);

% The nuclear capacity should last for its lifetime
constraint forall(t in 1..T-NukeLife) (
    NukeCap[t] = NukeCap[t+NukeLife]
);

% Objective
solve minimize sum(t in 1..T) (CoalCap[t]*CoalCost + NukeCap[t]*NukeCost);