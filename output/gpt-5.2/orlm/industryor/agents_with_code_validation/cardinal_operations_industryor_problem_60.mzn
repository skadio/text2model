% Parameters
int: numDevices = 4;                           % Number of devices
set of int: DEVICES = 1..numDevices;           % Device index set: 1=A, 2=B, 3=C, 4=D

int: demand = 2000;                            % Required production quantity (units)

array[DEVICES] of int: prepCost =              % Fixed (prep completion) cost if device is enabled (Yuan)
  [1000, 920, 800, 700];

array[DEVICES] of int: unitCost =              % Unit production cost (Yuan/unit)
  [20, 24, 16, 28];

array[DEVICES] of int: capacity =              % Maximum processing capacity (units)
  [900, 1000, 1200, 1600];

% Variables
array[DEVICES] of var 0..1: useDevice;         % 1 if device is enabled, else 0
array[DEVICES] of var 0..2000: produce;        % Units produced on each device (bounded by demand)
var 0..1000000: totalCost;                     % Total cost (safe upper bound)

% Constraints

% Demand satisfaction: total production across all devices must meet required demand
constraint
  sum(d in DEVICES)(produce[d]) = demand;

% Capacity and activation linking: production on a device only if enabled, and cannot exceed its capacity
constraint
  forall(d in DEVICES) (
    produce[d] <= capacity[d] * useDevice[d]
  );

% Total cost definition: fixed prep costs for enabled devices + variable unit production costs
constraint
  totalCost =
    sum(d in DEVICES)(prepCost[d] * useDevice[d] + unitCost[d] * produce[d]);

% Objective
solve minimize totalCost;