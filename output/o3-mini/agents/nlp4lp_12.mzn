% Data declarations (provided in the .dzn file)
int: T;                           % Total number of periods
array[1..T] of int: Deliver;      % Demand that must be delivered at end of each period
int: StorageCost;                 % Storage cost per unit per period
int: SwitchCost;                  % Cost per unit change in production between periods

% Define an upper-bound for production and inventory.
% A safe (though loose) bound is the total demand over all periods.
int: M = sum(i in 1..T)(Deliver[i]);

% Decision variables
array[1..T] of var 0..M: prod;    % Production quantities in each period
array[0..T] of var 0..M: inv;      % Inventory levels; inv[0] is the initial inventory

% Inventory balance constraints
constraint inv[0] = 0;
constraint forall(i in 1..T) (
    inv[i] = inv[i-1] + prod[i] - Deliver[i] /\ inv[i] >= 0
);

% Objective: Minimize the total cost, which consists of:
% 1. Storage cost: incurred for inventory held at the end of every period EXCEPT the final one.
% 2. Production switching cost: incurred for the absolute difference in production levels between consecutive periods.
var int: totalCost =
    sum(i in 1..T-1)( StorageCost * inv[i] ) +
    sum(i in 1..T-1)( SwitchCost * abs(prod[i+1] - prod[i]) );

solve minimize totalCost;

% Output production and inventory decisions, along with the total cost.
output [
    "Production: ", show(prod), "\n",
    "Inventory:  ", show(inv[1..T]), "\n",
    "Total Cost: ", show(totalCost), "\n"
];