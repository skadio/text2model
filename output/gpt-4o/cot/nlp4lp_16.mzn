int: N;
array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
int: MaxAssembly;
int: MaxTesting;
array[1..N] of float: Price;
int: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;          % percentage, e.g. 10 means 10 %
float: DiscountThreshold;         % material-bill threshold for discount

% Decision variables
int: BigM = 1000000;
array[1..N] of var 0..BigM: Production;          % quantity of each product

var float: TotalAssembly   = sum(i in 1..N)(AssemblyHour[i]  * Production[i]);
var float: TotalTesting    = sum(i in 1..N)(TestingHour[i]   * Production[i]);
var float: MaterialBill    = sum(i in 1..N)(MaterialCost[i]  * Production[i]);

var 0.0..MaxOvertimeAssembly: OvertimeUsed;      % overtime hours actually used
var bool: DiscountApplies;                       % 1 iff discount is triggered

var float: EffectiveMaterialCost;                % material cost after discount
var float: Revenue = sum(i in 1..N)(Price[i] * Production[i]);
var float: Profit  = Revenue
                    - EffectiveMaterialCost
                    - OvertimeUsed * OvertimeAssemblyCost;

% Capacity constraints
constraint TotalTesting <= MaxTesting;
constraint TotalAssembly - OvertimeUsed <= MaxAssembly;
constraint OvertimeUsed >= TotalAssembly - MaxAssembly;
constraint OvertimeUsed <= TotalAssembly;
constraint OvertimeUsed <= MaxOvertimeAssembly;

% Discount trigger
constraint (MaterialBill >= DiscountThreshold) <-> DiscountApplies;

% Linear definition of effective material cost (avoids product of vars)
constraint DiscountApplies ->
           EffectiveMaterialCost = MaterialBill * (1.0 - MaterialDiscount / 100.0);
constraint not DiscountApplies ->
           EffectiveMaterialCost = MaterialBill;

% Objective
solve maximize Profit;