% Production planning with activation costs and minimum batch sizes
% Data embedded from the problem statement.

include "globals.mzn";

% ---------- Sets ----------
int: P = 3;
set of int: Products = 1..P;

% ---------- Data (per 100kg unit unless stated otherwise) ----------
int: days = 22;

array[Products] of int: maxDemand = [5300, 4500, 5400];         % units of 100kg
array[Products] of int: quotaPerDay = [500, 450, 550];          % max units/day if devoted to product
array[Products] of int: minBatch = [20, 20, 16];                % minimum production if activated (units)
array[Products] of int: price = [124, 109, 115];                % $ per unit

% Use cents to avoid floating point:
array[Products] of int: costCents = [7330, 5290, 6540];         % $73.30 etc. -> cents
array[Products] of int: activationCost = [170000, 150000, 100000]; % $ fixed per product activated

array[Products] of int: marginCents = [ (price[i] * 100) - costCents[i] | i in Products ];

% Maximum possible total production per product across the month (cannot exceed demand anyway)
array[Products] of int: maxByCapacity = [days * quotaPerDay[i] | i in Products];

% ---------- Decision variables ----------
array[Products] of var 0..maxDemand[1]: x1; % placeholder to help define x cleanly (not used)
array[Products] of var int: x;              % production quantity (units of 100kg)

array[Products] of var 0..1: y;             % 1 if product is activated/produced, else 0

% Bound x properly (MiniZinc needs concrete domains):
constraint forall(i in Products) (
  x[i] >= 0 /\
  x[i] <= min(maxDemand[i], maxByCapacity[i])
);

% ---------- Constraints ----------
% Activation and minimum batch: if y[i]=0 then x[i]=0; if y[i]=1 then x[i] in [minBatch[i], ...]
constraint forall(i in Products) (
  x[i] >= minBatch[i] * y[i]
);

constraint forall(i in Products) (
  x[i] <= min(maxDemand[i], maxByCapacity[i]) * y[i]
);

% Demand already enforced by x upper bound; capacity already enforced by maxByCapacity bound.

% ---------- Objective ----------
% Maximize profit = sum (margin * quantity) - sum (activation cost * y)
var int: profitCents =
  sum(i in Products)( marginCents[i] * x[i] ) - sum(i in Products)( activationCost[i] * y[i] );

solve maximize profitCents;

% ---------- Output ----------
output [
  "Production plan (units of 100kg):\n",
  "A1 = ", show(x[1]), "  activated=", show(y[1]), "\n",
  "A2 = ", show(x[2]), "  activated=", show(y[2]), "\n",
  "A3 = ", show(x[3]), "  activated=", show(y[3]), "\n",
  "Profit = $", show(profitCents div 100), ".", 
              if (profitCents mod 100) < 10 then "0" else "" endif, 
              show(profitCents mod 100), "\n"
];