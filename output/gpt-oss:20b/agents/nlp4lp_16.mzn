include "globals.mzn";

int: N;
array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
array[1..N] of float: Price;
float: MaxAssembly;
float: MaxTesting;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;      % percentage (e.g. 10 for 10%)
float: DiscountThreshold;

array[1..N] of var 0..inf: x;  % number of units to produce

var float: totalAssemblyHours = sum(i in 1..N)(x[i] * AssemblyHour[i]);
var float: totalTestingHours  = sum(i in 1..N)(x[i] * TestingHour[i]);
var float: totalMaterialCost  = sum(i in 1..N)(x[i] * MaterialCost[i]);
var float: revenue            = sum(i in 1..N)(x[i] * Price[i]);

var float: overtimeHours = max(0.0, totalAssemblyHours - MaxAssembly);
var float: overtimeCost = overtimeHours * OvertimeAssemblyCost;

var float: discountAmt =
   if totalMaterialCost >= DiscountThreshold
   then (MaterialDiscount / 100.0) * totalMaterialCost
   else 0.0
   endif;

var float: profit = revenue - (totalMaterialCost - discountAmt) - overtimeCost;

constraint totalTestingHours <= MaxTesting;
constraint overtimeHours <= MaxOvertimeAssembly;

solve maximize profit;

output [
  "Units produced: ", show(x), "\n",
  "Total Assembly Hours: ", show(totalAssemblyHours), "\n",
  "Total Testing Hours: ", show(totalTestingHours), "\n",
  "Total Material Cost: ", show(totalMaterialCost), "\n",
  "Discount Applied: ", show(discountAmt), "\n",
  "Overtime Hours: ", show(overtimeHours), "\n",
  "Overtime Cost: ", show(overtimeCost), "\n",
  "Revenue: ", show(revenue), "\n",
  "Profit: ", show(profit), "\n"
];