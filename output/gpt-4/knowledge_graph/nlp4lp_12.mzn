% Parameters
int: T; % Total number of periods
array[1..T] of int: Deliver; % Demand for the product in each period i
int: StorageCost; % Cost to hold one unit of product in storage for one period
int: SwitchCost; % Cost to switch the production from one period to another

% Variables
array[1..T] of var 0..sum(Deliver): Produce; % Amount of product to produce in each period
array[1..T] of var 0..sum(Deliver): Inventory; % Amount of product in inventory at the end of each period

% Constraints
constraint Inventory[1] = Produce[1] - Deliver[1];
constraint forall(i in 2..T) (
    Inventory[i] = Inventory[i-1] + Produce[i] - Deliver[i]
);
constraint forall(i in 1..T-1) (
    abs(Produce[i+1] - Produce[i]) * SwitchCost <= Inventory[i] * StorageCost
);
constraint Inventory[T] = 0;

% Objective
var int: TotalCost = sum(i in 1..T) (Produce[i] * SwitchCost + Inventory[i] * StorageCost);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Produce: "] ++ [show(Produce[i]) | i in 1..T] ++ ["\n"] ++
["Inventory: "] ++ [show(Inventory[i]) | i in 1..T];