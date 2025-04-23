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
int: M = 10000; % Maximum number of products that can be produced

% Variables
array[1..N] of var 0..M: Assembly; % Number of products assembled for each product
array[1..N] of var 0..M: Testing; % Number of products tested for each product
array[1..N] of var 0..M: OvertimeAssembly; % Number of products assembled during overtime for each product
var 0..sum(MaterialCost)*M: TotalMaterialCost; % Total cost of materials
var 0..sum(Price)*M: TotalRevenue; % Total revenue from selling the products
var 0..sum(Price)*M: Profit; % Profit from selling the products

% Constraints

% The total assembly hours for all products should not exceed the maximum assembly hours
constraint sum(i in 1..N)(Assembly[i]*AssemblyHour[i]) <= MaxAssembly;

% The total testing hours for all products should not exceed the maximum testing hours
constraint sum(i in 1..N)(Testing[i]*TestingHour[i]) <= MaxTesting;

% The total overtime assembly hours for all products should not exceed the maximum overtime assembly hours
constraint sum(i in 1..N)(OvertimeAssembly[i]*AssemblyHour[i]) <= MaxOvertimeAssembly;

% The total material cost for all products should be equal to the sum of the material cost for each product
constraint TotalMaterialCost = sum(i in 1..N)((Assembly[i] + OvertimeAssembly[i])*MaterialCost[i]);

% If the total material cost is above the discount threshold, apply the discount
constraint if TotalMaterialCost >= DiscountThreshold then TotalMaterialCost = TotalMaterialCost * (1 - MaterialDiscount) endif;

% The total revenue should be equal to the sum of the price for each product
constraint TotalRevenue = sum(i in 1..N)((Assembly[i] + OvertimeAssembly[i])*Price[i]);

% The profit should be equal to the total revenue minus the total cost (including overtime cost)
constraint Profit = TotalRevenue - TotalMaterialCost - sum(i in 1..N)((Assembly[i] + OvertimeAssembly[i])*AssemblyHour[i]) - sum(i in 1..N)(Testing[i]*TestingHour[i]) - sum(i in 1..N)(OvertimeAssembly[i]*OvertimeAssemblyCost);

% Objective
solve maximize Profit;