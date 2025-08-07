int: K;  % Number of different spare parts
int: S;  % Number of machines
array[1..K, 1..S] of int: Time;  % Time taken to make spare part k on machine s
array[1..K] of int: Profit;  % Profit obtained from making spare part k
array[1..S] of int: Capacity;  % Capacity of machine s for the spare parts

array[1..K] of var 0..Capacity[s]: quantity;  % Quantity of each spare part to be made

% Constraints to ensure that the total time on each machine does not exceed its capacity
array[1..S] of var 0..sum(Profit): total_profit;  % Total profit variable for each machine

% For each machine, ensure the total time does not exceed capacity
constraint forall(s in 1..S)(
    sum(k in 1..K)(Time[k, s] * quantity[k]) <= Capacity[s]
);

% Objective: Maximize total profit
var 0..sum(Profit): total_profit;
constraint total_profit = sum(k in 1..K)(Profit[k] * quantity[k]);

solve maximize total_profit;

output [ "Quantity = ", show(quantity), "\nTotal Profit = ", show(total_profit), "\n" ];