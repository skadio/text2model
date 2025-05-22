int: N;

array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
array[1..N] of float: Price;

float: MaxAssembly;
float: MaxTesting;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;     % percentage (e.g., 10 means 10 %)
float: DiscountThreshold;

array[1..N] of int: MaxUnits =
  [ ceil((MaxAssembly + MaxOvertimeAssembly) / AssemblyHour[i]) | i in 1..N ];

array[1..N] of var 0..MaxUnits[i]: X;              % units of each product
var 0.0 .. MaxOvertimeAssembly: OTAssembly;        % overtime assembly hours
var bool: discountApplied;                         % whether the discount is used

var float: TotalAssemblyHours;
var float: TotalTestingHours;
var float: TotalMaterialCost;
var float: MaterialCostAfterDiscount;
var float: TotalRevenue;
var float: Profit;

% Aggregate calculations
constraint TotalAssemblyHours = sum(i in 1..N)(AssemblyHour[i] * X[i]);
constraint TotalTestingHours  = sum(i in 1..N)(TestingHour[i]  * X[i]);
constraint TotalMaterialCost  = sum(i in 1..N)(MaterialCost[i] * X[i]);
constraint TotalRevenue       = sum(i in 1..N)(Price[i]       * X[i]);

% Capacity limits
constraint TotalAssemblyHours <= MaxAssembly + OTAssembly;
constraint OTAssembly         >= TotalAssemblyHours - MaxAssembly;
constraint TotalTestingHours  <= MaxTesting;

% Discount logic
constraint discountApplied          -> TotalMaterialCost >= DiscountThreshold;
constraint (not discountApplied)    -> TotalMaterialCost <= DiscountThreshold - 1e-6;

constraint MaterialCostAfterDiscount =
    TotalMaterialCost * (1.0 - (MaterialDiscount / 100.0) * bool2int(discountApplied));

% Profit
constraint Profit =
    TotalRevenue - MaterialCostAfterDiscount - OTAssembly * OvertimeAssemblyCost;

% Objective
solve maximize Profit;