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
float: MaterialDiscount; % percentage (e.g., 10 for 10%)
float: DiscountThreshold;

% Derived bounds for production
int: minAssemblyHour = floor(min(AssemblyHour));
int: minTestingHour = floor(min(TestingHour));
int: maxProd = floor(MaxAssembly / minAssemblyHour) + floor(MaxTesting / minTestingHour) + floor(MaxOvertimeAssembly / minAssemblyHour);

% Variables
array[1..N] of var 0..maxProd: x; % units produced of each product
var float: totalAssembly;
var float: totalTesting;
var float: totalMaterialCost;
var float: overtimeAssembly;
var float: discountedCost;
var float: profit;

% Constraints
constraint
    % Compute totals
    totalAssembly = sum(i in 1..N) AssemblyHour[i] * x[i] / 1.0;
    totalTesting = sum(i in 1..N) TestingHour[i] * x[i] / 1.0;
    totalMaterialCost = sum(i in 1..N) MaterialCost[i] * x[i] / 1.0;

    % Resource limits
    totalAssembly <= MaxAssembly;
    totalTesting <= MaxTesting;

    % Overtime calculation
    overtimeAssembly = totalAssembly / 1.0 - MaxAssembly;
    overtimeAssembly >= 0.0;
    overtimeAssembly <= MaxOvertimeAssembly;

    % Discounted material cost
    discountedCost = if totalMaterialCost > DiscountThreshold
                        then totalMaterialCost * (1.0 - MaterialDiscount / 100.0)
                        else totalMaterialCost;

    % Profit definition
    profit = sum(i in 1..N) Price[i] * x[i] / 1.0
             - OvertimeAssemblyCost * overtimeAssembly
             - discountedCost;

% Objective
solve maximize profit;