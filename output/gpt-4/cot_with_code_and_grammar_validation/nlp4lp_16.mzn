% Parameters
int: N;
array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
float: MaxAssembly;
float: MaxTesting;
array[1..N] of float: Price;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;
float: DiscountThreshold;

% Variables
array[1..N] of var 0..MaxAssembly/AssemblyHour[1]: ProductQuantity; % Corrected the index error
var 0..MaxOvertimeAssembly: OvertimeHours;
var float: TotalMaterialCost;
var float: TotalRevenue;
var float: TotalCost;
var float: Profit;

% Constraints
constraint forall(i in 1..N) (
    AssemblyHour[i]*ProductQuantity[i] + OvertimeHours <= MaxAssembly + MaxOvertimeAssembly
);
constraint forall(i in 1..N) (
    TestingHour[i]*ProductQuantity[i] <= MaxTesting
);
constraint TotalMaterialCost = sum(i in 1..N) (MaterialCost[i]*ProductQuantity[i]);
constraint if TotalMaterialCost >= DiscountThreshold then TotalMaterialCost = TotalMaterialCost - MaterialDiscount/100*TotalMaterialCost endif; % Corrected the constraint
constraint TotalRevenue = sum(i in 1..N) (Price[i]*ProductQuantity[i]);
constraint TotalCost = TotalMaterialCost + OvertimeHours*OvertimeAssemblyCost;
constraint Profit = TotalRevenue - TotalCost;

% Objective
solve maximize Profit;