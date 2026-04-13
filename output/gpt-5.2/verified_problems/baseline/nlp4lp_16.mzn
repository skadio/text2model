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

float: MaterialDiscount;        % percentage, e.g., 10 means 10%
float: DiscountThreshold;       % $ threshold on daily material bill

% Decision variables: units produced of each product (assumed integer, nonnegative)
array[P] of var int: x;
constraint forall(i in P)(x[i] >= 0);

% Overtime assembly hours used
var float: overtime;
constraint overtime >= 0.0 /\ overtime <= MaxOvertimeAssembly;

% Totals
var float: totalAssembly = sum(i in P)(AssemblyHour[i] * int2float(x[i]));
var float: totalTesting  = sum(i in P)(TestingHour[i]  * int2float(x[i]));
var float: materialBill  = sum(i in P)(MaterialCost[i] * int2float(x[i]));
var float: revenue       = sum(i in P)(Price[i]        * int2float(x[i]));

% Capacity constraints
constraint totalAssembly <= MaxAssembly + overtime;
constraint totalTesting  <= MaxTesting;

% Discount activation (strictly above threshold as stated)
var bool: discount_applies;
constraint discount_applies <-> (materialBill > DiscountThreshold);

var float: effectiveMaterialCost =
  materialBill * (1.0 - (MaterialDiscount / 100.0) * bool2int(discount_applies));

% Objective: profit = revenue - (material cost after discount) - overtime cost
var float: profit = revenue - effectiveMaterialCost - OvertimeAssemblyCost * overtime;

solve maximize profit;

output [
  "x = ", show(x), "\n",
  "totalAssembly = ", show(totalAssembly), "\n",
  "overtime = ", show(overtime), "\n",
  "totalTesting = ", show(totalTesting), "\n",
  "materialBill = ", show(materialBill), "\n",
  "discount_applies = ", show(discount_applies), "\n",
  "effectiveMaterialCost = ", show(effectiveMaterialCost), "\n",
  "revenue = ", show(revenue), "\n",
  "profit = ", show(profit), "\n"
];