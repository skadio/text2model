int: N;  % Number of different products
array[1..N] of float: AssemblyHour;  % Hours required to assemble product i
array[1..N] of float: TestingHour;   % Hours required to test product i
array[1..N] of float: MaterialCost;   % Material cost for product i
float: MaxAssembly;                   % Maximum total hours available for assembly
float: MaxTesting;                    % Maximum total hours available for testing
array[1..N] of float: Price;          % Selling price for product i
float: MaxOvertimeAssembly;           % Maximum overtime hours available for assembly
float: OvertimeAssemblyCost;          % Overtime cost for assembly per hour
float: MaterialDiscount;              % Discount on material cost when a certain threshold is reached
float: DiscountThreshold;              % Threshold for the quantity to reach to obtain the material discount

array[1..N] of var 0..MaxAssembly: AssemblyQty;  % Quantity of each product to assemble
array[1..N] of var 0..MaxTesting: TestingQty;     % Quantity of each product to test

% Constraints for assembly and testing hours
constraint sum(i in 1..N)(AssemblyHour[i] * AssemblyQty[i]) <= MaxAssembly;
constraint sum(i in 1..N)(TestingHour[i] * TestingQty[i]) <= MaxTesting;

% Calculate total revenue and total cost
var float: TotalRevenue = sum(i in 1..N)(Price[i] * AssemblyQty[i]);
var float: TotalMaterialCost = sum(i in 1..N)(MaterialCost[i] * AssemblyQty[i]);
var float: TotalOvertimeCost = max(0, sum(i in 1..N)(AssemblyHour[i] * AssemblyQty[i]) - MaxAssembly) * OvertimeAssemblyCost;

% Calculate total cost with potential discount
var float: TotalCost = TotalMaterialCost + TotalOvertimeCost;
var float: TotalCostWithDiscount = if TotalMaterialCost > DiscountThreshold then TotalCost - MaterialDiscount else TotalCost;

% Objective: Maximize profit
var float: Profit = TotalRevenue - TotalCostWithDiscount;

solve maximize Profit;

output [
    "Total Revenue = ", show(TotalRevenue), "\n",
    "Total Cost = ", show(TotalCostWithDiscount), "\n",
    "Profit = ", show(Profit), "\n",
    "Assembly Quantities = ", show(AssemblyQty), "\n",
    "Testing Quantities = ", show(TestingQty), "\n"
];