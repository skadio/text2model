% Parameters
int: K; % Number of different spare parts
int: S; % Number of machines capable of making the spare parts
array[1..K] of int: Profit; % Profit obtained from making spare part k
array[1..S] of int: Capacity; % Capacity of machine s for the spare parts
array[1..K, 1..S] of int: Time; % Time taken to make spare part k on machine s

% Variables
array[1..K] of var 0..Capacity[S]: Parts; % Quantity of each spare part to be made

% Constraints
constraint forall(s in 1..S)(
  sum(k in 1..K)(Time[k, s] * Parts[k]) <= Capacity[s]
);

% Objective
var int: total_profit = sum(k in 1..K)(Profit[k] * Parts[k]);
solve maximize total_profit;

% Output
output [ "Total profit: ", show(total_profit), "\n" ] ++
[ if fix(Parts[k]) > 0 then "Make " ++ show(Parts[k]) ++ " of part " ++ show(k) ++ "\n" else "" endif | k in 1..K ];