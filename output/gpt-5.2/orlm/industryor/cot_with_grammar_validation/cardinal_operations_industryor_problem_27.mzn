int: initial_fund = 300000;

float: r1 = 1.20;
float: r2 = 1.50;
float: r3 = 1.60;
float: r4 = 1.40;

int: cap2 = 150000;
int: cap3 = 200000;
int: cap4 = 100000;

var 0.0..float(initial_fund): x11;
var 0.0..float(initial_fund): x12;
var 0.0..float(initial_fund): x13;

var 0.0..float(cap2): x2;
var 0.0..float(cap3): x3;
var 0.0..float(cap4): x4;

var 0.0..10000000.0: F2;
var 0.0..10000000.0: F3;
var 0.0..10000000.0: final_amount;

constraint x11 + x2 <= float(initial_fund);
constraint F2 = r1 * x11;
constraint x12 + x3 <= F2;
constraint F3 = r1 * x12 + r2 * x2;
constraint x13 + x4 <= F3;
constraint final_amount = r1 * x13 + r3 * x3 + r4 * x4;

solve maximize final_amount;

output [
  "x11=", show(x11), "\n",
  "x12=", show(x12), "\n",
  "x13=", show(x13), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "final_amount=", show(final_amount), "\n"
];