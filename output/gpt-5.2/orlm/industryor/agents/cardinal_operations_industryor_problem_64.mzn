% Parameters
% Processing/assembly hours per unit in each workshop
int: hoursA_microwave = 2;
int: hoursB_microwave = 1;
int: hoursA_heater    = 1;
int: hoursB_heater    = 3;

% Inspection and sales costs per unit (yuan)
int: cost_microwave = 30;
int: cost_heater    = 50;

% Workshop monthly available hours and hourly costs (yuan/hour)
int: availA = 250;
int: availB = 150;
int: costA_per_hour = 80;
int: costB_per_hour = 20;

% Sales estimates / minimum required sales (units per month)
int: min_microwave = 80;
int: min_heater    = 50;

% Inspection and sales budget (yuan per month)
int: max_inspection_sales_cost = 5500;

% Overtime limit in workshop A (hours)
int: max_overtimeA = 20;


% Variables
% Monthly production quantities (units)
var int: x_microwave;  % number of microwave ovens produced
var int: x_heater;     % number of water heaters produced

% Monthly overtime usage in workshop A (hours)
var int: overtimeA;

% Monthly utilized time in each workshop (hours)
var int: usedA;
var int: usedB;

% Monthly inspection & sales total cost (yuan)
var int: insp_sales_total_cost;

% Total labor cost in workshops (yuan)
var int: workshop_total_cost;

% ---- Bounds as constraints (keep declarations simple) ----
constraint x_microwave >= 0;
constraint x_heater >= 0;

constraint overtimeA >= 0;
constraint overtimeA <= max_overtimeA;

constraint usedA >= 0;
constraint usedA <= availA + max_overtimeA;

constraint usedB >= 0;
constraint usedB <= availB;

constraint insp_sales_total_cost >= 0;
constraint workshop_total_cost >= 0;


% Constraints
% --- Link used workshop hours to production quantities ---
constraint
  usedA = hoursA_microwave * x_microwave + hoursA_heater * x_heater;

constraint
  usedB = hoursB_microwave * x_microwave + hoursB_heater * x_heater;

% --- Fully utilize workshop time (with overtime allowed only in A) ---
constraint
  usedA = availA + overtimeA;         % A is fully utilized including overtime

constraint
  usedB = availB;                     % B is fully utilized (no overtime variable)

% --- Sales / minimum production requirements ---
constraint
  x_microwave >= min_microwave;

constraint
  x_heater >= min_heater;

% --- Inspection & sales budget ---
constraint
  insp_sales_total_cost = cost_microwave * x_microwave + cost_heater * x_heater;

constraint
  insp_sales_total_cost <= max_inspection_sales_cost;

% --- Compute total workshop labor cost (objective uses this) ---
constraint
  workshop_total_cost = costA_per_hour * usedA + costB_per_hour * usedB;


% Objective
solve minimize workshop_total_cost;