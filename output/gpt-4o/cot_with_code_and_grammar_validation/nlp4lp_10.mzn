int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

array[1..M] of var 0.0..1.0e3: LampPowers;
array[1..N] of var 0.0..1.0e6: Illuminations;
array[1..N] of var 0.0..1.0e6: AbsError;

constraint
  forall(i in 1..N) (
    Illuminations[i] = sum(j in 1..M) (
      Coefficients[i, j] * LampPowers[j]
    )
  );

constraint
  forall(i in 1..N) (
    AbsError[i] >= Illuminations[i] - DesiredIlluminations[i] /\
    AbsError[i] >= DesiredIlluminations[i] - Illuminations[i]
  );

solve minimize
  sum(i in 1..N) (AbsError[i]);