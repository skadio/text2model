int: NumMachines;
int: NumParts;

set of int: MACHINES = 1..NumMachines;
set of int: PARTS = 1..NumParts;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES] of int: MachineCosts;
array[MACHINES] of int: Availability;
array[PARTS] of int: Prices;
array[PARTS] of int: MinBatches;

int: StandardCost;
int: OvertimeCost;
array[MACHINES] of int: OvertimeHour;

% Decision variables: batches of each part to produce (in 100-part batches)
array[PARTS] of var int: Batches;

% For outsourced machine 1 labor split into standard and overtime hours
var int: StdHoursM1;
var int: OTHoursM1;

% Total hours used on each in-house machine (m >= 2)
array[MACHINES] of var int: HoursUsed;

constraint forall(p in PARTS) (
  Batches[p] >= MinBatches[p]
);

% Define hours used for all machines from production plan
constraint forall(m in MACHINES) (
  HoursUsed[m] = sum(p in PARTS) TimeRequired[m,p] * Batches[p]
);

% Machine 1: ignore regular availability; allow standard + overtime up to provided limits
constraint StdHoursM1 >= 0 /\ StdHoursM1 <= Availability[1];
constraint OTHoursM1 >= 0 /\ OTHoursM1 <= OvertimeHour[1];
constraint StdHoursM1 + OTHoursM1 = HoursUsed[1];

% Machines 2..M: limited availability + overtime
constraint forall(m in MACHINES where m >= 2) (
  HoursUsed[m] <= Availability[m] + OvertimeHour[m]
);

% Objective components
var int: Revenue = sum(p in PARTS) Prices[p] * Batches[p];

% Base machine operating costs (monthly)
var int: FixedMachineCost = sum(m in MACHINES where m >= 2) MachineCosts[m];

% Labor costs:
% - Machine 1 (outsourced): standard cost up to Availability[1], overtime at OvertimeCost
% - Machines 2..M: standard cost for all hours, plus overtime premium for hours beyond Availability[m]
var int: LaborCostM1 = StandardCost * StdHoursM1 + OvertimeCost * OTHoursM1;

var int: LaborCostInhouse =
  sum(m in MACHINES where m >= 2) (
    StandardCost * HoursUsed[m] + OvertimeCost * max(0, HoursUsed[m] - Availability[m])
  );

var int: TotalCost = FixedMachineCost + LaborCostM1 + LaborCostInhouse;

var int: Profit = Revenue - TotalCost;

solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "Batches=", show(Batches), "\n",
  "HoursUsed=", show(HoursUsed), "\n",
  "StdHoursM1=", show(StdHoursM1), "\n",
  "OTHoursM1=", show(OTHoursM1), "\n"
];