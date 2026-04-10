% Parameters
% Resource limits (hours per day)
float: maxAssembly = 90.0;
float: maxTesting  = 80.0;

% Overtime options (hours and cost)
float: maxOvertimeAssembly = 50.0;
float: overtimeAssemblyCostPerHour = 7.0;

% Two product types
int: nProducts = 2;
set of int: PRODUCTS = 1..nProducts;

% Processing times (hours per unit)
array[PRODUCTS] of float: assemblyHours = [1.0/4.0, 1.0/3.0];
array[PRODUCTS] of float: testingHours  = [1.0/8.0, 1.0/3.0];

% Unit economics ($ per unit)
array[PRODUCTS] of float: rawMaterialCost = [1.2, 0.9];
array[PRODUCTS] of float: marketValue    = [9.0, 8.0];

% Precomputed bound helper (avoid min(array[float]) typing issues)
float: minAssemblyHours = if assemblyHours[1] < assemblyHours[2] then assemblyHours[1] else assemblyHours[2] endif;
int: maxUnitsUB = ceil((maxAssembly + maxOvertimeAssembly) / minAssemblyHours);


% Variables
% Production quantities (units per day)
array[PRODUCTS] of var int: produceUnits;

% Scheduled overtime assembly hours (hours per day)
var float: overtimeAssemblyHours;

% Profit in dollars (objective), and rounded profit for reporting
var float: profit;
var int: profitRounded;


% Constraints
% Domain/bounds
constraint forall(p in PRODUCTS) (produceUnits[p] >= 0);
constraint forall(p in PRODUCTS) (produceUnits[p] <= maxUnitsUB);

constraint 0.0 <= overtimeAssemblyHours /\ overtimeAssemblyHours <= maxOvertimeAssembly;

% Assembly capacity with optional overtime (regular + scheduled overtime)
constraint
  sum(p in PRODUCTS) (assemblyHours[p] * produceUnits[p])
  <= maxAssembly + overtimeAssemblyHours;

% Testing capacity (no overtime allowed for testing)
constraint
  sum(p in PRODUCTS) (testingHours[p] * produceUnits[p])
  <= maxTesting;

% Profit definition: revenue minus raw material cost minus overtime assembly cost
constraint
  profit =
    sum(p in PRODUCTS) ((marketValue[p] - rawMaterialCost[p]) * produceUnits[p])
    - overtimeAssemblyCostPerHour * overtimeAssemblyHours;

% Rounded-to-nearest-dollar profit for output
constraint profitRounded = round(profit);


% Objective
solve maximize profit;

output [
  "produceUnits = ", show(produceUnits), "\n",
  "overtimeAssemblyHours = ", show(overtimeAssemblyHours), "\n",
  "profit = ", show(profit), "\n",
  "profitRounded = ", show(profitRounded), "\n"
];