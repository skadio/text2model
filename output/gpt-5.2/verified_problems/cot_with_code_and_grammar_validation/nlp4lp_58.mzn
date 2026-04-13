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
var int: OtHoursM1;

% Constraints
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(p in 1..P) (
  Batches[p] >= 0
);

% Machine availability constraints for machines 2..M
constraint forall(m in 2..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Machine 1 outsourced: ignore Availability[1], pay standard then overtime up to OvertimeHour
constraint StdHoursM1 >= 0 /\ OtHoursM1 >= 0;
constraint StdHoursM1 <= Availability[1];
constraint OtHoursM1 <= OvertimeHour;

constraint
  StdHoursM1 + OtHoursM1
  = sum(p in 1..P)(TimeRequired[1,p] * Batches[p]);

% Profit definition and minimum profit requirement
var int: Revenue =
  sum(p in 1..P)(Prices[p] * Batches[p]);

var int: NonM1MachineCost =
  sum(m in 2..M, p in 1..P)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

var int: M1LaborCost =
  StandardCost * StdHoursM1 + OvertimeCost * OtHoursM1;

var int: Profit = Revenue - NonM1MachineCost - M1LaborCost;

constraint Profit >= MinProfit;

% Objective
solve maximize Profit;