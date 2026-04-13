% Parameters
int: costX = 5000;                 % Cost per unit of product X (dollars)
int: costY = 3000;                 % Cost per unit of product Y (dollars)
int: capacity = 1000;              % Max total units of X + Y
int: demand = 2000;                % Minimum required value of 3*X + 2*Y
int: min_diff = 150;               % Minimum required difference X - Y

% Variables
var 0..capacity: unitsX;           % Units produced of product X (integer, non-negative)
var 0..capacity: unitsY;           % Units produced of product Y (integer, non-negative)
var 0..(costX*capacity + costY*capacity): totalCost;  % Total production cost (dollars)

% Constraints
% Link total cost to production quantities
constraint totalCost = costX * unitsX + costY * unitsY;

% Capacity constraint: total units produced cannot exceed capacity
constraint unitsX + unitsY <= capacity;

% Demand constraint: ensure market demand requirement is met
constraint 3 * unitsX + 2 * unitsY >= demand;

% Portfolio balance constraint: enforce minimum difference between X and Y
constraint unitsX - unitsY >= min_diff;

% Objective
solve minimize totalCost;