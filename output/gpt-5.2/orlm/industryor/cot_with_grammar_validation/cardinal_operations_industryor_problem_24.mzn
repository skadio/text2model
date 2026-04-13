int: total_capital = 100000;
float: r1 = 0.7;
float: r2 = 2.0;

var 0.0..total_capital: x11;
var 0.0..total_capital: x12;
var 0.0..total_capital: x13;
var 0.0..total_capital: x21;

constraint x11 + x21 <= total_capital;
constraint x12 <= r1 * x11;
constraint x13 <= r1 * x12 + r2 * x21;

var float: final_wealth = r1 * x13;

solve maximize final_wealth;

output [
  "x11=", show(x11), "\n",
  "x21=", show(x21), "\n",
  "x12=", show(x12), "\n",
  "x13=", show(x13), "\n",
  "final_wealth=", show(final_wealth), "\n"
];