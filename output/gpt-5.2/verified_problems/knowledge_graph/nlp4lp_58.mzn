include "globals.mzn";

int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;   % hours per batch (100 units) for part p on machine m
array[1..M] of int: MachineCosts;         % $ per hour for machine m (machines 2..M)
array[1..M] of int: Availability;         % hours available per month for machine m (machines 2..M)

array[1..P] of int: Prices;               % revenue per batch for part p
array[1..P] of int: MinBatches;           % minimum batches of part p

int: StandardCost;                        % outsourced labor cost per hour up to Availability[1]
int: OvertimeCost;                        % outsourced labor cost per overtime hour
int: OvertimeHour;                        % max overtime hours allowed beyond Availability[1]
int: MinProfit;                           % minimum profit requirement

set of int: MACHINES = 1..M;
set of int: PARTS = 1..P;

% Decision variables: number of batches for each part
array[PARTS] of var int: Batches;

% Machine 1 (outsourced labor) hours split into standard and overtime
var int: StdHours;
var int: OtHours;

% Upper bound on batches (safe, derived from machine 2..M availability; if M=1, use a large fallback)
int: BIG = 1000000;
int: MaxBatches =
  if M >= 2 then
    max(0,
      max([
        let {
          int: minRatio =
            min([ Availability[m] div max(1, TimeRequired[m,p]) | m in 2..M ])
        } in minRatio
      | p in PARTS ])
    ) * P + max(MinBatches)
  else
    BIG
  endif;

constraint forall(p in PARTS) (
  Batches[p] >= MinBatches[p]
);

constraint forall(p in PARTS) (
  Batches[p] <= MaxBatches
);

% Define total hours on machine 1 and split into standard + overtime
constraint
  StdHours + OtHours = sum(p in PARTS)(TimeRequired[1,p] * Batches[p]);

constraint StdHours >= 0 /\ OtHours >= 0;
constraint StdHours <= Availability[1];
constraint OtHours <= OvertimeHour;

% Capacity constraints for machines 2..M (machine 1 availability is disregarded except via labor split above)
constraint forall(m in 2..M) (
  sum(p in PARTS)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% Revenue and costs
var int: Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

var int: MachineCostTotal =
  if M >= 2 then
    sum(m in 2..M, p in PARTS)(MachineCosts[m] * TimeRequired[m,p] * Batches[p])
  else
    0
  endif;

var int: LaborCost = StandardCost * StdHours + OvertimeCost * OtHours;

var int: Profit = Revenue - MachineCostTotal - LaborCost;

constraint Profit >= MinProfit;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "StdHours = ", show(StdHours), "\n",
  "OtHours = ", show(OtHours), "\n",
  "Revenue = ", show(Revenue), "\n",
  "MachineCostTotal = ", show(MachineCostTotal), "\n",
  "LaborCost = ", show(LaborCost), "\n",
  "Profit = ", show(Profit), "\n"
];