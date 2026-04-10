% Parameters (with values embedded)
int: nDevices = 4;
set of int: Devices = 1..nDevices;

array[Devices] of string: devName = ["A","B","C","D"];

array[Devices] of int: prepCost = [1000, 920, 800, 700];        % Yuan (fixed if device enabled)
array[Devices] of int: unitCost = [20, 24, 16, 28];             % Yuan per unit produced
array[Devices] of int: capacity = [900, 1000, 1200, 1600];      % max units if enabled

int: demand = 2000;

% Variables
array[Devices] of var 0..1: enable;                             % 1 if device is used
array[Devices] of var 0..max(capacity): x;                      % units produced on each device
var int: totalCost;

% Constraints
constraint forall(i in Devices) (
  x[i] <= capacity[i] * enable[i]
);

constraint sum(i in Devices)(x[i]) = demand;

constraint totalCost =
  sum(i in Devices)(prepCost[i] * enable[i] + unitCost[i] * x[i]);

% Objective
solve minimize totalCost;