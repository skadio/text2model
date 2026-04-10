float: initial_fund = 300000.0;

float: p1_return = 1.20;
float: p2_return = 1.50;
float: p3_return = 1.60;
float: p4_return = 1.40;

float: p2_cap = 150000.0;
float: p3_cap = 200000.0;
float: p4_cap = 100000.0;

var 0.0..initial_fund: x1_y1;
var 0.0..initial_fund: x1_y2;
var 0.0..initial_fund: x1_y3;

var 0.0..p2_cap: x2;
var 0.0..p3_cap: x3;
var 0.0..p4_cap: x4;

var 0.0..1.0e12: fund_y2_start;
var 0.0..1.0e12: fund_y3_start;
var 0.0..1.0e12: final_amount;

constraint x1_y1 + x2 <= initial_fund;

constraint fund_y2_start = p1_return * x1_y1;
constraint x1_y2 + x3 <= fund_y2_start;

constraint fund_y3_start = p1_return * x1_y2 + p2_return * x2;
constraint x1_y3 + x4 <= fund_y3_start;

constraint final_amount = p1_return * x1_y3 + p3_return * x3 + p4_return * x4;

solve maximize final_amount;

output [
  "x1_y1=", show(x1_y1), "\n",
  "x2=", show(x2), "\n",
  "x1_y2=", show(x1_y2), "\n",
  "x3=", show(x3), "\n",
  "x1_y3=", show(x1_y3), "\n",
  "x4=", show(x4), "\n",
  "final_amount=", show(final_amount), "\n"
];