% Parameters
int: N;
int: M;
array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

% Variables
array[1..M] of var float: power;            % non-negative lamp powers
array[1..N] of var float: illumination;     % resulting illuminations
array[1..N] of var float: error;            % absolute deviations

% Basic domain constraints
constraint forall(j in 1..M)(power[j] >= 0.0);
constraint forall(i in 1..N)(error[i]  >= 0.0);

% Illumination computation
constraint
  forall(i in 1..N)(
    illumination[i] = sum(j in 1..M)(Coefficients[i,j] * power[j])
  );

% Absolute error definition
constraint
  forall(i in 1..N)(
    error[i] = abs(illumination[i] - DesiredIlluminations[i])
  );

% Objective
solve minimize sum(i in 1..N)(error[i]);