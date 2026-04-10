int: initial_capital = 500000;

int: cap2 = 120000;
int: cap3 = 150000;
int: cap4 = 100000;

int: r1 = 120;
int: r2 = 150;
int: r3 = 160;
int: r4 = 140;
int: SCALE = 100;

var 0..initial_capital: x11;
var 0..cap2: x12;

var 0..(initial_capital * 2): x21;
var 0..cap3: x23;

var 0..(initial_capital * 3): x31;
var 0..cap4: x34;

var 0..(initial_capital * 10 * SCALE): W3_scaled;

constraint x11 + x12 <= initial_capital;

constraint SCALE * (x21 + x23) <= r1 * x11;

constraint SCALE * (x31 + x34) <= r1 * x21 + r2 * x12 + r3 * x23;

constraint W3_scaled = r1 * x31 + r4 * x34;

solve maximize W3_scaled;

output [
  "x11=", show(x11), "  x12=", show(x12), "\n",
  "x21=", show(x21), "  x23=", show(x23), "\n",
  "x31=", show(x31), "  x34=", show(x34), "\n",
  "W3(end Y3)=", show(W3_scaled div SCALE), " yuan  (scaled=", show(W3_scaled), ")\n"
];