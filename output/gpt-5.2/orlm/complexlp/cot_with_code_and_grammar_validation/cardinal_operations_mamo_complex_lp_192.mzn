var 0..intmax: x1;
var 0..intmax: x2;
var 0..50: ot;

constraint 6*x1 + 8*x2 <= 24*(90 + ot);
constraint 3*x1 + 8*x2 <= 24*80;

var int: profit10;
constraint profit10 = 78*x1 + 71*x2 - 70*ot;

solve maximize profit10;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "assembly_overtime_hours = ", show(ot), "\n",
  "profit = ", show(int2float(profit10) / 10.0), "\n",
  "profit_rounded_dollars = ", show(round(int2float(profit10) / 10.0)), "\n"
];