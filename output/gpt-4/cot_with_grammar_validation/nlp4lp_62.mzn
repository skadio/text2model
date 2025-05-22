% Parameters
int: M; % The number of machines available
int: P; % The number of types of parts to produce
array[1..M, 1..P] of int: TimeRequired; % The time required to produce a batch on machine m for part p
array[1..M] of int: MachineCosts; % The cost of operating machine m for a month
array[1..M] of int: Availability; % The time each machine m is available for production each month
array[1..P] of int: Prices; % The price at which part p can be sold
array[1..P] of int: SetupTime; % The setup time required before producing a batch of part p

% Variables
array[1..P] of var 0..1000: Batches; % The number of batches of each part to produce

% Constraints
constraint forall(m in 1..M)(
  sum(p in 1..P)(TimeRequired[m,p]*Batches[p]) + sum(p in 1..P)(if m=1 then SetupTime[p] else 0 endif) <= Availability[m]
);

% Objective
var int: TotalCost = sum(m in 1..M)(MachineCosts[m]);
var int: TotalRevenue = sum(p in 1..P)(Prices[p]*Batches[p]);
var int: Profit = TotalRevenue - TotalCost;
solve maximize Profit;