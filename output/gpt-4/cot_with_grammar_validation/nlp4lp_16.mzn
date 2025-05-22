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
array[1..N] of var 0..MaxAssembly: ProductQuantity;
var 0..MaxOvertimeAssembly: OvertimeAssembly;
var 0..MaxTesting: TotalTesting;
var 0..sum(i in 1..N)(ProductQuantity[i]*MaterialCost[i]): TotalMaterialCost;
var 0..sum(i in 1..N)(ProductQuantity[i]*Price[i]): TotalRevenue;

% Constraints
constraint forall(i in 1..N)(ProductQuantity[i]*AssemblyHour[i] <= MaxAssembly + OvertimeAssembly);
constraint forall(i in 1..N)(ProductQuantity[i]*TestingHour[i] <= MaxTesting);
constraint TotalMaterialCost = sum(i in 1..N)(ProductQuantity[i]*MaterialCost[i]);
constraint TotalRevenue = sum(i in 1..N)(ProductQuantity[i]*Price[i]);
constraint if TotalMaterialCost >= DiscountThreshold then TotalMaterialCost = TotalMaterialCost - MaterialDiscount/100*TotalMaterialCost endif;

% Objective
solve maximize TotalRevenue - TotalMaterialCost - OvertimeAssembly*OvertimeAssemblyCost;