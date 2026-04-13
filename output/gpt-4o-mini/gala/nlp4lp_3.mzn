include "globals.mzn";

int: T;                          % Number of years
array[1..T] of int: Demand;     % Demand in each year
array[1..T] of int: OilCap;     % Maximum oil capacity in each year
int: CoalCost;                  % Cost of coal per unit
int: NukeCost;                  % Cost of nuclear energy per unit
int: MaxNuke;                   % Maximum nuclear capacity
int: CoalLife;                  % Lifetime of a coal plant
int: NukeLife;                  % Lifetime of a nuclear plant

% Variables for coal and nuclear capacities
array[1..T] of var 0..max(Demand): CoalCap; % Coal capacity in each year
array[1..T] of var 0..MaxNuke: NukeCap;      % Nuclear capacity in each year

% Cumulative constraint for nuclear capacity
constraint cumulative([1..T], [1 | i in 1..T], NukeCap, MaxNuke);

% Ensure that the total capacity meets the demand for each year
constraint forall(t in 1..T)(
    OilCap[t] + CoalCap[t] + NukeCap[t] >= Demand[t]
);

% Objective: Minimize the total cost of coal and nuclear capacities
var int: totalCost = sum(t in 1..T)(CoalCost * CoalCap[t] + NukeCost * NukeCap[t]);
solve minimize totalCost;

% Output the results
output [
    "Coal Capacities: ", show(CoalCap), "\n",
    "Nuclear Capacities: ", show(NukeCap), "\n",
    "Total Cost: ", show(totalCost), "\n"
];