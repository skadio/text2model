% Parameters
int: Period;
array[1..7] of int: Demand;

% Decision Variables
array[1..7] of var 0..max(Demand): Nurses; % Number of nurses working each day
var int: TotalNurses; % Total number of nurses needed

% Constraints
constraint forall(i in 1..7)(
  sum(j in max(1, i - Period + 1)..i)(Nurses[j mod 7 + 1]) >= Demand[i]
);

constraint TotalNurses = sum(Nurses);

% Objective
solve minimize TotalNurses;

% Output
output [ "Total Nurses: " ++ show(TotalNurses) ++ "\n" ] ++
[ if fix(Nurses[i]) > 0 then "Day " ++ show(i) ++ ": " ++ show(Nurses[i]) ++ " nurses\n" else "" endif | i in 1..7 ];