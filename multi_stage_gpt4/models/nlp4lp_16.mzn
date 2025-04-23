% Parameters
int: N; % Number of different products
array[1..N] of int: AssemblyHour; % Hours required to assemble product i
array[1..N] of int: TestingHour; % Hours required to test product i
array[1..N] of int: MaterialCost; % Material cost for product i
int: MaxAssembly; % Maximum total hours available for assembly
int: MaxTesting; % Maximum total hours available for testing
array[1..N] of int: Price; % Selling price for product i
int: MaxOvertimeAssembly; % Maximum overtime hours available for assembly
int: OvertimeAssemblyCost; % Overtime cost for assembly per hour
float: MaterialDiscount; % Discount on material cost when a certain threshold is reached
int: DiscountThreshold; % Threshold for the quantity to reach to obtain the material discount

% Variables
array[1..N] of var 0..MaxAssembly: Assembly; % Number of assembly hours for each product
array[1..N] of var 0..MaxTesting: Testing; % Number of testing hours for each product
array[1..N] of var 0..MaxOvertimeAssembly: OvertimeAssembly; % Number of overtime assembly hours for each product
var 0..sum(MaterialCost): TotalMaterialCost; % Total cost of materials
var 0..sum(Price): TotalRevenue; % Total revenue from selling products
var 0..sum(Price): Profit; % Total profit

% Constraints

% The total assembly hours for all products should not exceed the maximum assembly hours
constraint sum(i in 1..N)(Assembly[i]*AssemblyHour[i]) <= MaxAssembly;

% The total testing hours for all products should not exceed the maximum testing hours
constraint sum(i in 1..N)(Testing[i]*TestingHour[i]) <= MaxTesting;

% The total overtime assembly hours for all products should not exceed the maximum overtime assembly hours
constraint sum(i in 1..N)(OvertimeAssembly[i]) <= MaxOvertimeAssembly;

% The total cost of materials should be equal to the sum of the material cost for all products
constraint TotalMaterialCost = sum(i in 1..N)(Assembly[i]*MaterialCost[i]);

% If the total cost of materials is above the discount threshold, apply the discount
constraint if TotalMaterialCost >= DiscountThreshold then 
    TotalMaterialCost = TotalMaterialCost - TotalMaterialCost*MaterialDiscount 
else 
    TotalMaterialCost = TotalMaterialCost endif;

% The total revenue should be equal to the sum of the price for all products
constraint TotalRevenue = sum(i in 1..N)(Assembly[i]*Price[i]);

% The total profit should be equal to the total revenue minus the total cost of materials and overtime assembly cost
constraint Profit = TotalRevenue - TotalMaterialCost - sum(i in 1..N)(OvertimeAssembly[i]*OvertimeAssemblyCost);

% Objective
solve maximize Profit;