int: N;
set of int: P = 1..N;

array[P] of float: AssemblyHour;
array[P] of float: TestingHour;
array[P] of float: MaterialCost;

float: MaxAssembly;
float: MaxTesting;

array[P] of float: Price;

float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;

float: MaterialDiscount;
float: DiscountThreshold;

array[P] of var int: x;
var 0.0..MaxOvertimeAssembly: overtime_assembly_hours;
var bool: discount_applies;

var float: total_assembly_hours;
var float: total_testing_hours;
var float: total_material_bill;
var float: total_revenue;
var float: total_cost;
var float: profit;

constraint forall(i in P) (x[i] >= 0);

constraint total_assembly_hours = sum(i in P)(AssemblyHour[i] * int2float(x[i]));
constraint total_testing_hours  = sum(i in P)(TestingHour[i]  * int2float(x[i]));
constraint total_material_bill  = sum(i in P)(MaterialCost[i]  * int2float(x[i]));
constraint total_revenue        = sum(i in P)(Price[i]         * int2float(x[i]));

constraint total_testing_hours <= MaxTesting;

constraint total_assembly_hours <= MaxAssembly + overtime_assembly_hours;

constraint discount_applies <-> (total_material_bill >= DiscountThreshold);

constraint total_cost =
  OvertimeAssemblyCost * overtime_assembly_hours
  + total_material_bill
  - (if discount_applies then total_material_bill * (MaterialDiscount / 100.0) else 0.0 endif);

constraint profit = total_revenue - total_cost;

solve maximize profit;