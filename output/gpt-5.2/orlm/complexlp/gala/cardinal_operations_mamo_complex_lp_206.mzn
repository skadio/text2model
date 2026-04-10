% Sailco production planning (4 quarters) - minimize production + holding cost
include "globals.mzn";

%-----------------------------
% Data (embedded from statement)
%-----------------------------
int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: initInv = 10;

int: regCap = 40;
int: regCost = 400;
int: otCost  = 450;
int: holdCost = 20;

% A safe upper bound for overtime production in any quarter:
% total demand minus initial inventory is the total to produce.
int: totalDemand = sum(t in QUARTERS)(demand[t]);
int: maxOT = totalDemand; % generous bound

%-----------------------------
% Decision variables
%-----------------------------
array[QUARTERS] of var 0..regCap: regProd;
array[QUARTERS] of var 0..maxOT: otProd;
array[0..Q] of var 0..(initInv + totalDemand): inv; % inv[t] = ending inventory after quarter t

%-----------------------------
% Constraints (inventory balance, meet demand on time)
%-----------------------------
constraint inv[0] = initInv;

constraint forall(t in QUARTERS) (
  inv[t] = inv[t-1] + regProd[t] + otProd[t] - demand[t]
);

% Must meet demand on time => ending inventory nonnegative already ensures this given balance.
constraint forall(t in QUARTERS)(inv[t] >= 0);

%-----------------------------
% Objective: production + holding costs
% Holding cost incurred at end of each quarter for inventory inv[t]
%-----------------------------
var int: totalCost =
    sum(t in QUARTERS)(regCost * regProd[t] + otCost * otProd[t] + holdCost * inv[t]);

solve minimize totalCost;

output [
  "Regular production: ", show(regProd), "\n",
  "Overtime production: ", show(otProd), "\n",
  "Ending inventory (q0..q4): ", show(inv), "\n",
  "Total cost: ", show(totalCost), "\n"
];