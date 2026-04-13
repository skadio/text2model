float: initial_capital = 100000.0;
float: r1 = 0.7;
float: r2 = 2.0;

var 0.0..initial_capital: x1;
var 0.0..initial_capital: x2;
var 0.0..(initial_capital * (1.0 + r1)): y1;
var 0.0..(initial_capital * (1.0 + r1)): y2;

var float: earnings_end_year3;

constraint x1 + x2 <= initial_capital;
constraint y1 + y2 <= initial_capital + r1 * x1;

constraint earnings_end_year3 =
  initial_capital + r1 * x1 + r1 * y1 + r2 * x2 + r2 * y2;

solve maximize earnings_end_year3;

output [
  "x1 (opt1, year1) = ", show(x1), "\n",
  "x2 (opt2, year1) = ", show(x2), "\n",
  "y1 (opt1, year2) = ", show(y1), "\n",
  "y2 (opt2, year2) = ", show(y2), "\n",
  "earnings_end_year3 = ", show(earnings_end_year3), "\n"
];