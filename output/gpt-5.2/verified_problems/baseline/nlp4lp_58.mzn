include "globals.mzn";

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

set of int: MACHINES = 1..M;
set of int: PARTS = 1..P;

% Decision variables: batches (of 100 units) produced of each part
array[PARTS] of var int: Batches;

% Nonnegativity and minimum contract requirements
constraint forall(p in PARTS) (
  Batches[p] >= MinBatches[p]
);

% Machine capacity constraints for machines 2..M (machine 1 outsourced; ignore its availability)
constraint forall(m in 2..M) (
  sum(p in PARTS)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Outsourced machine 1 labor hours and cost split into standard and overtime
var int: LaborHours = sum(p in PARTS)(TimeRequired[1,p] * Batches[p]);
var int: StandardHours;
var int: OvertimeHours;

constraint StandardHours >= 0 /\ OvertimeHours >= 0;
constraint StandardHours <= Availability[1];
constraint OvertimeHours <= OvertimeHour;
constraint LaborHours = StandardHours + OvertimeHours;

% Revenue and costs
var int: Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

var int: InhouseCost =
  sum(m in 2..M, p in PARTS)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

var int: OutsourceLaborCost = StandardCost * StandardHours + OvertimeCost * OvertimeHours;

var int: TotalCost = InhouseCost + OutsourceLaborCost;
var int: Profit = Revenue - TotalCost;

% Minimum profit requirement
constraint Profit >= MinProfit;

% Objective: maximize profit
solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "LaborHours(machine1) = ", show(LaborHours), "\n",
  "StandardHours = ", show(StandardHours), "\n",
  "OvertimeHours = ", show(OvertimeHours), "\n",
  "Revenue = ", show(Revenue), "\n",
  "TotalCost = ", show(TotalCost), "\n",
  "Profit = ", show(Profit), "\n"
];