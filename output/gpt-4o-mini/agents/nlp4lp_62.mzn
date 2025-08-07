include "globals.mzn";

int: M;  % Number of machines
int: P;  % Number of parts
array[1..M, 1..P] of int: TimeRequired;  % Time required for each machine and part
array[1..M] of int: MachineCosts;  % Cost of operating each machine
array[1..M] of int: Availability;  % Available time for each machine
array[1..P] of int: Prices;  % Selling price for each part
array[1..P] of int: SetupTime;  % Setup time for each part

% Decision variable: number of batches to produce for each part
array[1..P] of var 0..max(Availability) div min(TimeRequired): batches;

% Constraints for machine availability
array[1..M] of var 0..max(Availability): used_time;

% Calculate the total time used for each machine
constraint forall(m in 1..M) (
    used_time[m] = sum(p in 1..P)(TimeRequired[m, p] * batches[p]) + (if m = 1 then sum(p in 1..P)(SetupTime[p] * (batches[p] > 0)) else 0 endif)
);

% Ensure that the used time does not exceed availability
constraint forall(m in 1..M) (
    used_time[m] <= Availability[m]
);

% Objective: Maximize profit
var int: profit = sum(p in 1..P)(Prices[p] * batches[p]) - sum(m in 1..M)(MachineCosts[m] * used_time[m]);

solve maximize profit;

output [
    "Batches = ", show(batches), "\n",
    "Profit = ", show(profit), "\n"
];