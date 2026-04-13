include "globals.mzn";

% ------------------------
% Input data (from .dzn)
% ------------------------
int: N;
set of int: P = 1..N;

array[P] of float: AssemblyHour;
array[P] of float: TestingHour;
array[P] of float: MaterialCost;
float: MaxAssembly;
float: MaxTesting;

array[P] of float: Price;

float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;

float: MaterialDiscount;     % percent, e.g., 10 means 10%
float: DiscountThreshold;    % dollars

% Optional bound to keep model finite (provide in .dzn if needed)
int: MaxUnits = 100000;

% ------------------------
% Decision variables
% ------------------------
array[P] of var 0..MaxUnits: x;          % units produced of each product
var float: overtimeAsm;                  % overtime assembly hours used (>=0)

% ------------------------
% Derived expressions
% ------------------------
var float: asmHours     = sum(i in P)( AssemblyHour[i] * x[i] );
var float: testHours    = sum(i in P)( TestingHour[i] * x[i] );

var float: revenue      = sum(i in P)( Price[i] * x[i] );
var float: materialBill = sum(i in P)( MaterialCost[i] * x[i] );

var float: overtimeCost = OvertimeAssemblyCost * overtimeAsm;

% Discount applies to entire material bill if threshold reached
var 0..1: discOn;
constraint discOn = bool2int(materialBill >= DiscountThreshold);

var float: discountedMaterialCost =
    materialBill * (1.0 - (MaterialDiscount/100.0) * int2float(discOn));

var float: profit = revenue - discountedMaterialCost - overtimeCost;

% ------------------------
% Constraints
% ------------------------
% Testing hours limited
constraint testHours <= MaxTesting;

% Assembly hours can use regular time + overtime, with a cap on overtime
constraint asmHours <= MaxAssembly + overtimeAsm;
constraint 0.0 <= overtimeAsm /\ overtimeAsm <= MaxOvertimeAssembly;

% ------------------------
% Objective
% ------------------------
solve maximize profit;

% ------------------------
% Output
% ------------------------
output [
  "x = ", show(x), "\n",
  "assembly_hours = ", show(asmHours), "\n",
  "testing_hours = ", show(testHours), "\n",
  "overtime_assembly_hours = ", show(overtimeAsm), "\n",
  "revenue = ", show(revenue), "\n",
  "material_bill = ", show(materialBill), "\n",
  "discount_on = ", show(discOn), "\n",
  "discounted_material_cost = ", show(discountedMaterialCost), "\n",
  "overtime_cost = ", show(overtimeCost), "\n",
  "profit = ", show(profit), "\n"
];