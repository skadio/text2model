int: nF = 5;
int: nP = 4;

int: H_F = 160;
int: H_P = 80;

int: rate_F = 5;
int: rate_P = 2;

int: target_sales = 5500;

int: M1 = 1000000;
int: M2 = 1000;

var 0..2000: OT_F;
var 0..2000: OT_P;

var 0..1000000: short_sales;

var 0..10000000: total_pairs;
var 0..1000000: total_OT;

constraint total_pairs =
  nF * rate_F * (H_F + OT_F) +
  nP * rate_P * (H_P + OT_P);

constraint short_sales >= target_sales - total_pairs;
constraint short_sales >= 0;

constraint total_OT = nF * OT_F + nP * OT_P;

solve minimize M1 * short_sales + M2 * total_OT;

output [
  "total_pairs=", show(total_pairs), "\n",
  "short_sales=", show(short_sales), "\n",
  "OT_F=", show(OT_F), "\n",
  "OT_P=", show(OT_P), "\n",
  "total_OT=", show(total_OT), "\n"
];