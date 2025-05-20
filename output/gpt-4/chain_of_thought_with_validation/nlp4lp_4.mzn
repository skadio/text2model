% Parameters
int: Period;
array[1..7] of int: Demand;

% Variables
array[1..7, 1..Period] of var 0..max(Demand): Nurses;
var int: TotalNurses = sum(i in 1..7, j in 1..Period)(Nurses[i,j]);

% Constraints
constraint forall(i in 1..7)(sum(j in 1..Period)(Nurses[i,j]) >= Demand[i]);
constraint forall(i in 1..7, j in 1..Period)(if j + Period - 1 <= 7 then sum(k in j..j + Period - 1)(Nurses[i,k]) <= 1 else sum(k in j..7)(Nurses[i,k]) + sum(k in 1..j + Period - 8)(Nurses[i,k]) <= 1 endif);

% Objective
solve minimize TotalNurses;