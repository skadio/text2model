int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

array[1..M] of var 0.0..1.0e6: power;

array[1..N] of var float: illumination;
array[1..N] of var float: abs_error;
var float: total_abs_error;

constraint forall(j in 1..M) (power[j] >= 0.0);

constraint forall(i in 1..N) (
  illumination[i] = sum(j in 1..M) (Coefficients[i, j] * power[j])
);

constraint forall(i in 1..N) (
  abs_error[i] = abs(illumination[i] - DesiredIlluminations[i])
);

constraint total_abs_error = sum(i in 1..N) (abs_error[i]);

solve minimize total_abs_error;