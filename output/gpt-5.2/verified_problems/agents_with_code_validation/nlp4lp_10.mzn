% Parameters
int: N; % Number of road segments / illumination targets
int: M; % Number of lamps

array[1..N, 1..M] of float: Coefficients;         % contribution of lamp j to segment i
array[1..N] of float: DesiredIlluminations;       % desired illumination for each segment

% Use a bounded float domain to avoid Gecode "Number out of limits"
float: P_MAX = 1.0e3;

% Variables
array[1..M] of var 0.0..P_MAX: power;

array[1..N] of var float: illumination;
array[1..N] of var 0.0..(P_MAX * sum(j in 1..M)(abs(Coefficients[1,j]) + 0.0) + abs(DesiredIlluminations[1]) + 1.0e3): abs_error;

% Constraints
constraint
  forall(i in 1..N) (
    illumination[i] = sum(j in 1..M)(Coefficients[i, j] * power[j])
  );

constraint
  forall(i in 1..N) (
    abs_error[i] = abs(illumination[i] - DesiredIlluminations[i])
  );

% Objective
solve minimize sum(i in 1..N)(abs_error[i]);