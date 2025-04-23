% Parameters
array[1..7] of int: Demand; % Array of demands for nurses for 7 days

% Variables
var int: num_nurses; % The minimal number of nurses the hospital needs to hire
array[1..7] of var 0..max(Demand): nurse_schedule; % The configuration of nurses for each day of the week

% Constraints

% The number of nurses working on each day should be at least equal to the demand for that day
constraint forall(i in 1..7) (
  nurse_schedule[i] >= Demand[i]
);

% The number of nurses working on each day should be less than or equal to the total number of nurses
constraint forall(i in 1..7) (
  nurse_schedule[i] <= num_nurses
);

% The total number of nurses working in a week should be equal to the total number of nurses times the number of days they work
constraint sum(nurse_schedule) = num_nurses * max(Demand);

% Objective
solve minimize num_nurses;