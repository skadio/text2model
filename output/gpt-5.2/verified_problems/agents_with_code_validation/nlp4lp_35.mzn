% Parameters
int: NumProducts; % Number of products (K)
int: NumMachines; % Number of machines/stations (S)

set of int: K = 1..NumProducts; % Product index set
set of int: S = 1..NumMachines; % Station index set

array[K, S] of int: ProduceTime; % Time per unit of product k on station s
array[S] of int: AvailableTime;  % Total available time on station s
array[K] of int: Profit;         % Profit per unit of product k

% Variables
array[K] of var int: Quantity; % Units to produce of each product k (non-negative)
var int: TotalProfit;          % Total profit to maximize

% Constraints
% Non-negativity of production quantities
constraint forall(k in K)(Quantity[k] >= 0);

% Explicit safe upper bounds for quantities (derived from station capacities).
% If a product has ProduceTime=0 on all stations, the min(...) list is empty and we cap at 0.
constraint
  forall(k in K)(
    Quantity[k] <=
      min([AvailableTime[s] div ProduceTime[k,s] | s in S where ProduceTime[k,s] > 0] ++ [0])
  );

% Define total profit
constraint TotalProfit = sum(k in K)(Profit[k] * Quantity[k]);

% Machine/station capacity constraints:
% Total time used on each station by all products cannot exceed the available time.
constraint
  forall(s in S) (
    sum(k in K) (ProduceTime[k, s] * Quantity[k]) <= AvailableTime[s]
  );

% Objective
solve maximize TotalProfit;