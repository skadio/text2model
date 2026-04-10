% Parameters
int: N;                                      % Number of different products
set of int: PRODUCTS = 1..N;                 % Index set of products

array[PRODUCTS] of float: AssemblyHour;      % Assembly hours required per unit of product i
array[PRODUCTS] of float: TestingHour;       % Testing hours required per unit of product i
array[PRODUCTS] of float: MaterialCost;      % Raw material cost ($) per unit of product i
array[PRODUCTS] of float: Price;             % Selling price ($) per unit of product i

float: MaxAssembly;                          % Max regular assembly hours available per day
float: MaxTesting;                           % Max testing hours available per day
float: MaxOvertimeAssembly;                  % Max overtime assembly hours available per day
float: OvertimeAssemblyCost;                 % Overtime assembly cost ($) per hour

float: MaterialDiscount;                     % Discount percentage (e.g., 10 for 10%) on material bill if threshold reached
float: DiscountThreshold;                    % Material bill threshold ($) to trigger discount


% Variables
array[PRODUCTS] of var int: ProduceQty;       % Units of product i to produce (non-negative integers)

var float: RegularAssemblyUsed;              % Total regular assembly hours used
var float: OvertimeAssemblyUsed;             % Total overtime assembly hours used
var float: TestingUsed;                      % Total testing hours used

var float: TotalRevenue;                     % Sum of selling revenues ($)
var float: TotalMaterialBill;                % Sum of raw material costs before discount ($)
var float: MaterialDiscountAmount;           % Discount amount applied to material bill ($)
var float: TotalOvertimeCost;                % Total overtime assembly cost ($)

var bool: DiscountApplies;                   % True if TotalMaterialBill >= DiscountThreshold

var float: Profit;                           % Daily profit ($) = revenue - total costs


% Constraints
% Ensure production quantities are non-negative
constraint forall(p in PRODUCTS)(ProduceQty[p] >= 0);

%----------------------------
% Resource usage accounting
%----------------------------
constraint
  % Total testing hours used
  TestingUsed = sum(p in PRODUCTS)(TestingHour[p] * int2float(ProduceQty[p]));

%-----------------------------------------
% Assembly capacity with overtime splitting
%-----------------------------------------
constraint
  % Total regular assembly hours used is bounded by regular capacity
  RegularAssemblyUsed = sum(p in PRODUCTS)(AssemblyHour[p] * int2float(ProduceQty[p])) - OvertimeAssemblyUsed;

constraint
  % Regular assembly cannot exceed regular capacity
  RegularAssemblyUsed <= MaxAssembly;

constraint
  % Regular assembly is non-negative
  RegularAssemblyUsed >= 0.0;

constraint
  % Overtime hours are limited and non-negative
  OvertimeAssemblyUsed >= 0.0 /\
  OvertimeAssemblyUsed <= MaxOvertimeAssembly;

%----------------------------
% Testing capacity constraint
%----------------------------
constraint
  % Total testing hours cannot exceed testing capacity
  TestingUsed <= MaxTesting;

%----------------------------
% Revenue and cost accounting
%----------------------------
constraint
  % Total revenue from produced quantities
  TotalRevenue = sum(p in PRODUCTS)(Price[p] * int2float(ProduceQty[p]));

constraint
  % Total material bill before any discount
  TotalMaterialBill = sum(p in PRODUCTS)(MaterialCost[p] * int2float(ProduceQty[p]));

constraint
  % Total overtime assembly cost
  TotalOvertimeCost = OvertimeAssemblyUsed * OvertimeAssemblyCost;

%------------------------------------------
% Discount eligibility and discount amount
%------------------------------------------
constraint
  % Discount applies iff the (pre-discount) material bill meets/exceeds threshold
  DiscountApplies <-> (TotalMaterialBill >= DiscountThreshold);

constraint
  % Discount amount is percentage of the bill when applicable, else 0
  MaterialDiscountAmount =
    (if DiscountApplies then
       TotalMaterialBill * (MaterialDiscount / 100.0)
     else
       0.0
     endif);

%----------------------------
% Profit definition
%----------------------------
constraint
  % Profit = revenue - material cost after discount - overtime assembly cost
  Profit = TotalRevenue - (TotalMaterialBill - MaterialDiscountAmount) - TotalOvertimeCost;


% Objective
solve maximize Profit;