int: NumShifts;
array[1..NumShifts] of int: OfficersNeeded;
array[1..NumShifts] of int: ShiftCosts;

int: maxOfficers = sum(OfficersNeeded);

array[1..NumShifts-1] of var 0..maxOfficers: startOfficers;   % officers starting at shift s (work s and s+1)
array[1..NumShifts] of var 0..maxOfficers: shiftOfficers;     % officers on duty during shift s

% Relate startOfficers to shiftOfficers
constraint shiftOfficers[1] = startOfficers[1];
constraint forall(s in 2..NumShifts-1) (
    shiftOfficers[s] = startOfficers[s-1] + startOfficers[s]
);
constraint shiftOfficers[NumShifts] = startOfficers[NumShifts-1];

% Ensure each shift has enough officers
constraint forall(s in 1..NumShifts) (
    shiftOfficers[s] >= OfficersNeeded[s]
);

% Objective: minimize total cost
solve minimize sum(s in 1..NumShifts) shiftOfficers[s] * ShiftCosts[s];

output [
    "StartOfficers: ", show(startOfficers), "\n",
    "ShiftOfficers: ", show(shiftOfficers), "\n",
    "TotalCost: ", show(sum(s in 1..NumShifts) shiftOfficers[s] * ShiftCosts[s]), "\n"
];