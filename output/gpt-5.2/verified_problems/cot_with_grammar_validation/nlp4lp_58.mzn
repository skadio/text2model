% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;

array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

int: StandardCost;
int: OvertimeCost;
int: OvertimeHour;
int: MinProfit;

% Variables
array[1..P] of var int: Batches;

var int: StdHoursM1;
var int: OTHoursM1;

var int: Revenue;
var int: CostMachinesOther;
var int: CostMachine1;
var int: Profit;

% Constraints
constraint forall(p in 1..P) (Batches[p] >= MinBatches[p]);

% Bound batches using finite machine availability (machines 2..M)
constraint forall(p in 1..P) (
  Batches[p] <=
    min([ Availability[m] div TimeRequired[m,p] | m in 2..M where TimeRequired[m,p] > 0 ])
);

% Hours usage constraints for machines 2..M (machine 1 availability disregarded)
constraint forall(m in 2..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Outsourced machine (m=1): labor split into standard and overtime hours
constraint StdHoursM1 >= 0;
constraint OTHoursM1 >= 0;
constraint StdHoursM1 <= Availability[1];
constraint OTHoursM1 <= OvertimeHour;

constraint StdHoursM1 + OTHoursM1 = sum(p in 1..P)(TimeRequired[1,p] * Batches[p]);

% Define revenue and costs
constraint Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);

constraint CostMachinesOther =
  sum(m in 2..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

constraint CostMachine1 = StandardCost * StdHoursM1 + OvertimeCost * OTHoursM1;

constraint Profit = Revenue - CostMachinesOther - CostMachine1;

constraint Profit >= MinProfit;

% Objective
solve maximize Profit;