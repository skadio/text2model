% Use a MILP backend (float linear constraints are not supported well by Gecode)
% Solve with: minizinc --solver cbc model.mzn data.dzn
include "float.mzn";

%--------------------------
% Parameters
%--------------------------
int: N;
set of int: PRODUCTS = 1..N;

array[PRODUCTS] of float: AssemblyHour;
array[PRODUCTS] of float: TestingHour;
array[PRODUCTS] of float: MaterialCost;
array[PRODUCTS] of float: Price;

float: MaxAssembly;
float: MaxTesting;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;

float: MaterialDiscount;      % percentage, e.g., 10 means 10%
float: DiscountThreshold;     % $ threshold

%--------------------------
% Decision variables
%--------------------------
array[PRODUCTS] of var 0..1000000: ProduceQty;   % non-negative integer production

var 0.0..1.0e12: RegularAssemblyUsed;
var 0.0..1.0e12: OvertimeAssemblyUsed;
var 0.0..1.0e12: TestingUsed;

var 0.0..1.0e15: Revenue;
var 0.0..1.0e15: MaterialBill;
var 0.0..1.0e15: MaterialCostAfterDiscount;
var 0.0..1.0e15: OvertimeCostTotal;

var bool: DiscountApplies;

var -1.0e15..1.0e15: Profit;

%--------------------------
% Constraints
%--------------------------

% Total hours (regular + overtime) equals required assembly hours
constraint
  RegularAssemblyUsed + OvertimeAssemblyUsed =
    sum(i in PRODUCTS)(AssemblyHour[i] * int2float(ProduceQty[i]));

constraint
  TestingUsed =
    sum(i in PRODUCTS)(TestingHour[i] * int2float(ProduceQty[i]));

% Capacity limits
constraint RegularAssemblyUsed <= MaxAssembly;
constraint OvertimeAssemblyUsed <= MaxOvertimeAssembly;
constraint TestingUsed <= MaxTesting;

% Revenue and materials
constraint
  Revenue =
    sum(i in PRODUCTS)(Price[i] * int2float(ProduceQty[i]));

constraint
  MaterialBill =
    sum(i in PRODUCTS)(MaterialCost[i] * int2float(ProduceQty[i]));

% Discount trigger
constraint DiscountApplies <-> (MaterialBill >= DiscountThreshold);

% Discounted material cost (linearized to avoid multiplying float * bool)
constraint
  MaterialCostAfterDiscount =
    if DiscountApplies then
      MaterialBill * (1.0 - MaterialDiscount / 100.0)
    else
      MaterialBill
    endif;

% Overtime cost
constraint OvertimeCostTotal = OvertimeAssemblyUsed * OvertimeAssemblyCost;

% Profit
constraint Profit = Revenue - MaterialCostAfterDiscount - OvertimeCostTotal;

%--------------------------
% Objective
%--------------------------
solve maximize Profit;