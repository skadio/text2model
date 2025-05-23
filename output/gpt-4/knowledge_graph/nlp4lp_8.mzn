% Parameters
int: NumParts; % Number of Parts
int: NumMachines; % Number of Machines
array[1..NumParts, 1..NumMachines] of int: Time; % Time taken to make one unit of spare part k on machine s
array[1..NumParts] of int: Profit; % Profit from producing one unit of spare part k
array[1..NumMachines] of int: Capacity; % Capacity of machine s for the month

% Variables
array[1..NumParts] of var 0..Capacity[1]: X; % Number of each spare part to be made

% Constraints
constraint forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(Time[k,s]*X[k]) <= Capacity[s]
);

% Objective
var int: total_profit = sum(k in 1..NumParts)(Profit[k]*X[k]);
solve maximize total_profit;

% Output
output [ "Total profit: ", show(total_profit), "\n" ] ++
[ if fix(X[k]) > 0 then "Make " ++ show(X[k]) ++ " units of part " ++ show(k) ++ "\n" else "" endif | k in 1..NumParts ];