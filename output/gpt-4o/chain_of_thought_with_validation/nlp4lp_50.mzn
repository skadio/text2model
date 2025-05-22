% Parameters
int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

% Derived Parameters
int: MaxOfficers = sum(s in 1..NumShifts)(OfficersNeeded[s]);

% Variables
array[1..NumShifts] of var 0..MaxOfficers: OfficersStarting;
var int: TotalCost;

% Constraints
constraint
    TotalCost = sum(s in 1..NumShifts)(OfficersStarting[s] * ShiftCosts[s]);

constraint
    forall(s in 1..NumShifts)(
        OfficersStarting[s] + 
        OfficersStarting[ if s == 1 then NumShifts else s - 1 endif ]
        >= OfficersNeeded[s]
    );

% Objective
solve minimize TotalCost;