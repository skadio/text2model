int: NumShifts;
set of int: SHIFTS = 1..NumShifts;

array[SHIFTS] of int: OfficersNeeded;
array[SHIFTS] of int: ShiftCosts;

array[SHIFTS] of var 0..max(OfficersNeeded): StartOfficers;

constraint
  forall(s in SHIFTS) (
    StartOfficers[s] + StartOfficers[ if s = 1 then NumShifts else s - 1 endif ] >= OfficersNeeded[s]
  );

var int: TotalCost = sum(s in SHIFTS)(ShiftCosts[s] * StartOfficers[s]);

solve minimize TotalCost;

output [
  "StartOfficers = ", show(StartOfficers), ";\n",
  "TotalCost = ", show(TotalCost), ";\n"
];