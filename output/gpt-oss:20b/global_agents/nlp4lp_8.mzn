include "globals.mzn";

int: NumParts;      % number of different spare parts
int: NumMachines;   % number of machines

array[1..NumParts, 1..NumMachines] of int: Time;    % time to produce one unit of part k on machine s
array[1..NumParts]                 of int: Profit;  % profit per unit of part k
array[1..NumMachines]              of int: Capacity; % available machine hours

/* Upper bound for each part (from the most limiting machine) */
array[1..NumParts] of int: upper =
  [min([Capacity[s] div Time[k,s] | s in 1..NumMachines]) | k in 1..NumParts];

array[1..NumParts] of var 0..upper[k] : produce;   % number of units to produce

/* Capacity constraints: each machine’s total used hours ≤ its capacity */
constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(produce[k] * Time[k,s]) <= Capacity[s]
  );

/* Total profit */
var int: totalProfit = sum(k in 1..NumParts)(produce[k] * Profit[k]);

solve maximize totalProfit;

/* Output the solution */
output [
  "Production: ", show(produce), "\n",
  "Maximum Profit: ", show(totalProfit), "\n"
];