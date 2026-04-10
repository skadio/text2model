% Parameters
int: NumProducts;                       % Number of products (K)
int: NumMachines;                       % Number of machines/stations (S)

set of int: K = 1..NumProducts;         % Product index set
set of int: S = 1..NumMachines;         % Station index set

array[K, S] of int: ProduceTime;        % Time for 1 unit of product k on station s
array[S] of int: AvailableTime;         % Total available time on station s
array[K] of int: Profit;                % Profit per unit of product k


% Variables
array[K] of var int: QtyProduced;       % Quantity produced of each product (non-negative integer)
var int: TotalProfit;                   % Total profit (objective helper)


% Constraints

% Non-negativity of production quantities
constraint
  forall(k in K) (
    QtyProduced[k] >= 0
  );

% Machine/station capacity constraints
constraint
  forall(s in S) (
    sum(k in K) (ProduceTime[k, s] * QtyProduced[k]) <= AvailableTime[s]
  );

% Define total profit
constraint
  TotalProfit = sum(k in K) (Profit[k] * QtyProduced[k]);


% Objective
solve maximize TotalProfit;