include "globals.mzn";

%----------------------%
% Input data (.dzn)    %
%----------------------%
int: T;
array[1..T] of int: Deliver;      % demand at end of each period
int: StorageCost;                  % cost per unit carried per period
int: SwitchCost;                   % cost per unit change in production between periods

%----------------------%
% Variable bounds      %
%----------------------%
int: totalDemand = sum(i in 1..T)(Deliver[i]);

% A safe upper bound: can produce up to all demand in any single period
int: maxProd = totalDemand;

array[1..T] of var 0..maxProd: Prod;              % production in period i
array[0..T] of var 0..totalDemand: Inv;           % inventory at end of period i (Inv[0]=0)
array[1..T-1] of var 0..maxProd: SwitchAbs;       % |Prod[i+1]-Prod[i]| (for i=1..T-1)

%----------------------%
% Constraints          %
%----------------------%
constraint Inv[0] = 0;

% Inventory balance: Inv[i] = Inv[i-1] + Prod[i] - Deliver[i], and no backlogging
constraint forall(i in 1..T) (
  Inv[i] = Inv[i-1] + Prod[i] - Deliver[i]
);

% Absolute change in production (switching cost)
constraint forall(i in 1..T-1) (
  SwitchAbs[i] >= Prod[i+1] - Prod[i] /\
  SwitchAbs[i] >= Prod[i] - Prod[i+1]
);

% End-of-year inventory has no value and no further storage cost.
% (Allowed to be positive; will be discouraged by production + prior storage costs.)

%----------------------%
% Objective            %
%----------------------%
var int: storageCostTotal = StorageCost * sum(i in 1..T-1)(Inv[i]); % no cost for Inv[T]
var int: switchCostTotal  = SwitchCost  * sum(i in 1..T-1)(SwitchAbs[i]);
var int: prodCostTotal    = sum(i in 1..T)(Prod[i]);               % unit production cost = 1

var int: TotalCost = prodCostTotal + storageCostTotal + switchCostTotal;

solve minimize TotalCost;

%----------------------%
% Output               %
%----------------------%
output [
  "TotalCost = ", show(TotalCost), "\n",
  "Prod = ", show(Prod), "\n",
  "Inv(end of period) = ", show([Inv[i] | i in 1..T]), "\n",
  "ProdCost = ", show(prodCostTotal), "\n",
  "StorageCost = ", show(storageCostTotal), "\n",
  "SwitchCost = ", show(switchCostTotal), "\n"
];