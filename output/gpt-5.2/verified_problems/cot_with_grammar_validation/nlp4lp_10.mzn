int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

array[1..M] of var float: Power;
array[1..N] of var float: Illumination;
array[1..N] of var float: AbsError;

var float: TotalAbsError;

constraint forall(i in 1..N) (
  Illumination[i] = sum(j in 1..M) (Coefficients[i, j] * Power[j])
);

constraint forall(i in 1..N) (
  AbsError[i] >= Illumination[i] - DesiredIlluminations[i] /\
  AbsError[i] >= DesiredIlluminations[i] - Illumination[i]
);

constraint TotalAbsError = sum(i in 1..N) (AbsError[i]);

solve minimize TotalAbsError;