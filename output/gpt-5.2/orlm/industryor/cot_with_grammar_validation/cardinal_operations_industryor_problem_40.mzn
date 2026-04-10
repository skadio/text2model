int: Y = 3;
set of int: YEARS = 1..Y;

int: init_capital = 500000;

float: r1 = 1.20;
float: r2 = 1.50;
float: r3 = 1.60;
float: r4 = 1.40;

int: cap2 = 120000;
int: cap3 = 150000;
int: cap4 = 100000;

var 0..init_capital: x1_1;
var 0..init_capital: x1_2;
var 0..init_capital: x1_3;

var 0..cap2: x2;
var 0..cap3: x3;
var 0..cap4: x4;

var float: W2;
var float: W3;
var float: W4;

constraint x1_1 + x2 <= init_capital;

constraint W2 = r1 * int2float(x1_1) + int2float(init_capital - x1_1 - x2);

constraint x1_2 + x3 <= W2;

constraint W3 =
  r1 * int2float(x1_2)
  + r2 * int2float(x2)
  + r3 * int2float(x3)
  + int2float(init_capital - x1_1 - x2)
  + int2float(init_capital - x1_1 - x2) * 0.0
  + (W2 - int2float(x1_2) - int2float(x3));

constraint x1_3 + x4 <= W3;

constraint W4 = r1 * int2float(x1_3) + r4 * int2float(x4) + (W3 - int2float(x1_3) - int2float(x4));

solve maximize W4;

output [
  "x1_1=", show(x1_1), "\n",
  "x2=", show(x2), "\n",
  "x1_2=", show(x1_2), "\n",
  "x3=", show(x3), "\n",
  "x1_3=", show(x1_3), "\n",
  "x4=", show(x4), "\n",
  "W2=", show(W2), "\n",
  "W3=", show(W3), "\n",
  "W4=", show(W4), "\n"
];