% Parameters
int: M; % number of machines
int: P; % number of parts

array[1..M, 1..P] of int: TimeRequired; % hours required on machine m for one batch of part p
array[1..M] of int: MachineCosts;       % operating cost per hour for machine m (m=1 will be ignored)
array[1..M] of int: Availability;       % available hours per month for machine m (m=1 availability used as standard-hours limit)

array[1..P] of int: Prices;     % selling price per batch of part p
array[1..P] of int: MinBatches; % minimum batches required for part p

int: StandardCost;  % outsourced labor cost per hour up to standard hours (machine 1)
int: OvertimeCost;  % outsourced labor cost per hour in overtime (machine 1)
int: OvertimeHour;  % max overtime hours available for machine 1

int: MinProfit; % minimum required profit

% Useful index sets
set of int: MACHINES = 1..M;
set of int: PARTS    = 1..P;


% Variables
array[PARTS] of var int: Batches; % batches of each part p to produce (per month)

var int: StandardHoursUsed; % hours of machine 1 charged at StandardCost
var int: OvertimeHoursUsed; % hours of machine 1 charged at OvertimeCost

% Derived financial quantities
var int: Revenue;
var int: InhouseMachineCost;
var int: OutsourcedLaborCost;


% Constraints
% --- Domain / minimum production requirements ---
constraint forall(p in PARTS) (Batches[p] >= 0);
constraint forall(p in PARTS) (Batches[p] >= MinBatches[p]);

% --- Machine-1 labor hour usage bounds ---
constraint StandardHoursUsed >= 0;
constraint OvertimeHoursUsed >= 0;
constraint OvertimeHoursUsed <= OvertimeHour;

% --- Machine capacity constraints (machines 2..M have limited availability) ---
constraint
  forall(m in 2..M) (
    sum(p in PARTS)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

% --- Outsourced machine 1 labor hours accounting (standard + overtime) ---
constraint
  sum(p in PARTS)(TimeRequired[1,p] * Batches[p]) = StandardHoursUsed + OvertimeHoursUsed;

% Standard hours are capped by the "standard availability" threshold (machine 1)
constraint
  StandardHoursUsed <= Availability[1];

% --- Financial definitions ---
constraint Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

% Costs for in-house machines (2..M); machine 1 is outsourced so ignore MachineCosts[1]
constraint InhouseMachineCost =
  sum(m in 2..M)(
    MachineCosts[m] * sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
  );

% Outsourced labor cost on machine 1 (standard + overtime)
constraint OutsourcedLaborCost =
  StandardCost * StandardHoursUsed + OvertimeCost * OvertimeHoursUsed;

% --- Minimum profit requirement (revenue - costs >= MinProfit) ---
constraint
  Revenue - InhouseMachineCost - OutsourcedLaborCost >= MinProfit;


% Objective
solve maximize Revenue - InhouseMachineCost - OutsourcedLaborCost;