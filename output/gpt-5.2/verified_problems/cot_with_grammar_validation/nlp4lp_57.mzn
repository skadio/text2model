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

array[PARTS] of var int: Batches;

array[MACHINES] of var int: HoursUsed;
array[MACHINES] of var int: NormalHours;
array[MACHINES] of var int: OverHours;

var int: Profit;

constraint forall(p in PARTS) (Batches[p] >= MinBatches[p]);

constraint forall(m in MACHINES) (
  HoursUsed[m] = sum(p in PARTS)(TimeRequired[m, p] * Batches[p])
);

constraint forall(m in MACHINES) (HoursUsed[m] >= 0);

constraint forall(m in 2..NumMachines) (
  HoursUsed[m] <= Availability[m] + OvertimeHour[m]
);

constraint forall(m in MACHINES) (
  NormalHours[m] >= 0 /\ OverHours[m] >= 0
);

constraint forall(m in MACHINES) (
  HoursUsed[m] = NormalHours[m] + OverHours[m]
);

constraint forall(m in 2..NumMachines) (
  NormalHours[m] <= Availability[m] /\ OverHours[m] <= OvertimeHour[m]
);

constraint NormalHours[1] = HoursUsed[1];
constraint OverHours[1] = 0;

constraint forall(p in PARTS) (Batches[p] >= 0);

constraint Profit =
  sum(p in PARTS)(Prices[p] * Batches[p])
  - sum(m in MACHINES)(MachineCosts[m] * HoursUsed[m])
  - StandardCost * sum(m in MACHINES)(NormalHours[m])
  - OvertimeCost * sum(m in MACHINES)(OverHours[m]);

solve maximize Profit;