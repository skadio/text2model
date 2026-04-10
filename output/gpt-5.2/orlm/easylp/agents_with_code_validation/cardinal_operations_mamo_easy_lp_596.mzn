% Parameters
int: nTypes = 4;                               % number of vehicle types
set of int: TYPES = 1..nTypes;                 % index set for vehicle types

array[TYPES] of int: available = [700, 500, 600, 800];   % max available vehicles by type (x1..x4)
array[TYPES] of int: cost = [50, 60, 70, 80];            % operating cost per vehicle per day by type

int: maxOp1 = 1000;                            % max combined allocation for operation 1 (x1+x2)
int: maxOp2 = 1200;                            % max combined allocation for operation 2 (x3+x4)

int: minHeavy = 800;                           % min combined heavy-duty allocation (x1+x3)
int: minSpecial = 600;                         % min combined special requirement allocation (x2+x4)

% Variables
% Domain upper bound 800 is safe since the largest availability is 800; individual availability is enforced by constraints.
array[TYPES] of var 0..800: x;                 % allocated vehicles of each type (x[1]=x1..x[4]=x4)
var 0..(700*50 + 500*60 + 600*70 + 800*80): total_cost;  % total daily operating cost

% Constraints
% Respect availability limits for each vehicle type
constraint
  forall(t in TYPES) (
    x[t] <= available[t]
  );

% Operation 1 capacity: x1 + x2 <= maxOp1
constraint
  x[1] + x[2] <= maxOp1;

% Operation 2 capacity: x3 + x4 <= maxOp2
constraint
  x[3] + x[4] <= maxOp2;

% Minimum heavy-duty capacity requirement: x1 + x3 >= minHeavy
constraint
  x[1] + x[3] >= minHeavy;

% Minimum special requirement: x2 + x4 >= minSpecial
constraint
  x[2] + x[4] >= minSpecial;

% Define total daily operating cost
constraint
  total_cost = sum(t in TYPES) (x[t] * cost[t]);

% Objective
solve minimize total_cost;