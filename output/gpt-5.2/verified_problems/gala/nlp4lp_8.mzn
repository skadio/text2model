include "globals.mzn";

%========================
% Data (from .dzn)
%========================
int: NumParts;      % K
int: NumMachines;   % S

array[1..NumParts, 1..NumMachines] of int: Time;   % hours per unit
array[1..NumParts] of int: Profit;                 % profit per unit
array[1..NumMachines] of int: Capacity;            % available hours

%========================
% Decision variables
%========================
% Units produced of each part (nonnegative integer).
% Upper bound: cannot exceed the tightest machine capacity / time requirement.
array[1..NumParts] of var 0..max(
  [ if exists(s in 1..NumMachines)(Time[k,s] > 0) then
      min([ Capacity[s] div Time[k,s] | s in 1..NumMachines where Time[k,s] > 0 ])
    else
      0
    endif
  | k in 1..NumParts ]
): x;

%========================
% Constraints
%========================
% Machine capacity constraints: total hours used on each machine cannot exceed capacity.
constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(Time[k,s] * x[k]) <= Capacity[s]
  );

%========================
% Objective
%========================
var int: total_profit = sum(k in 1..NumParts)(Profit[k] * x[k]);

solve maximize total_profit;

%========================
% Output
%========================
output [
  "Units per part (x) = ", show(x), "\n",
  "Total profit = ", show(total_profit), "\n",
  "Machine hours used = ", show([ sum(k in 1..NumParts)(Time[k,s]*x[k]) | s in 1..NumMachines ]), "\n"
];