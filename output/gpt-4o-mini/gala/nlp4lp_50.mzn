include "globals.mzn";

int: NumShifts;                          % Number of shifts
array[1..NumShifts] of int: OfficersNeeded;  % Required number of officers for each shift
array[1..NumShifts] of int: ShiftCosts;      % Cost of assigning an officer to each shift

/* Variables */
array[1..NumShifts] of var 0..max(OfficersNeeded): officers;  % Number of officers assigned to each shift

/* Constraints */
array[1..NumShifts] of int: values = [1..NumShifts];  % Shift indices
array[1..NumShifts] of int: occ = OfficersNeeded;      % Required number of officers for each shift
constraint global_cardinality(officers, values, occ);

/* Objective: Minimize total cost */
var int: totalCost = sum(s in 1..NumShifts)(ShiftCosts[s] * officers[s]);
solve minimize totalCost;

/* Output */
output [ "Officers assigned = ", show(officers), "\nTotal cost = ", show(totalCost), "\n" ];