int: NumShifts;
set of int: S = 1..NumShifts;

array[S] of int: OfficersNeeded;
array[S] of int: ShiftCosts;

array[S] of var 0..sum(OfficersNeeded): StartOfficers;

constraint
  forall(s in S) (
    StartOfficers[s] + StartOfficers[if s = 1 then NumShifts else s - 1 endif] >= OfficersNeeded[s]
  );

var int: TotalCost = sum(s in S)(ShiftCosts[s] * StartOfficers[s]);

solve minimize TotalCost;

output [
  "StartOfficers = ", show(StartOfficers), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];