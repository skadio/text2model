% Parameters
int: P; % Number of parts
int: M; % Number of machines

set of int: PARTS = 1..P;     % Index set for parts
set of int: MACHINES = 1..M;  % Index set for machines

array[MACHINES, PARTS] of int: TimeRequired; % Hours required on machine m to produce 1 batch of part p
array[MACHINES] of int: MachineCosts;        % Cost per hour of operating machine m
array[MACHINES] of int: Availability;        % Available hours per month for machine m
array[PARTS] of int: Prices;                 % Selling price per batch of part p
array[PARTS] of int: MinBatches;             % Minimum batches required for part p (contract requirement)

% Variables
array[PARTS] of var int: BatchesProduced; % Number of batches (of 100 units) of each part to produce in the month

var int: TotalRevenue; % Total sales revenue for the month
var int: TotalCost;    % Total machine operating cost for the month
var int: Profit;       % Profit = TotalRevenue - TotalCost

% Constraints

%--- Contract fulfillment: produce at least the required minimum batches per part
constraint
  forall(p in PARTS) (
    BatchesProduced[p] >= MinBatches[p]
  );

%--- Non-negativity of production (redundant if MinBatches >= 0, but safe)
constraint
  forall(p in PARTS) (
    BatchesProduced[p] >= 0
  );

%--- Machine capacity: total time used on each machine cannot exceed its availability
constraint
  forall(m in MACHINES) (
    sum(p in PARTS) (TimeRequired[m,p] * BatchesProduced[p]) <= Availability[m]
  );

%--- Define total revenue from produced batches
constraint
  TotalRevenue = sum(p in PARTS) (Prices[p] * BatchesProduced[p]);

%--- Define total operating cost across all machines (cost per hour * total hours used)
constraint
  TotalCost =
    sum(m in MACHINES) (
      MachineCosts[m] * sum(p in PARTS) (TimeRequired[m,p] * BatchesProduced[p])
    );

%--- Profit definition
constraint
  Profit = TotalRevenue - TotalCost;

% Objective
solve maximize Profit;