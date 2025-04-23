% Parameters
int: NumParts; % Number of Parts
int: NumMachines; % Number of Machines
array[1..NumParts, 1..NumMachines] of int: Time; % The time taken to make one unit of spare part k on machine s
array[1..NumParts] of int: Profit; % Profit from producing one unit of spare part k
array[1..NumMachines] of int: Capacity; % Capacity of machine s for the month

% Variables
array[1..NumParts] of var 0..Capacity[1]: PartsProduced; % Number of each spare part to be produced

% Constraints

% The total time spent on each machine should not exceed its capacity
constraint forall(s in 1..NumMachines) (
    sum(k in 1..NumParts) (Time[k, s] * PartsProduced[k]) <= Capacity[s]
);

% The number of parts produced should be non-negative
constraint forall(k in 1..NumParts) (
    PartsProduced[k] >= 0
);

% Objective
solve maximize sum(k in 1..NumParts) (Profit[k] * PartsProduced[k]);