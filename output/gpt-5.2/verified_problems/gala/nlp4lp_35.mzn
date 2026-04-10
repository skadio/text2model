include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: NumProducts;  % K
int: NumMachines;  % S

array[1..NumProducts, 1..NumMachines] of int: ProduceTime;  % time per unit
array[1..NumMachines] of int: AvailableTime;                % capacity per station
array[1..NumProducts] of int: Profit;                       % profit per unit

%----------------------------
% Decision variables
%----------------------------
% Upper bound per product from station capacities (safe, data-derived)
array[1..NumProducts] of int: UB =
  [ if exists(s in 1..NumMachines)(ProduceTime[k,s] > 0) then
      min([ AvailableTime[s] div ProduceTime[k,s] | s in 1..NumMachines where ProduceTime[k,s] > 0 ])
    else 0
    endif
  | k in 1..NumProducts ];

array[1..NumProducts] of var 0..max(0, max(UB)): qty;  % quantity to produce

% Tighten individual domains using UB
constraint forall(k in 1..NumProducts)(qty[k] <= UB[k]);

%----------------------------
% Production capacity constraints
%----------------------------
constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumProducts)(ProduceTime[k,s] * qty[k]) <= AvailableTime[s]
  );

%----------------------------
% Objective: maximize profit
%----------------------------
var int: totalProfit = sum(k in 1..NumProducts)(Profit[k] * qty[k]);

solve maximize totalProfit;

%----------------------------
% Output
%----------------------------
output [
  "qty = ", show(qty), "\n",
  "totalProfit = ", show(totalProfit), "\n",
  "machine_usage = ", show([ sum(k in 1..NumProducts)(ProduceTime[k,s] * qty[k]) | s in 1..NumMachines ]), "\n"
];