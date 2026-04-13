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

var 0..OTHours: StdHours1;
var 0..OTHours: OTHours1;
int: OTHours = OvertimeHour;

var int: Revenue;
var int: TotalCost;
var int: Profit;

% Constraints
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(p in 1..P) (
  Batches[p] >= 0
);

% Machine availability constraints for machines 2..M (machine 1 availability disregarded)
constraint forall(m in 2..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Split machine 1 hours into standard + overtime
constraint sum(p in 1..P)(TimeRequired[1,p] * Batches[p]) = StdHours1 + OTHours1;

constraint StdHours1 <= Availability[1];
constraint OTHours1 <= OvertimeHour;

% Revenue and cost accounting
constraint Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);

constraint TotalCost =
  sum(m in 2..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p])
  + StandardCost * StdHours1
  + OvertimeCost * OTHours1;

constraint Profit = Revenue - TotalCost;

constraint Profit >= MinProfit;

% Objective
solve maximize Profit;