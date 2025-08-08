include "globals.mzn";

% Parameters (provided in the .dzn data file)
int: M;                                 % Number of machines
int: P;                                 % Number of part types
array[1..M, 1..P] of int: TimeRequired; % Time (hours) required on machine m to produce one batch of part p
array[1..M] of int: MachineCosts;       % Cost per hour of operating machine m
array[1..M] of int: Availability;         % Available hours per machine m per month
array[1..P] of int: Prices;               % Selling price per batch (of 100 parts) for part p
array[1..P] of int: SetupTime;            % Setup time (hours) required on machine 1 for part p

% A sufficiently large upper bound for the number of batches produced for each part.
int: U = 1000;

% Decision variables:
% x[p]: number of batches produced for part p (non-negative integer)
array[1..P] of var 0..U: x;
% y[p]: binary variable, 1 if part p is produced (x[p] > 0), 0 otherwise.
array[1..P] of var 0..1: y;

% Linking constraints: if any batch of part p is produced then y[p] must be 1,
% and if no batch is produced then y[p] will be 0.
constraint
    forall(p in 1..P) (
        x[p] >= y[p] /\ x[p] <= U * y[p]
    );

% Machine capacity constraints:
% For machine 1, the total time includes a setup time for each part produced  
constraint
    sum(p in 1..P)( SetupTime[p] * y[p] + TimeRequired[1,p] * x[p] )
    <= Availability[1];

% For machines 2...M, the production time is just the time required per batch  
constraint
    forall(m in 2..M) (
        sum(p in 1..P)( TimeRequired[m,p] * x[p] ) <= Availability[m]
    );

% Define the profit:
% Total revenue from selling batches minus the operating cost on each machine.
var int: profit = 
    sum(p in 1..P)( Prices[p] * x[p] )
    - (
         MachineCosts[1] * sum(p in 1..P)( SetupTime[p] * y[p] + TimeRequired[1,p] * x[p] )
         + sum(m in 2..M)( MachineCosts[m] * sum(p in 1..P)( TimeRequired[m,p] * x[p] ) )
      );

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Batches produced per part: ", show(x), "\n",
  "Part produced indicator (1 if produced, 0 otherwise): ", show(y), "\n"
];