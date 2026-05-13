The analysis got stuck in a loop. Let's produce final code.int: N;

array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
array[1..N] of float: Price;

float: MaxAssembly;
float: MaxTesting;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;   % percentage (e.g. 10 for 10%)
float: DiscountThreshold;

% Decision variables
array[1..N] of var 0..maxint: int: qty;
var 0.0..MaxOvertimeAssembly: float: overtimeAssemblyHours;

% Derived quantities
var float: totalAssemblyHours = sum(i in 1..N) AssemblyHour[i] * qty[i];
var float: totalTestingHours   = sum(i in 1..N) TestingHour[i] * qty[i];
var float: totalMaterialCost   = sum(i in 1..N) MaterialCost[i] * qty[i];
var float: totalRevenue        = sum(i in 1..N) Price[i] * qty[i];

var float: discount = 
    if totalMaterialCost > DiscountThreshold 
    then (MaterialDiscount / 100.0) * totalMaterialCost 
    else 0.0 
    endif;

var float: netMaterialCost = totalMaterialCost - discount;

var float: profit = totalRevenue - (overtimeAssemblyHours * OvertimeAssemblyCost + netMaterialCost);

% Constraints
constraint
    totalAssemblyHours <= MaxAssembly + overtimeAssemblyHours /\
    totalTestingHours   <= MaxTesting /\
    overtimeAssemblyHours <= MaxOvertimeAssembly /\
    overtimeAssemblyHours >= 0.0;

solve maximize profit;

output [
    "Qty: ", show(qty), "\n",
    "OvertimeAssemblyHours: ", show(overtimeAssemblyHours), "\n",
    "Profit: ", show(profit), "\n"
];