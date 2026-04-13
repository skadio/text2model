include "globals.mzn";

%======================
% Input data (.dzn)
%======================
int: P;                              % number of parts
int: M;                              % number of machines
array[1..M, 1..P] of int: TimeRequired;  % hours on machine m for 1 batch of part p
array[1..M] of int: MachineCosts;        % cost per hour for machine m
array[1..M] of int: Availability;        % available hours per month for machine m
array[1..P] of int: Prices;              % selling price per batch of part p
array[1..P] of int: MinBatches;          % minimum batches required for part p

%======================
% Decision variables
%======================
% Safe upper bound on batches from machine capacities
function int: ub_part(int: p) =
  min([ if TimeRequired[m,p] = 0 then 1000000000 else Availability[m] div TimeRequired[m,p] endif
        | m in 1..M ]);

array[1..P] of int: UB = [ub_part(p) | p in 1..P];

array[1..P] of var int: Batches;
constraint forall(p in 1..P)(
  Batches[p] >= MinBatches[p] /\ Batches[p] <= UB[p]
);

%======================
% Machine capacity constraints
%======================
constraint forall(m in 1..M)(
  sum(p in 1..P)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
);

%======================
% Objective: maximize profit
% Profit = revenue - operating costs
%======================
var int: Revenue = sum(p in 1..P)( Prices[p] * Batches[p] );

var int: TotalCost =
  sum(m in 1..M)(
    MachineCosts[m] * sum(p in 1..P)( TimeRequired[m,p] * Batches[p] )
  );

var int: Profit = Revenue - TotalCost;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Revenue = ", show(Revenue), "\n",
  "TotalCost = ", show(TotalCost), "\n",
  "Profit = ", show(Profit), "\n"
];