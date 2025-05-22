% Parameters
int: M; % Number of machines
int: P; % Number of parts
array[1..M, 1..P] of int: TimeRequired; % Time required to produce a batch of part p on machine m
array[1..M] of int: MachineCosts; % Cost associated with running machine m
array[1..M] of int: Availability; % Availability of machine m for production each month
array[1..P] of int: Prices; % Price obtained from selling a batch of part p
array[1..P] of int: MinBatches; % Minimum number of batches of part p that should be produced
array[1..M] of int: ExtraCosts; % Extra cost incurred when running machine m beyond regular operation
array[1..M] of int: MaxExtra; % Maximum extra hours machine m can be run

% Variables
array[1..P] of var 0..1000: Batches; % Number of batches of each part to produce
array[1..M] of var int: ExtraHours; % Extra hours to run each machine

% Constraints
constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m,p]*Batches[p]) <= Availability[m] + ExtraHours[m]
); % The total time required to produce all batches should not exceed the availability of each machine plus any extra hours

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
); % The number of batches of each part produced should be at least the minimum required

constraint forall(m in 1..M) (
  ExtraHours[m] >= 0 /\ ExtraHours[m] <= MaxExtra[m]
); % The extra hours for each machine should be within the maximum limit

% Objective
var int: TotalCost = sum(m in 1..M) (MachineCosts[m]*Availability[m] + ExtraCosts[m]*ExtraHours[m]); % Total cost of production
var int: TotalRevenue = sum(p in 1..P) (Prices[p]*Batches[p]); % Total revenue from selling the parts
var int: Profit = TotalRevenue - TotalCost; % Profit is revenue minus cost

solve maximize Profit;