include "globals.mzn";

% Parameters
int: N; % Number of different products
array[1..N] of float: AssemblyHour; % Hours required to assemble product i
array[1..N] of float: TestingHour; % Hours required to test product i
array[1..N] of float: MaterialCost; % Material cost for product i
float: MaxAssembly; % Maximum total hours available for assembly
float: MaxTesting; % Maximum total hours available for testing
array[1..N] of float: Price; % Selling price for product i
float: MaxOvertimeAssembly; % Maximum overtime hours available for assembly
float: OvertimeAssemblyCost; % Overtime cost for assembly per hour
float: MaterialDiscount; % Discount on material cost when a certain threshold is reached
float: DiscountThreshold; % Threshold for the quantity to reach to obtain the material discount

% Variables
array[1..N] of var 0..1000: Production; % Number of each product to produce

% Constraints
constraint sum(i in 1..N)(AssemblyHour[i]*Production[i]) <= MaxAssembly + MaxOvertimeAssembly;
constraint sum(i in 1..N)(TestingHour[i]*Production[i]) <= MaxTesting;
constraint forall(i in 1..N)(AssemblyHour[i]*Production[i] <= MaxAssembly + (if sum(j in 1..N)(MaterialCost[j]*Production[j]) >= DiscountThreshold then MaterialDiscount else 0 endif));

% Objective
var float: TotalRevenue = sum(i in 1..N)(Price[i]*Production[i]);
var float: TotalCost = sum(i in 1..N)(MaterialCost[i]*Production[i]) + (if sum(i in 1..N)(AssemblyHour[i]*Production[i]) > MaxAssembly then (sum(i in 1..N)(AssemblyHour[i]*Production[i]) - MaxAssembly)*OvertimeAssemblyCost else 0 endif);
var float: Profit = TotalRevenue - TotalCost;

solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++ ["Production: ", show(Production)];