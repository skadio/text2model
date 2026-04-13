% Parameters
int: nVehicleTypes = 4;                               % Number of vehicle types
set of int: VEH = 1..nVehicleTypes;                   % Index set for vehicle types (1..4)

array[VEH] of int: available = [700, 500, 600, 800];  % Available vehicles of each type (x1..x4)
array[VEH] of int: costPerDay = [50, 60, 70, 80];     % Operating cost per day for each type

int: maxOp1 = 1000;                                   % Max vehicles allocated to operation 1 (x1 + x2)
int: maxOp2 = 1200;                                   % Max vehicles allocated to operation 2 (x3 + x4)
int: minHeavy = 800;                                  % Min heavy-duty capacity vehicles (x1 + x3)
int: minReq = 600;                                    % Min requirement vehicles (x2 + x4)

% Variables
array[VEH] of var 0..max(available): x;               % Allocated vehicles per type (x[1]=x1..x[4]=x4)
var int: totalCost;                                   % Total daily operating cost in dollars

% Constraints
%--- Vehicle availability bounds (cannot allocate more than available of each type)
constraint
  forall(v in VEH) (
    x[v] <= available[v]
  );

%--- Operation 1 capacity: x1 + x2 <= maxOp1
constraint
  x[1] + x[2] <= maxOp1;

%--- Operation 2 capacity: x3 + x4 <= maxOp2
constraint
  x[3] + x[4] <= maxOp2;

%--- Heavy-duty capacity requirement: x1 + x3 >= minHeavy
constraint
  x[1] + x[3] >= minHeavy;

%--- Additional requirement: x2 + x4 >= minReq
constraint
  x[2] + x[4] >= minReq;

%--- Define total operating cost from allocations and per-day costs
constraint
  totalCost = sum(v in VEH) (x[v] * costPerDay[v]);

% Objective
solve minimize totalCost;