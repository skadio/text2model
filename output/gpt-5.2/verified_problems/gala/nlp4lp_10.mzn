include "globals.mzn";

% -------------------- Data --------------------
int: N;  % number of segments / illuminations
int: M;  % number of lamps

array[1..N, 1..M] of float: Coefficients;
array[1..N] of float: DesiredIlluminations;

% -------------------- Variables --------------------
% Lamp powers (nonnegative). Provide tighter bounds in .dzn if desired.
array[1..M] of var float: Power;

% Resulting illumination per segment
array[1..N] of var float: Illumination;

% Absolute error per segment
array[1..N] of var float: AbsError;

% -------------------- Constraints --------------------
constraint forall(i in 1..N) (
  Illumination[i] = sum(j in 1..M)(Coefficients[i,j] * Power[j])
);

constraint forall(i in 1..N) (
  AbsError[i] = abs(Illumination[i] - DesiredIlluminations[i])
);

% Optional: enforce nonnegative powers
constraint forall(j in 1..M) (Power[j] >= 0.0);

% -------------------- Objective --------------------
solve minimize sum(i in 1..N)(AbsError[i]);

% -------------------- Output --------------------
output [
  "Power = ", show(Power), "\n",
  "Illumination = ", show(Illumination), "\n",
  "AbsError = ", show(AbsError), "\n",
  "TotalAbsError = ", show(sum(i in 1..N)(AbsError[i])), "\n"
];