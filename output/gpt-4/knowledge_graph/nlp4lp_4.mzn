% Parameters
int: Period; % The planning period for nurse staffing
array[1..7] of int: Demand; % Array of demands for nurses for 7 days

% Variables
array[1..7] of var 0..max(Demand): Nurses; % Number of nurses working on each day
var int: TotalNurses; % Total number of nurses

% Constraints
constraint forall(i in 1..7)(
  Nurses[i] >= Demand[i] % The number of nurses working on each day should be greater than or equal to the demand
);

constraint forall(i in 1..7)(
  Nurses[i] = Nurses[(i + Period - 1) mod 7 + 1] % The number of nurses working on a day should be the same as the number of nurses working on the day 'Period' days before
);

constraint TotalNurses = sum(Nurses); % The total number of nurses is the sum of nurses working on each day

% Objective
solve minimize TotalNurses; % Minimize the total number of nurses

% Output
output ["Total Nurses: ", show(TotalNurses), "\n"] ++
["Nurses: ", show(Nurses), "\n"];