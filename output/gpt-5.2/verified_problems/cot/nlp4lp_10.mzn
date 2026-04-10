% Parameters
int: N;
int: M;

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

% Variables
array[1..M] of var float: Power;
array[1..N] of var float: Illumination;
array[1..N] of var float: AbsError;
var float: TotalAbsError;

% Constraints
constraint
  forall(i in 1..N) (
    Illumination[i] = sum(j in 1..M)(Coefficients[i,j] * Power[j])
  );

constraint
  forall(i in 1..N) (
    AbsError[i] = abs(Illumination[i] - DesiredIlluminations[i])
  );

constraint
  TotalAbsError = sum(i in 1..N)(AbsError[i]);

% Objective
solve minimize TotalAbsError;