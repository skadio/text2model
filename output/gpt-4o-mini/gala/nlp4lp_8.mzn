include "globals.mzn";

int: NumParts;                             % Number of Parts
int: NumMachines;                           % Number of Machines
array[1..NumParts, 1..NumMachines] of int: Time;  % Time taken for each part on each machine
array[1..NumParts] of int: Profit;         % Profit from each part
array[1..NumMachines] of int: Capacity;    % Capacity of each machine

array[1..NumParts] of var 0..Capacity[1]: start; % Start times for each part
array[1..NumMachines] of var 0..Capacity[1]: usage; % Resource usage for each machine

array[1..NumParts] of int: dur = [Time[k, s] | k in 1..NumParts, s in 1..NumMachines]; % Durations based on time taken
array[1..NumParts] of int: use = [1 | k in 1..NumParts]; % Each part uses 1 unit of resource

% Cumulative constraints for each machine
constraint cumulative(start, dur, use, Capacity[1]); % Cumulative for the first machine
constraint cumulative(start, dur, use, Capacity[2]); % Cumulative for the second machine

% Objective: Maximize total profit
var int: total_profit = sum(k in 1..NumParts)(Profit[k] * (start[k] > 0 ? 1 : 0)); % Only count profit if part is produced

solve maximize total_profit;

output [ "Total Profit = ", show(total_profit), "\n" ];