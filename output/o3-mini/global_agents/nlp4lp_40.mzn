% Include any required global constraint libraries
include "globals.mzn";

% Input data declarations (data provided via .dzn file)
int: K;                              % Number of spare parts
int: S;                              % Number of machines
array[1..K, 1..S] of int: Time;       % Time required for each spare part on each machine
array[1..K] of int: Profit;           % Profit obtained per spare part produced
array[1..S] of int: Capacity;         % Capacity (in worker-hours) available for each machine

% Upper bound for production quantities (a safe overestimate)
% We use the total capacity over all machines as a coarse upper bound.
int: QUB = sum(s in 1..S)(Capacity[s]);

% Decision variables: quantity of each spare part to produce (nonnegative integers)
array[1..K] of var 0..QUB: Q;

% Machine capacity constraints:
% For each machine s, the total time required by all produced spare parts cannot exceed its capacity.
constraint
  forall(s in 1..S) (
    sum(k in 1..K)( Q[k] * Time[k,s] ) <= Capacity[s]
  );

% Objective: maximize the total profit
var int: total_profit = sum(k in 1..K)( Profit[k] * Q[k] );

solve maximize total_profit;

% Output: production quantities and the total profit
output [
  "Production Quantities: ", show(Q), "\n",
  "Total Profit: ", show(total_profit), "\n"
];