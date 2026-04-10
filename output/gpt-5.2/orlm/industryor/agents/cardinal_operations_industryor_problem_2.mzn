% Parameters
int: nMonths = 6;                          % Planning horizon length (Jan..Jun)
set of int: MONTHS = 1..nMonths;           % Month index set

array[MONTHS] of int: demand =             % Forecast demand per month
  [20000, 40000, 42000, 35000, 19000, 18500];

int: initWorkforce = 1000;                 % Workforce at start of January
int: initInventory = 15000;                % Inventory at start of January

int: sellPrice = 300;                      % Yuan per unit sold
int: rawMaterialCost = 90;                 % Yuan per in-house unit produced
int: outsourceCost = 200;                  % Yuan per outsourced unit
int: holdingCost = 15;                     % Yuan per unit ending inventory per month
int: backorderCost = 35;                   % Yuan per unit backordered per month

int: laborHoursPerUnit = 5;                % Labor hours needed per in-house unit

int: regularHoursPerWorker = 160;          % Regular hours per worker per month
int: regularWagePerHour = 30;              % Wage per regular hour (paid for all 160h)

int: maxOvertimeHoursPerWorker = 20;       % Max overtime hours per worker per month
int: overtimeWagePerHour = 40;             % Wage per overtime hour

int: hireCost = 5000;                      % Cost per hired worker
int: fireCost = 8000;                      % Cost per fired worker

int: minEndInventory = 10000;              % Required ending inventory at end of June
int: endBackorderRequired = 0;             % Required ending backorder at end of June

% Useful derived bounds for variable domains
int: totalDemand = sum(m in MONTHS)(demand[m]);
int: maxInventoryBound = initInventory + totalDemand;  % Safe upper bound
int: maxBackorderBound = totalDemand;                  % Safe upper bound
int: maxWorkforceBound = initWorkforce + totalDemand;  % Safe upper bound on workforce
int: maxUnitsBound = totalDemand + maxInventoryBound;  % Safe upper bound on production/outsourcing
int: maxOvertimeHoursBound = maxWorkforceBound * maxOvertimeHoursPerWorker;
int: maxRegularHoursBound  = maxWorkforceBound * regularHoursPerWorker;

% Variables
array[MONTHS] of var 0..maxWorkforceBound: workforce;           % Workforce level each month
array[MONTHS] of var 0..maxWorkforceBound: hired;               % Workers hired in month
array[MONTHS] of var 0..maxWorkforceBound: fired;               % Workers fired in month

array[MONTHS] of var 0..maxUnitsBound: inhouseProd;             % In-house production units per month
array[MONTHS] of var 0..maxUnitsBound: outsourced;              % Outsourced units per month

array[MONTHS] of var 0..maxInventoryBound: inventoryEnd;        % Ending inventory per month
array[MONTHS] of var 0..maxBackorderBound: backorderEnd;        % Ending backorders per month

array[MONTHS] of var 0..maxRegularHoursBound: regularHoursUsed; % Regular labor hours used (<= paid hours)
array[MONTHS] of var 0..maxOvertimeHoursBound: overtimeHours;   % Overtime hours used per month

var int: totalProfit;                                           % Objective: total net profit over horizon


% Constraints

%-----------------------------
% Workforce balance constraints
%-----------------------------
% Workforce evolution: current workforce = previous workforce + hired - fired
constraint workforce[1] = initWorkforce + hired[1] - fired[1];

constraint
  forall(m in 2..nMonths) (
    workforce[m] = workforce[m-1] + hired[m] - fired[m]
  );

%-----------------------------
% Labor capacity & usage constraints
%-----------------------------
% Regular hours used cannot exceed regular hours available (paid hours)
constraint
  forall(m in MONTHS) (
    regularHoursUsed[m] <= workforce[m] * regularHoursPerWorker
  );

% Overtime hours limited by max overtime per worker
constraint
  forall(m in MONTHS) (
    overtimeHours[m] <= workforce[m] * maxOvertimeHoursPerWorker
  );

% Production requires labor hours (can be met by regular + overtime hours)
constraint
  forall(m in MONTHS) (
    inhouseProd[m] * laborHoursPerUnit <= regularHoursUsed[m] + overtimeHours[m]
  );

%-----------------------------
% Inventory & backorder flow constraints
%-----------------------------
% Material balance with backorders:
% (inventory carried in + production + outsourcing) - demand - previous backorder
%   = ending inventory - ending backorder
constraint
  initInventory + inhouseProd[1] + outsourced[1] - demand[1]
    = inventoryEnd[1] - backorderEnd[1];

constraint
  forall(m in 2..nMonths) (
    inventoryEnd[m-1] + inhouseProd[m] + outsourced[m] - demand[m] - backorderEnd[m-1]
      = inventoryEnd[m] - backorderEnd[m]
  );

%-----------------------------
% Terminal requirements (end of June)
%-----------------------------
% Minimum ending inventory at end of horizon
constraint inventoryEnd[nMonths] >= minEndInventory;

% All backorders must be cleared at end of horizon
constraint backorderEnd[nMonths] = endBackorderRequired;


% Objective
constraint
  totalProfit =
    sum(m in MONTHS)(demand[m] * sellPrice)
    - sum(m in MONTHS)(inhouseProd[m] * rawMaterialCost)
    - sum(m in MONTHS)(outsourced[m] * outsourceCost)
    - sum(m in MONTHS)(inventoryEnd[m] * holdingCost)
    - sum(m in MONTHS)(backorderEnd[m] * backorderCost)
    - sum(m in MONTHS)(workforce[m] * regularHoursPerWorker * regularWagePerHour)
    - sum(m in MONTHS)(overtimeHours[m] * overtimeWagePerHour)
    - sum(m in MONTHS)(hired[m] * hireCost)
    - sum(m in MONTHS)(fired[m] * fireCost);

solve maximize totalProfit;