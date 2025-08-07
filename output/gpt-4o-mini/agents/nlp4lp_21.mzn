include "globals.mzn";

int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit; % Profit for each product
array[1..K, 1..M] of float: Time; % Time taken by product on each machine
array[1..I, 1..M] of int: Maintain; % Maintenance time for machines
array[1..K, 1..I] of int: Limit; % Limit of storing products
float: StorePrice; % Price for storing products
array[1..K] of int: KeepQuantity; % Minimum stock to keep
float: WorkHours; % Number of working hours

% Define the total number of tasks (products)
int: n = K * I; % Total number of tasks (products over time periods)
array[1..n] of var 0..WorkHours * 24: start; % Start times for each product
array[1..n] of int: dur; % Durations for each product
array[1..n] of int: use; % Resource usage for each product
int: cap = sum(NumMachines); % Maximum capacity of machines available

% Define the durations and resource usages for each product in each time period
array[1..n] of int: dur = [1 | k in 1..K, i in 1..I]; % Example duration, can be adjusted
array[1..n] of int: use = [sum(Time[k, m] | m in 1..M) | k in 1..K]; % Total time required for each product

% Cumulative constraint to ensure that the total usage does not exceed the available machine capacity
constraint cumulative(start, dur, use, cap);

% Objective function: Maximize profit
var int: total_profit = sum(Profit[k] * (sum(start[i] | i in 1..I) * (1 - StorePrice)) | k in 1..K);
solve maximize total_profit;

% Output the results
output [ "Total Profit = ", show(total_profit), "\n" ];