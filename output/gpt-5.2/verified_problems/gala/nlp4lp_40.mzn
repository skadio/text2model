include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: K;                          % number of spare parts
int: S;                          % number of machines/shops
array[1..K, 1..S] of int: Time;  % worker-hours per unit: part k on machine s
array[1..K] of int: Profit;      % profit per unit of part k
array[1..S] of int: Capacity;    % available hours on machine s

%----------------------------
% Decision variables
%----------------------------
% Quantity to produce of each part (nonnegative integer).
% Upper bound: for each part, limited by the tightest machine capacity/time.
function int: ub_part(int: k) =
  min([ if Time[k,s] > 0 then Capacity[s] div Time[k,s] else 0 endif | s in 1..S ]);

array[1..K] of var 0..max(0, max([ub_part(k) | k in 1..K])): x;

%----------------------------
% Constraints (machine capacities)
%----------------------------
constraint
  forall(s in 1..S)(
    sum(k in 1..K)( Time[k,s] * x[k] ) <= Capacity[s]
  );

%----------------------------
% Objective: maximize total profit
%----------------------------
var int: total_profit = sum(k in 1..K)( Profit[k] * x[k] );

solve maximize total_profit;

%----------------------------
% Output
%----------------------------
output [
  "x = ", show(x), "\n",
  "total_profit = ", show(total_profit), "\n",
  "machine_usage = ", show([ sum(k in 1..K)(Time[k,s] * x[k]) | s in 1..S ]), "\n"
];