% Parameters
int: N;
int: M;
array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

% Variables
array[1..M] of var 0.0..1.0e6: Power;                 % lamp powers (non-negative, bounded)
array[1..N] of var 0.0..1.0e9: Illumination;          % resulting illuminations (bounded, non-negative)
array[1..N] of var 0.0..1.0e9: Error;                 % absolute deviations

% Constraints
constraint
  forall(i in 1..N) (
    Illumination[i] = sum(j in 1..M) (Coefficients[i,j] * Power[j])
  );

constraint
  forall(i in 1..N) (
        Error[i] >= Illumination[i] - DesiredIlluminations[i] /\
        Error[i] >= DesiredIlluminations[i] - Illumination[i]
  );

% Objective
solve minimize sum(i in 1..N)(Error[i]);