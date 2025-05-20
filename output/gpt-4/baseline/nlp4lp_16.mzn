include "globals.mzn";

% Number of different products
int: N;

% Hours required to assemble product i
array[1..N] of float: AssemblyHour;

% Hours required to test product i
array[1..N] of float: TestingHour;

% Material cost for product i
array[1..N] of float: MaterialCost;

% Maximum total hours available for assembly
float: MaxAssembly;

% Maximum total hours available for testing
float: MaxTesting;

% Selling price for product i
array[1..N] of float: Price;

% Maximum overtime hours available for assembly
float: MaxOvertimeAssembly;

% Overtime cost for assembly per hour
float: OvertimeAssemblyCost;

% Discount on material cost when a certain threshold is reached
float: MaterialDiscount;

% Threshold for the quantity to reach to obtain the material discount
float: DiscountThreshold;

% Decision variable: number of each product to produce
var 0..1000: Product[1..N];

% Objective: maximize profit
maximize sum(i in 1..N) (Price[i] * Product[i]) - sum(i in 1..N) (MaterialCost[i] * Product[i]) - (OvertimeAssemblyCost * sum(i in 1..N) (max(0, AssemblyHour[i] * Product[i] - MaxAssembly)));

% Constraints
constraint sum(i in 1..N) (AssemblyHour[i] * Product[i]) <= MaxAssembly + MaxOvertimeAssembly;
constraint sum(i in 1..N) (TestingHour[i] * Product[i]) <= MaxTesting;
constraint sum(i in 1..N) (MaterialCost[i] * Product[i]) >= DiscountThreshold -> forall(i in 1..N) (MaterialCost[i] = MaterialCost[i] * (1 - MaterialDiscount/100));

solve satisfy;