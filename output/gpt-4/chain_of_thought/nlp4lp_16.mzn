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
array[1..N] of var 0..MaxAssembly: Assembly;
array[1..N] of var 0..MaxTesting: Testing;
array[1..N] of var 0..MaxOvertimeAssembly: OvertimeAssembly;
var 0..sum(i in 1..N)(MaterialCost[i]*Assembly[i]): TotalMaterialCost;
var 0..sum(i in 1..N)(Price[i]*Assembly[i]): TotalRevenue;
var 0..sum(i in 1..N)(OvertimeAssemblyCost*OvertimeAssembly[i]): TotalOvertimeCost;
var 0..TotalRevenue-TotalMaterialCost-TotalOvertimeCost: Profit;

% Constraints
constraint forall(i in 1..N)(Assembly[i] <= MaxAssembly/AssemblyHour[i]);
constraint forall(i in 1..N)(Testing[i] <= MaxTesting/TestingHour[i]);
constraint sum(i in 1..N)(Assembly[i]*AssemblyHour[i]) <= MaxAssembly;
constraint sum(i in 1..N)(Testing[i]*TestingHour[i]) <= MaxTesting;
constraint sum(i in 1..N)(OvertimeAssembly[i]) <= MaxOvertimeAssembly;
constraint TotalMaterialCost = if sum(i in 1..N)(MaterialCost[i]*Assembly[i]) > DiscountThreshold then (1-MaterialDiscount/100)*sum(i in 1..N)(MaterialCost[i]*Assembly[i]) else sum(i in 1..N)(MaterialCost[i]*Assembly[i]) endif;
constraint TotalRevenue = sum(i in 1..N)(Price[i]*Assembly[i]);
constraint TotalOvertimeCost = sum(i in 1..N)(OvertimeAssemblyCost*OvertimeAssembly[i]);
constraint Profit = TotalRevenue - TotalMaterialCost - TotalOvertimeCost;

% Objective
solve maximize Profit;