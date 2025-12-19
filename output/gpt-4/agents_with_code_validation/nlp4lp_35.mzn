% Parameters
int: NumProducts; % Number of different products
int: NumMachines; % Number of different machines or stations
array[1..NumProducts, 1..NumMachines] of int: ProduceTime; % Time to produce one unit of product k on station s
array[1..NumMachines] of int: AvailableTime; % Total available time on station s
array[1..NumProducts] of int: Profit; % Profit from producing one unit of product k

% Variables
array[1..NumProducts] of var 0..max(Profit): quantities; % Quantities of each product to be produced

% Constraints

% The total time spent on each machine should not exceed the available time
constraint forall(s in 1..NumMachines)(
  sum(k in 1..NumProducts)(ProduceTime[k,s]*quantities[k]) <= AvailableTime[s]
);

% The quantity of each product should be non-negative
constraint forall(k in 1..NumProducts)(
  quantities[k] >= 0
);

% Objective
solve maximize sum(k in 1..NumProducts)(Profit[k]*quantities[k]);