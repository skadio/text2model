% Parameters
int: K; % Number of different spare parts
int: S; % Number of machines capable of making the spare parts
array[1..K, 1..S] of int: Time; % Time taken to make spare part k on machine s
array[1..K] of int: Profit; % Profit obtained from making spare part k
array[1..S] of int: Capacity; % Capacity of machine s for the spare parts

% Variables
array[1..K, 1..S] of var 0..max(Capacity): Quantity; % Quantity of each spare part to be made

% Constraints
constraint forall(s in 1..S)(
  sum(k in 1..K)(Time[k, s] * Quantity[k, s]) <= Capacity[s]
);

% Objective
var int: TotalProfit = sum(k in 1..K, s in 1..S)(Profit[k] * Quantity[k, s]);
solve maximize TotalProfit;