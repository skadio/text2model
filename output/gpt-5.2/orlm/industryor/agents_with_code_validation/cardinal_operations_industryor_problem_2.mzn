% Foldable tables: production + outsourcing + workforce plan (Jan-Jun)
% Objective: maximize net profit

%%%%%%%%%%%%%%%
% Parameters  %
%%%%%%%%%%%%%%%
int: nMonths = 6;
set of int: MONTHS = 1..nMonths;

array[MONTHS] of string: monthName = ["Jan","Feb","Mar","Apr","May","Jun"];

% Initial conditions (start of January)
int: initialWorkforce = 1000;
int: initialInventory = 15000;
int: initialBackorder = 0;

% Demand forecast
array[MONTHS] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

% Prices and costs (Yuan)
int: salesPrice = 300;
int: rawMaterialCost = 90;        % only for in-house units
int: outsourceCost = 200;         % per outsourced unit (all-inclusive)
int: holdingCost = 15;            % per end-of-month inventory unit
int: backorderCost = 35;          % per end-of-month backorder unit

% Labor and production
int: laborHoursPerUnit = 5;
int: regularHoursPerWorker = 160;
int: regularWagePerHour = 30;     % paid for all regular hours
int: maxOvertimeHoursPerWorker = 20;
int: overtimeWagePerHour = 40;

% Workforce adjustment
int: hireCost = 5000;
int: fireCost = 8000;

% Terminal requirements (end of June)
int: minEndingInventory = 10000;
int: requiredEndingBackorder = 0;

% Bounds
int: maxCumulativeDemand = sum(demand);
int: maxWorkforce = initialWorkforce + maxCumulativeDemand; % safe upper bound

%%%%%%%%%%%%%%%%
% Decision vars %
%%%%%%%%%%%%%%%%
array[MONTHS] of var 0..maxCumulativeDemand: inhouseProd;
array[MONTHS] of var 0..maxCumulativeDemand: outsourced;

array[MONTHS] of var 0..maxWorkforce: workforce;
array[MONTHS] of var 0..maxWorkforce: hired;
array[MONTHS] of var 0..maxWorkforce: fired;

array[MONTHS] of var 0..(maxOvertimeHoursPerWorker * maxWorkforce): overtimeHours;

array[MONTHS] of var 0..maxCumulativeDemand: endingInventory;
array[MONTHS] of var 0..maxCumulativeDemand: endingBackorder;

array[MONTHS] of var 0..maxCumulativeDemand: fulfilled;

% Use 64-bit integers to avoid overflow in objective arithmetic
var int64: totalRevenue;
var int64: totalCost;
var int64: netProfit;

%%%%%%%%%%%%%%%%
% Constraints  %
%%%%%%%%%%%%%%%%

% Workforce evolution
constraint workforce[1] = initialWorkforce + hired[1] - fired[1];
constraint forall(t in 2..nMonths) (
  workforce[t] = workforce[t-1] + hired[t] - fired[t]
);

% Labor capacity (regular + overtime)
constraint forall(t in MONTHS) (
  laborHoursPerUnit * inhouseProd[t]
  <= regularHoursPerWorker * workforce[t] + overtimeHours[t]
);

% Overtime cap
constraint forall(t in MONTHS) (
  overtimeHours[t] <= maxOvertimeHoursPerWorker * workforce[t]
);

% Inventory/backorder balance:
% endingInventory - endingBackorder = startingInventory + prod + outsource - demand + startingBackorder
constraint
  initialInventory + inhouseProd[1] + outsourced[1] + initialBackorder - demand[1]
  = endingInventory[1] - endingBackorder[1];

constraint forall(t in 2..nMonths) (
  endingInventory[t-1] + inhouseProd[t] + outsourced[t] + endingBackorder[t-1] - demand[t]
  = endingInventory[t] - endingBackorder[t]
);

% Fulfillment definition
constraint fulfilled[1] = demand[1] + initialBackorder - endingBackorder[1];
constraint forall(t in 2..nMonths) (
  fulfilled[t] = demand[t] + endingBackorder[t-1] - endingBackorder[t]
);

% Shipments cannot exceed available supply in the month
constraint fulfilled[1] <= initialInventory + inhouseProd[1] + outsourced[1];
constraint forall(t in 2..nMonths) (
  fulfilled[t] <= endingInventory[t-1] + inhouseProd[t] + outsourced[t]
);

% Terminal conditions
constraint endingInventory[nMonths] >= minEndingInventory;
constraint endingBackorder[nMonths] = requiredEndingBackorder;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective calculation %
%%%%%%%%%%%%%%%%%%%%%%%%%
constraint
  totalRevenue = int2int64(salesPrice) * int2int64(sum(t in MONTHS)(fulfilled[t]));

constraint
  totalCost =
      int2int64(rawMaterialCost) * int2int64(sum(t in MONTHS)(inhouseProd[t]))
    + int2int64(outsourceCost)   * int2int64(sum(t in MONTHS)(outsourced[t]))
    + int2int64(holdingCost)     * int2int64(sum(t in MONTHS)(endingInventory[t]))
    + int2int64(backorderCost)   * int2int64(sum(t in MONTHS)(endingBackorder[t]))
    + int2int64(regularWagePerHour * regularHoursPerWorker) * int2int64(sum(t in MONTHS)(workforce[t]))
    + int2int64(overtimeWagePerHour) * int2int64(sum(t in MONTHS)(overtimeHours[t]))
    + int2int64(hireCost) * int2int64(sum(t in MONTHS)(hired[t]))
    + int2int64(fireCost) * int2int64(sum(t in MONTHS)(fired[t]));

constraint netProfit = totalRevenue - totalCost;

solve maximize netProfit;

output [
  "NetProfit = ", show(netProfit), "\n",
  "TotalRevenue = ", show(totalRevenue), "\n",
  "TotalCost = ", show(totalCost), "\n\n"
] ++
[
  monthName[t] ++
  ": W=" ++ show(workforce[t]) ++
  " H=" ++ show(hired[t]) ++
  " F=" ++ show(fired[t]) ++
  " InHouse=" ++ show(inhouseProd[t]) ++
  " Outs=" ++ show(outsourced[t]) ++
  " OT=" ++ show(overtimeHours[t]) ++
  " Fulfilled=" ++ show(fulfilled[t]) ++
  " EndInv=" ++ show(endingInventory[t]) ++
  " EndBO=" ++ show(endingBackorder[t]) ++ "\n"
  | t in MONTHS
];