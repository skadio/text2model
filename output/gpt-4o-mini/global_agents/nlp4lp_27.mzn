int: K;  % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne;  % Input one coefficients matrix
array[1..K] of float: ManpowerOne;  % Manpower coefficients for input one
array[1..K, 1..K] of float: InputTwo;  % Input two coefficients matrix
array[1..K] of float: ManpowerTwo;  % Manpower coefficients for input two
array[1..K] of float: Stock;  % Initial stock level for each of the productive units
array[1..K] of float: Capacity;  % Productive capacity for each productive unit
float: ManpowerLimit;  % Company-wide manpower limit
array[1..K] of float: Demand;  % Demand for each of the productive units at the end of the planning horizon

% Decision variables
array[1..K] of var 0..max(Demand): production;  % Production for each unit
array[1..K] of var 0..ManpowerLimit: manpowerUsed;  % Manpower used for each unit
array[1..K] of var 0..max(Stock): stockHeld;  % Stock held for each unit

% Constraints
% Ensure that production meets demand at the end of the planning horizon
constraint forall(i in 1..K) (
    production[i] + stockHeld[i] >= Demand[i]
);

% Manpower constraints
constraint forall(t in 1..K) (
    manpowerUsed[t] <= ManpowerLimit
);

% Calculate manpower used based on inputs
constraint forall(t in 1..K) (
    manpowerUsed[t] = sum(i in 1..K)(ManpowerOne[t] * production[i]) + sum(i in 1..K)(ManpowerTwo[t] * production[i])
);

% Stock and capacity constraints
constraint forall(t in 1..K) (
    stockHeld[t] = Stock[t] + sum(i in 1..K)(InputOne[t, i] * production[i]) + sum(i in 1..K)(InputTwo[t, i] * production[i]) - production[t]
);

% Objective function: Maximize total productive capacity at the end of the planning horizon
var float: totalCapacity = sum(i in 1..K)(production[i]);
solve maximize totalCapacity;

% Output
output [
    "Total Production = ", show(totalCapacity), "\n",
    "Production = ", show(production), "\n",
    "Manpower Used = ", show(manpowerUsed), "\n",
    "Stock Held = ", show(stockHeld), "\n"
];