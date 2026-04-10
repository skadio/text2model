% Product mix with overtime assembly and material discount

% Parameters
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

float: MaterialDiscount;   % percentage (e.g., 10 means 10%)
float: DiscountThreshold;  % $ threshold on daily material bill

% Decision variables
array[P] of var int: x;                       % units produced (>= 0)
var 0.0..MaxOvertimeAssembly: overtime_assembly;

% Derived variables
var float: revenue;
var float: material_bill;
var float: assembly_overtime_cost;
var float: material_discount_amount;
var float: profit;

% Constraints
constraint forall(i in P) (x[i] >= 0);

constraint sum(i in P)(AssemblyHour[i] * int2float(x[i]))
          <= MaxAssembly + overtime_assembly;

constraint sum(i in P)(TestingHour[i] * int2float(x[i]))
          <= MaxTesting;

constraint revenue = sum(i in P)(Price[i] * int2float(x[i]));
constraint material_bill = sum(i in P)(MaterialCost[i] * int2float(x[i]));
constraint assembly_overtime_cost = OvertimeAssemblyCost * overtime_assembly;

constraint material_discount_amount =
  (MaterialDiscount / 100.0) * material_bill * bool2int(material_bill >= DiscountThreshold);

constraint profit = revenue - (material_bill - material_discount_amount) - assembly_overtime_cost;

% Objective
solve maximize profit;