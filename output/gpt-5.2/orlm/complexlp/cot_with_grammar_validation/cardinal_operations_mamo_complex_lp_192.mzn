float: asm_req_1 = 1.0/4.0;
float: test_req_1 = 1.0/8.0;
float: raw_cost_1 = 1.2;
float: value_1 = 9.0;

float: asm_req_2 = 1.0/3.0;
float: test_req_2 = 1.0/3.0;
float: raw_cost_2 = 0.9;
float: value_2 = 8.0;

float: asm_cap_regular = 90.0;
float: asm_cap_overtime_max = 50.0;
float: overtime_cost_per_hour = 7.0;

float: test_cap = 80.0;

var 0..10000: x1;
var 0..10000: x2;
var 0.0..asm_cap_overtime_max: overtime;

constraint
  asm_req_1 * int2float(x1) + asm_req_2 * int2float(x2) <= asm_cap_regular + overtime;

constraint
  test_req_1 * int2float(x1) + test_req_2 * int2float(x2) <= test_cap;

var float: profit =
    (value_1 - raw_cost_1) * int2float(x1)
  + (value_2 - raw_cost_2) * int2float(x2)
  - overtime_cost_per_hour * overtime;

solve maximize profit;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "overtime=", show(overtime), "\n",
  "profit=", show(round(profit)), "\n"
];