% Parameters
int: NumParts;                         % Number of spare parts (K)
int: NumMachines;                      % Number of machines/shops (S)

set of int: PARTS = 1..NumParts;       % Index set for parts
set of int: MACHINES = 1..NumMachines; % Index set for machines

array[PARTS, MACHINES] of int: Time;   % Time to make 1 unit of part k on machine s (worker-hours)
array[PARTS] of int: Profit;           % Profit per unit of part k
array[MACHINES] of int: Capacity;      % Available capacity (hours) for machine s

% Variables
array[PARTS] of var int: MakeQty;      % Units of each part k to produce (nonnegative)

% Constraints
%--- Nonnegativity constraints
constraint forall(k in PARTS) (MakeQty[k] >= 0);

%--- Machine capacity constraints: total hours used on each machine cannot exceed its capacity
constraint
  forall(s in MACHINES) (
    sum(k in PARTS)(Time[k, s] * MakeQty[k]) <= Capacity[s]
  );

% Objective
solve maximize sum(k in PARTS)(Profit[k] * MakeQty[k]);