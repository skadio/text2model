int: n = 5;

set of int: I = 1..n;

array[I] of float: out0 = [11.0, 53.0, 5.0, 5.0, 29.0];
array[I] of float: out1 = [3.0,  6.0, 5.0, 1.0, 34.0];
array[I] of float: npv  = [13.0, 16.0, 16.0, 14.0, 39.0];

float: budget0 = 40.0;
float: budget1 = 20.0;

array[I] of var float: x; % fraction purchased of each investment (0..1)

var float: total_npv = sum(i in I)(npv[i] * x[i]);

constraint forall(i in I)(0.0 <= x[i] /\ x[i] <= 1.0);

constraint sum(i in I)(out0[i] * x[i]) <= budget0;
constraint sum(i in I)(out1[i] * x[i]) <= budget1;

solve maximize total_npv;

output [
  "Maximum NPV (million $) = ", show(total_npv), "\n",
  "Fractions x = ", show(x), "\n",
  "Time 0 spend = ", show(sum(i in I)(out0[i] * x[i])), " (<= ", show(budget0), ")\n",
  "Time 1 spend = ", show(sum(i in I)(out1[i] * x[i])), " (<= ", show(budget1), ")\n"
];