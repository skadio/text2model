% Model for maximizing profit in spare part production subject to machine capacity constraints

% Data parameters (provided in the .dzn file)
int: NumParts;                                   % Number of parts
int: NumMachines;                                % Number of machines (shops)
array[1..NumParts, 1..NumMachines] of int: Time;  % Time[k,s]: working hours required for producing one unit of part k on machine s
array[1..NumParts] of int: Profit;               % Profit[k]: profit per unit of part k
array[1..NumMachines] of int: Capacity;          % Capacity[s]: maximum working hours available for machine s

% Decision variables: number of units to produce for each part.
% Domain is set to 0..10000 as a safe upper bound.
array[1..NumParts] of var 0..10000: produce;

% For each machine s, ensure that the total time spent on production does not exceed its capacity.
constraint 
    forall(s in 1..NumMachines) (
         sum(k in 1..NumParts)( Time[k, s] * produce[k] ) <= Capacity[s]
    );

% Define total profit as the weighted sum of production quantities.
var int: totalProfit = sum(k in 1..NumParts)( Profit[k] * produce[k] );

% Solve: maximize the total profit.
solve maximize totalProfit;

% Output the production plan and the total profit.
output [
    "Production Plan = ", show(produce), "\nTotal Profit = ", show(totalProfit), "\n"
];