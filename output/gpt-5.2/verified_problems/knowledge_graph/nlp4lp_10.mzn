int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

array[1..M] of var float: LampPowers;

array[1..N] of var float: Illumination =
  [ sum(j in 1..M)(Coefficients[i,j] * LampPowers[j]) | i in 1..N ];

array[1..N] of var float: AbsError =
  [ abs(Illumination[i] - DesiredIlluminations[i]) | i in 1..N ];

var float: TotalAbsError = sum(i in 1..N)(AbsError[i]);

solve minimize TotalAbsError;

output [
  "LampPowers = ", show(LampPowers), "\n",
  "Illumination = ", show(Illumination), "\n",
  "AbsError = ", show(AbsError), "\n",
  "TotalAbsError = ", show(TotalAbsError), "\n"
];