int: N;
set of int: P = 1..N;

array[P] of float: AssemblyHour;
array[P] of float: TestingHour;
array[P] of float: MaterialCost;
array[P] of float: Price;

float: MaxAssembly;
float: MaxTesting;

float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;

float: MaterialDiscount;
float: DiscountThreshold;

array[P] of var int: x;
var float: overtime_assembly_hours;
var bool: discount_applies;

var float: total_assembly_hours;
var float: total_testing_hours;
var float: total_material_bill;
var float: total_revenue;

var float: material_cost_after_discount;
var float: profit;

constraint forall(i in P) (x[i] >= 0);

constraint overtime_assembly_hours >= 0.0;
constraint overtime_assembly_hours <= MaxOvertimeAssembly;

constraint total_assembly_hours = sum(i in P) (AssemblyHour[i] * int2float(x[i]));
constraint total_testing_hours  = sum(i in P) (TestingHour[i]  * int2float(x[i]));
constraint total_material_bill  = sum(i in P) (MaterialCost[i]  * int2float(x[i]));
constraint total_revenue        = sum(i in P) (Price[i]         * int2float(x[i]));

constraint total_assembly_hours <= MaxAssembly + overtime_assembly_hours;
constraint total_testing_hours <= MaxTesting;

constraint discount_applies <-> (total_material_bill >= DiscountThreshold);

constraint material_cost_after_discount =
  total_material_bill * (1.0 - (MaterialDiscount / 100.0) * int2float(bool2int(discount_applies)));

constraint profit =
  total_revenue - material_cost_after_discount - OvertimeAssemblyCost * overtime_assembly_hours;

solve maximize profit;