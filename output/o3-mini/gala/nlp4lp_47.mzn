include "globals.mzn";

% Data parameters (to be provided in a .dzn file)
int: P;                           % number of parts
int: M;                           % number of machines
array[1..M, 1..P] of int: TimeRequired;   % time required per batch of part p on machine m
array[1..M] of int: MachineCosts;         % cost per hour for machine m
array[1..M] of int: Availability;           % available hours per machine m per month
array[1..P] of int: Prices;                 % selling price of one batch of part p
array[1..P] of int: MinBatches;             % minimum batches to produce for part p

% Decision variables: number of batches to produce for each part
% We set an arbitrary upper bound (e.g., 10^6) to allow sufficient production quantity.
array[1..P] of var 0..1000000: batches;

% Constraint: must produce at least the minimum required batches for each part
constraint forall(p in 1..P) (
    batches[p] >= MinBatches[p]
);

% Constraint: Machine capacity - total time used on each machine cannot exceed its availability
constraint forall(m in 1..M) (
    sum(p in 1..P)( TimeRequired[m,p] * batches[p] ) <= Availability[m]
);

% Define revenue, cost and profit
var int: revenue = sum(p in 1..P)( Prices[p] * batches[p] );
var int: cost = sum(m in 1..M)( MachineCosts[m] * sum(p in 1..P)( TimeRequired[m,p] * batches[p] ) );
var int: profit = revenue - cost;

% Solve: maximize profit
solve maximize profit;

% Output: batches for each part along with revenue, cost and profit details
output [
    "Batches: ", show(batches), "\n",
    "Revenue: ", show(revenue), "\n",
    "Cost: ", show(cost), "\n",
    "Profit: ", show(profit), "\n"
];