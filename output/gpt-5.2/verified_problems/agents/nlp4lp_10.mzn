% Parameters
int: N; % Number of road segments / illumination points
int: M; % Number of lamps

array[1..N, 1..M] of float: Coefficients; % coeff_{i,j} linking lamp j power to segment i illumination
array[1..N] of float: DesiredIlluminations; % Desired illumination for each segment

% Variables
array[1..M] of var float: Power; % Power level chosen for each lamp

array[1..N] of var float: Illumination; % Resulting illumination in each segment
array[1..N] of var float: AbsError; % Absolute error |Illumination[i] - DesiredIlluminations[i]|

% Constraints
% --- Illumination computation: linear combination of lamp powers for each segment ---
constraint
  forall(i in 1..N) (
    Illumination[i] =
      sum(j in 1..M) (Coefficients[i, j] * Power[j])
  );

% --- Absolute error definition for each segment ---
constraint
  forall(i in 1..N) (
    AbsError[i] = abs(Illumination[i] - DesiredIlluminations[i])
  );

% Objective
solve minimize sum(i in 1..N)(AbsError[i]);