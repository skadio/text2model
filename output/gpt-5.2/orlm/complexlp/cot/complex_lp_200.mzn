% Parameters (with values embedded)
int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: initInv = 10;

int: regCap = 420;
int: otCap  = 80;

int: regCost = 40;
int: otCost  = 45;
int: holdCost = 3;

% Variable upper bounds (safe big-M style bounds)
int: maxDemand = max(demand);
int: invUB = initInv + sum(m in Months)(regCap + otCap) - sum(m in Months)(demand); % end inventory max if always produce max
int: invUB2 = initInv + sum(m in Months)(regCap + otCap); % safe upper bound for any intermediate inventory
int: invMax = max(invUB2, 0);

% Variables
array[Months] of var 0..regCap: regProd;
array[Months] of var 0..otCap:  otProd;
array[Months] of var 0..invMax: invEnd;

% Constraints
constraint
  forall(m in Months) (
    (if m = 1 then initInv else invEnd[m-1] endif)
    + regProd[m] + otProd[m]
    = demand[m] + invEnd[m]
  );

% Objective
var int: totalCost =
  sum(m in Months)(regCost * regProd[m] + otCost * otProd[m] + holdCost * invEnd[m]);

solve minimize totalCost;

output [
  "Minimal total cost (USD): ", show(totalCost), "\n"
];