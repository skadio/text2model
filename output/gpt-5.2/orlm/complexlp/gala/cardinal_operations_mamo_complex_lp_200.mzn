include "globals.mzn";

% -----------------------------
% Data (embedded from statement)
% -----------------------------
int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: initInv = 10;

int: regCap = 420;
int: otCap  = 80;

int: regCost = 40;
int: otCost  = 45;
int: holdCost = 3; % per month per wrench held (end-of-month inventory)

% Upper bounds for domains
int: maxDemand = max(demand);
int: totalDemand = sum(demand);
int: invUB = initInv + T * (regCap + otCap); % safe upper bound

% -----------------------------
% Decision variables
% -----------------------------
array[Months] of var 0..regCap: regProd;
array[Months] of var 0..otCap:  otProd;
array[Months] of var 0..invUB:  inv;      % end-of-month inventory

% -----------------------------
% Constraints: inventory balance and demand satisfaction
% inv[m] = inv[m-1] + production - demand[m]
% -----------------------------
constraint inv[1] = initInv + regProd[1] + otProd[1] - demand[1];
constraint forall(m in 2..T)(
  inv[m] = inv[m-1] + regProd[m] + otProd[m] - demand[m]
);

% Inventory cannot go negative already enforced by domain,
% which ensures monthly demand is met.

% -----------------------------
% Objective: minimize total cost
% Production costs + holding costs (end-of-month inventory)
% -----------------------------
var int: totalCost =
  sum(m in Months)(regCost * regProd[m] + otCost * otProd[m] + holdCost * inv[m]);

solve minimize totalCost;

output [
  "Minimal total cost ($) = ", show(totalCost), "\n",
  "Regular production = ", show(regProd), "\n",
  "Overtime production = ", show(otProd), "\n",
  "End inventory = ", show(inv), "\n"
];