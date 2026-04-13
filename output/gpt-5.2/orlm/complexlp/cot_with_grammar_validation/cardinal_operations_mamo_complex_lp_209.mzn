int: N = 5;
set of int: I = 1..N;

array[I] of float: out0 = [11.0, 53.0, 5.0, 5.0, 29.0];
array[I] of float: out1 = [3.0, 6.0, 5.0, 1.0, 34.0];
array[I] of float: npv  = [13.0, 16.0, 16.0, 14.0, 39.0];

float: budget0 = 40.0;
float: budget1 = 20.0;

array[I] of var float: x;
var float: total_npv;

constraint forall(i in I) (x[i] >= 0.0 /\ x[i] <= 1.0);

constraint sum(i in I)(out0[i] * x[i]) <= budget0;
constraint sum(i in I)(out1[i] * x[i]) <= budget1;

constraint total_npv = sum(i in I)(npv[i] * x[i]);

solve maximize total_npv;

output ["total_npv = \(total_npv)\n", "x = \(x)\n"];