% Parameters
int: NumParts;                       % Number of spare parts (K)
int: NumMachines;                    % Number of machines/shops (S)

set of int: PARTS = 1..NumParts;     % Index set for parts
set of int: MACHS = 1..NumMachines;  % Index set for machines

array[PARTS, MACHS] of int: Time;    % Worker-hours per unit of part k on machine s
array[PARTS] of int: Profit;         % Profit per unit of part k
array[MACHS] of int: Capacity;       % Available hours on machine s

% Variables
array[PARTS] of var int: Make;       % Units to produce of each part (non-negative integer)
var int: TotalProfit;                % Total profit to maximize

% Constraints
% --- Production non-negativity (cannot make negative units) ---
constraint
  forall(k in PARTS) (
    Make[k] >= 0
  );

% --- Machine/shop capacity constraints ---
constraint
  forall(s in MACHS) (
    sum(k in PARTS)(Time[k, s] * Make[k]) <= Capacity[s]
  );

% --- Define total profit ---
constraint
  TotalProfit = sum(k in PARTS)(Profit[k] * Make[k]);

% Objective
solve maximize TotalProfit;