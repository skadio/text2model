int: T = 6;
set of int: Months = 1..T;

array[Months] of int: d1 = [30000, 30000, 30000, 100000, 100000, 100000];
array[Months] of int: d2 = [15000, 15000, 15000, 50000, 50000, 50000];

array[Months] of float: c1 = [4.5, 4.5, 4.5, 4.5, 4.5, 4.5];
array[Months] of float: c2 = [7.0, 7.0, 7.0, 7.0, 7.0, 7.0];

int: cap = 120000;

float: v1 = 0.2;
float: v2 = 0.4;

float: W = 15000.0;
float: h_in = 1.0;
float: h_out = 1.5;

int: I10 = 0;
int: I20 = 0;

int: maxDemand1 = 100000;
int: maxDemand2 = 50000;
int: maxProd1 = cap;
int: maxProd2 = cap;

array[Months] of var 0..maxProd1: x1;
array[Months] of var 0..maxProd2: x2;

array[Months] of var 0..(T * maxDemand1): inv1;
array[Months] of var 0..(T * maxDemand2): inv2;

array[Months] of var 0.0..(W + 1.0e8): use_in;
array[Months] of var 0.0..(1.0e8): use_out;

var float: total_cost;

constraint forall(t in Months) (
  x1[t] + x2[t] <= cap
);

constraint inv1[1] = I10 + x1[1] - d1[1];
constraint inv2[1] = I20 + x2[1] - d2[1];

constraint forall(t in 2..T) (
  inv1[t] = inv1[t - 1] + x1[t] - d1[t]
);
constraint forall(t in 2..T) (
  inv2[t] = inv2[t - 1] + x2[t] - d2[t]
);

constraint forall(t in Months) (
  use_in[t] + use_out[t] = v1 * int2float(inv1[t]) + v2 * int2float(inv2[t])
);
constraint forall(t in Months) (
  use_in[t] <= W
);

constraint total_cost =
  sum(t in Months) (
    c1[t] * int2float(x1[t]) + c2[t] * int2float(x2[t])
    + h_in * use_in[t] + h_out * use_out[t]
  );

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "inv1=", show(inv1), "\n",
  "inv2=", show(inv2), "\n",
  "use_in=", show(use_in), "\n",
  "use_out=", show(use_out), "\n",
  "total_cost=", show(total_cost), "\n"
];