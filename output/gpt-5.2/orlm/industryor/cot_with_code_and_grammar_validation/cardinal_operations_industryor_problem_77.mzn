int: nF = 5;
int: nP = 4;

int: H_F = 160;
int: H_P = 80;

int: rateF = 5;
int: rateP = 2;

int: target_sales = 5500;

int: W1 = 100000;
int: W2 = 100;
int: W3 = 1;

int: OTmaxF = 1000;
int: OTmaxP = 1000;

array[1..nF] of var 0..OTmaxF: ot_hours_F;
array[1..nP] of var 0..OTmaxP: ot_hours_P;

var 0..target_sales: d_sales_minus;
var 0..target_sales: d_sales_plus;

int: regular_hours = nF * H_F + nP * H_P;

var 0..regular_hours: d_employ_minus;
var 0..(nF * OTmaxF + nP * OTmaxP): d_employ_plus;

var 0..(nF * OTmaxF + nP * OTmaxP): total_overtime;
constraint total_overtime = sum(ot_hours_F) + sum(ot_hours_P);

var regular_hours..(regular_hours + nF * OTmaxF + nP * OTmaxP): total_hours;
constraint total_hours = regular_hours + total_overtime;

var 0..(rateF * (nF * H_F + nF * OTmaxF) + rateP * (nP * H_P + nP * OTmaxP)): total_sales;
constraint total_sales =
  rateF * (nF * H_F + sum(ot_hours_F)) + rateP * (nP * H_P + sum(ot_hours_P));

constraint total_sales + d_sales_minus - d_sales_plus = target_sales;

constraint regular_hours + d_employ_minus - d_employ_plus = total_hours;

constraint d_employ_plus = total_overtime;

solve minimize W1 * d_sales_minus + W2 * d_employ_minus + W3 * total_overtime;

output [
  "total_sales=", show(total_sales), "\n",
  "sales_shortfall=", show(d_sales_minus), "\n",
  "regular_hours=", show(regular_hours), "\n",
  "underuse_regular_hours=", show(d_employ_minus), "\n",
  "total_overtime=", show(total_overtime), "\n"
];