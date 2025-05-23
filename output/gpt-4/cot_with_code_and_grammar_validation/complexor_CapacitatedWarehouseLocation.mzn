% Parameters
int: Period;
array[1..7] of int: Demand;

% Variables
array[1..7] of var 0..max(Demand): Nurses;
var int: TotalNurses = sum(Nurses);

% Constraints
constraint forall(i in 1..7)(
  Nurses[i] >= Demand[i]
);

constraint forall(i in 1..7)(
  Nurses[i] <= Nurses[if i - Period >= 1 then i - Period else 7 + (i - Period) endif] + Demand[i]
);

% Objective
solve minimize TotalNurses;