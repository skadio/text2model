int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

array[1..M] of var float: power;

array[1..N] of var float: illumination =
  [ sum(j in 1..M)(Coefficients[i,j] * power[j]) | i in 1..N ];

array[1..N] of var float: abs_error;
constraint forall(i in 1..N)(
  abs_error[i] = abs(illumination[i] - DesiredIlluminations[i])
);

var float: total_abs_error = sum(i in 1..N)(abs_error[i]);

solve minimize total_abs_error;

output [
  "power = ", show(power), "\n",
  "illumination = ", show(illumination), "\n",
  "abs_error = ", show(abs_error), "\n",
  "total_abs_error = ", show(total_abs_error), "\n"
];