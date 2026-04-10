% Parameters
int: K; % Number of different spare parts
int: S; % Number of machines/shops

set of int: PARTS = 1..K;    % Index set for spare parts
set of int: MACHINES = 1..S; % Index set for machines

array[PARTS, MACHINES] of int: Time; % Worker-hours (time) to make part k on machine s
array[PARTS] of int: Profit;         % Profit per unit of spare part k
array[MACHINES] of int: Capacity;    % Available capacity (hours) on machine s


% Variables
array[PARTS] of var int: MakeQty; % Quantity to produce of each spare part (integer)


% Constraints
% Non-negativity constraints
constraint forall(k in PARTS) (MakeQty[k] >= 0);

% Machine capacity constraints: total time used on each machine cannot exceed capacity
constraint
  forall(s in MACHINES) (
    sum(k in PARTS) (Time[k, s] * MakeQty[k]) <= Capacity[s]
  );


% Objective
solve maximize sum(k in PARTS) (Profit[k] * MakeQty[k]);