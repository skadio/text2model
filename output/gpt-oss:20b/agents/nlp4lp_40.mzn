%--------------------------------------------------------------------
% Production planning – maximize profit under machine capacity limits
%--------------------------------------------------------------------
include "globals.mzn";

int: K;                        % number of spare‑part types
int: S;                        % number of machines

array[1..K, 1..S] of int: Time;     % time required for part k on machine s
array[1..K]       of int: Profit;   % profit per part k
array[1..S]       of int: Capacity; % available machine hours for machine s

% Decision variables – quantities of each part to produce
array[1..K] of var 0..100000: qty;

% Capacity constraints
constraint forall(s in 1..S)(
    sum(k in 1..K) qty[k] * Time[k,s] <= Capacity[s]
);

% Profit to maximize
var int: totalProfit = sum(k in 1..K) qty[k] * Profit[k];

solve maximize totalProfit;

% Output
output [
  "Quantities: ", show(qty), "\n",
  "Total Profit: ", show(totalProfit), "\n"
];