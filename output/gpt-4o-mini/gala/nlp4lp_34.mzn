include "globals.mzn";

int: T;  % Total number of periods
int: K;  % Total number of generators
array[1..T] of int: Demand;  % Demand during each period
array[1..K] of int: NumGenerator;  % Number of generators of each type
array[1..K] of int: MinLevel;  % Minimum production level of each generator
array[1..K] of int: MaxLevel;  % Maximum production level of each generator
array[1..K] of int: RunCost;  % Running cost of each generator
array[1..K] of float: ExtraCost;  % Extra cost per MW above minimum for each generator
array[1..K] of int: StartCost;  % Start-up cost of each generator

% Decision variables
array[1..T, 1..K] of var 0..NumGenerator: production;  % Production levels for each generator in each period
array[1..T, 1..K] of var 0..1: isRunning;  % Whether each generator is running in each period

% Constraints
% Ensure that the total production meets the demand for each period
constraint forall(t in 1..T)(
    sum(k in 1..K)(production[t, k]) >= Demand[t]
);

% Ensure that production levels are within the min and max limits
constraint forall(t in 1..T, k in 1..K)(
    production[t, k] >= MinLevel[k] * isRunning[t, k]  % Must meet minimum if running
    /\ production[t, k] <= MaxLevel[k] * isRunning[t, k]  % Must not exceed maximum if running
);

% Objective function: Minimize total cost
var int: totalCost = sum(t in 1..T, k in 1..K)(
    (isRunning[t, k] * StartCost[k]) +  % Start-up cost if running
    (RunCost[k] + ExtraCost[k] * max(0, production[t, k] - MinLevel[k])) * isRunning[t, k]  % Running cost
);

solve minimize totalCost;

% Output
output [
    "Total Cost = ", show(totalCost), "\n",
    "Production Levels = ", show(production), "\n",
    "Generators Running = ", show(isRunning), "\n"
];