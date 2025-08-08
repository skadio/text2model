include "globals.mzn";

int: Period;                          % Planning period for nurse staffing
array[1..7] of int: Demand;           % Demand for nurses for each day of the week

int: total_days = 7;                  % Total days in a week
array[1..total_days] of var 0..Period: nurses; % Number of nurses assigned to each day

% Constraints to ensure that the demand is met
constraint forall(d in 1..total_days)( nurses[d] >= Demand[d] );

% Objective: Minimize the total number of nurses hired
var 0..Period: total_nurses = sum(nurses);
solve minimize total_nurses;

% Output the results
output [ "Nurses per day = ", show(nurses), "\nTotal nurses hired = ", show(total_nurses), "\n" ];