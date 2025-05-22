% Parameters
int: Period;
array[1..7] of int: Demand;

% Variables
% Number of nurses starting their shift on each day
array[1..7] of var 0..max(Demand): Nurses;

% Constraints
constraint forall(i in 1..7)(
  % Total nurses working on a day should be equal to the demand
  sum(j in 1..Period)(Nurses[(i-j+7) mod 7 + 1]) >= Demand[i]
);

% Objective
% Minimize the total number of nurses
solve minimize sum(Nurses);