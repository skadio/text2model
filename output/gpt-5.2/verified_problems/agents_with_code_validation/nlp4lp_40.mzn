% Parameters
int: K; % Number of different spare parts
int: S; % Number of machines/shops

set of int: PARTS = 1..K;     % Index set for spare parts
set of int: MACHINES = 1..S;  % Index set for machines

array[PARTS, MACHINES] of int: Time; % Worker-hours (time) to make part k on machine s
array[PARTS] of int: Profit;         % Profit obtained from making part k
array[MACHINES] of int: Capacity;    % Capacity (available hours) of machine s

% Variables
array[PARTS] of var int: MakeQty; % Quantity of each spare part to produce in the month (integer, >= 0)
var int: TotalProfit;             % Total profit from the production plan

% Constraints
% Machine capacity constraints: total time used on each machine cannot exceed its capacity
constraint
  forall(s in MACHINES) (
    sum(k in PARTS) (Time[k, s] * MakeQty[k]) <= Capacity[s]
  );

% Non-negativity of production quantities (cannot produce negative amounts)
constraint
  forall(k in PARTS) (
    MakeQty[k] >= 0
  );

% Define total profit as the sum of per-part profit times produced quantity
constraint
  TotalProfit = sum(k in PARTS) (Profit[k] * MakeQty[k]);

% Objective
solve maximize TotalProfit;