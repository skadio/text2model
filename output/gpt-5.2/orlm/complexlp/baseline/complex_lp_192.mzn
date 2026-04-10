% Product mix with optional overtime assembly to maximize profit (rounded to nearest dollar)

% Data
float: asm1 = 1.0/4.0;
float: tst1 = 1.0/8.0;
float: raw1 = 1.2;
float: val1 = 9.0;

float: asm2 = 1.0/3.0;
float: tst2 = 1.0/3.0;
float: raw2 = 0.9;
float: val2 = 8.0;

float: asm_regular = 90.0;
float: tst_cap     = 80.0;

float: ot_max = 50.0;
float: ot_cost = 7.0;

% Decision variables (integer number of units produced)
var 0..100000: x1;
var 0..100000: x2;

% Overtime assembly hours used
var 0.0..ot_max: ot;

% Constraints
constraint asm1 * int2float(x1) + asm2 * int2float(x2) <= asm_regular + ot;
constraint tst1 * int2float(x1) + tst2 * int2float(x2) <= tst_cap;

% Profit = revenue - raw materials - overtime assembly cost
var float: profit =
    (val1 - raw1) * int2float(x1)
  + (val2 - raw2) * int2float(x2)
  - ot_cost * ot;

solve maximize profit;

% Output rounded to nearest dollar
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "overtime_hours=", show(ot), "\n",
  "profit=", show(profit), "\n",
  "profit_rounded=", show(round(profit)), "\n"
];