int: N;
set of int: PRODUCTS = 1..N;

array[PRODUCTS] of float: AssemblyHour;
array[PRODUCTS] of float: TestingHour;
array[PRODUCTS] of float: MaterialCost;
int: MaxAssembly;
int: MaxTesting;
array[PRODUCTS] of float: Price;

int: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;

float: MaterialDiscount;      % percentage, e.g., 10 means 10%
float: DiscountThreshold;     % $ threshold for applying discount

% Decision variables
array[PRODUCTS] of var int: x;                 % units produced of each product
var 0..MaxOvertimeAssembly: overtimeAssembly;  % overtime assembly hours used

% Helper expressions
var float: totalAssemblyHours = sum(i in PRODUCTS)(AssemblyHour[i] * x[i]);
var float: totalTestingHours  = sum(i in PRODUCTS)(TestingHour[i] * x[i]);

var float: revenue = sum(i in PRODUCTS)(Price[i] * x[i]);

var float: materialBill = sum(i in PRODUCTS)(MaterialCost[i] * x[i]);

var bool: discountApplies;
constraint discountApplies <-> (materialBill >= DiscountThreshold);

var float: materialCostPaid =
  if discountApplies then materialBill * (1.0 - MaterialDiscount / 100.0)
  else materialBill endif;

var float: overtimeCost = OvertimeAssemblyCost * overtimeAssembly;

var float: Profit = revenue - materialCostPaid - overtimeCost;

% Constraints
constraint totalAssemblyHours <= MaxAssembly + overtimeAssembly;
constraint totalTestingHours  <= MaxTesting;

solve maximize Profit;

output [
  "x = ", show(x), "\n",
  "totalAssemblyHours = ", show(totalAssemblyHours), "\n",
  "overtimeAssembly = ", show(overtimeAssembly), "\n",
  "totalTestingHours = ", show(totalTestingHours), "\n",
  "revenue = ", show(revenue), "\n",
  "materialBill = ", show(materialBill), "\n",
  "discountApplies = ", show(discountApplies), "\n",
  "materialCostPaid = ", show(materialCostPaid), "\n",
  "overtimeCost = ", show(overtimeCost), "\n",
  "Profit = ", show(Profit), "\n"
];