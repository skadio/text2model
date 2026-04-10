int: NumMachines;
int: NumParts;

set of int: M = 1..NumMachines;
set of int: P = 1..NumParts;

array[M, P] of int: TimeRequired;      % hours per batch on machine m for part p
array[M] of int: MachineCosts;         % operating cost per hour for machine m (except m=1 overridden by labor)
array[M] of int: Availability;         % normal hours available per month for machine m (ignored for m=1)
array[P] of int: Prices;               % revenue per batch for part p
array[P] of int: MinBatches;           % minimum batches for part p
int: StandardCost;                     % standard labor cost per hour for outsourced machine 1
int: OvertimeCost;                     % overtime labor cost per hour for outsourced machine 1
array[M] of int: OvertimeHour;         % overtime hours available for machine m (for m=1 used; others optional)

array[P] of var 0..int_max: Batches;

% Total hours used on each machine
array[M] of var 0..int_max: HoursUsed =
  [ sum(p in P)(TimeRequired[m,p] * Batches[p]) | m in M ];

% Machine 1 (outsourced): split into standard and overtime hours
var 0..int_max: StdHours1;
var 0..int_max: OTHours1;

constraint StdHours1 + OTHours1 = HoursUsed[1];
constraint StdHours1 <= Availability[1];
constraint OTHours1 <= OvertimeHour[1];

% Capacity constraints for other machines (no overtime modeled; only normal availability)
constraint forall(m in M where m != 1)(
  HoursUsed[m] <= Availability[m]
);

% Minimum contract production
constraint forall(p in P)(
  Batches[p] >= MinBatches[p]
);

% Profit = revenue - machine operating costs (m>=2) - labor costs (m=1)
var int: Revenue = sum(p in P)(Prices[p] * Batches[p]);

var int: CostMachines = sum(m in M where m != 1)(MachineCosts[m] * HoursUsed[m]);

var int: CostLabor1 = StandardCost * StdHours1 + OvertimeCost * OTHours1;

var int: Profit = Revenue - CostMachines - CostLabor1;

solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "Batches=", show(Batches), "\n",
  "HoursUsed=", show(HoursUsed), "\n",
  "StdHours1=", show(StdHours1), " OTHours1=", show(OTHours1), "\n"
];