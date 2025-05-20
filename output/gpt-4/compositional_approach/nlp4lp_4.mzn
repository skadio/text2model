% Parameters
int: Period; % The planning period for nurse staffing
array[1..7] of int: Demand; % Array of demands for nurses for 7 days

% Variables
var int: num_nurses; % The minimal number of nurses the hospital needs to hire
array[1..7] of var 0..Period: nurse_schedule; % The configuration of nurses for each day of the week

% Constraints

% The number of nurses working on each day of the week should be at least equal to the demand for that day
constraint forall(i in 1..7) (
  nurse_schedule[i] >= Demand[i]
);

% The total number of nurses working in a week should be equal to the total number of nurses hired
constraint sum(nurse_schedule) = num_nurses;

% The number of nurses working on any day should not exceed the total number of nurses hired
constraint forall(i in 1..7) (
  nurse_schedule[i] <= num_nurses
);

% The number of nurses working on any day should be less than or equal to the number of nurses working on the previous day plus the number of nurses starting their work on that day
constraint forall(i in 2..7) (
  nurse_schedule[i] <= nurse_schedule[i-1] + nurse_schedule[if i-1=1 then 7 else i-1 endif]
);

% The number of nurses working on the first day should be less than or equal to the number of nurses working on the last day plus the number of nurses starting their work on the first day
constraint nurse_schedule[1] <= nurse_schedule[7] + nurse_schedule[7];

% Objective
solve minimize num_nurses;