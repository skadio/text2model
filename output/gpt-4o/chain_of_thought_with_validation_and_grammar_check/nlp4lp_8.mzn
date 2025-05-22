% Parameters
int: NumParts;
int: NumMachines;

set of int: K = 1..NumParts;          % Parts
set of int: S = 1..NumMachines;       % Machines

array[K,S] of int: Time;              % Time[k,s]
array[K]   of int: Profit;            % Profit[k]
array[S]   of int: Capacity;          % Capacity[s]

% Upper bounds for each part (maximum producible on the most limiting machine)
array[K] of int: UB =
  [ min( [ Capacity[s] div Time[k,s] | s in S ] ) | k in K ];

int: MaxUB = max(UB);

% Variables
array[K] of var 0..MaxUB: Qty;        % Quantity of each part k to produce

% Constraints
constraint forall(k in K)( Qty[k] <= UB[k] );

constraint
  forall(s in S)(
    sum(k in K)( Time[k,s] * Qty[k] ) <= Capacity[s]
  );

% Objective
var int: TotalProfit = sum(k in K)( Profit[k] * Qty[k] );

solve maximize TotalProfit;