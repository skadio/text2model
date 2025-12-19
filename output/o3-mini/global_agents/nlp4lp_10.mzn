% Lamp power optimization for road illumination

int: N;                            % Number of illumination segments
int: M;                            % Number of lamps

array[1..N,1..M] of float: Coefficients;   % Coefficients linking lamp powers to segment illuminations
array[1..N] of float: DesiredIlluminations; % Desired illumination for each segment

% Decision Variables
% Assume lamp powers are non-negative; we choose an arbitrary upper bound.
% (This bound can be adjusted if needed.)
array[1..M] of var 0.0..1e6: power;

% For each segment, compute the illumination as the weighted sum of lamp powers.
array[1..N] of var float: illumination;
constraint
  forall(i in 1..N) (
    illumination[i] = sum(j in 1..M)(Coefficients[i,j] * power[j])
  );

% Define the absolute error for each segment.
array[1..N] of var float: error;

% Linearize absolute error: error[i] >= illumination[i] - DesiredIlluminations[i] 
% and error[i] >= DesiredIlluminations[i] - illumination[i]
constraint
  forall(i in 1..N) (
    error[i] >= illumination[i] - DesiredIlluminations[i] /\
    error[i] >= DesiredIlluminations[i] - illumination[i]
  );

% Objective: minimize the total absolute error over all segments.
solve minimize sum(i in 1..N)(error[i]);

% Output the results.
output [
  "Lamp Powers = ", show(power), "\n",
  "Illuminations = ", show(illumination), "\n",
  "Absolute Errors = ", show(error), "\n",
  "Total Absolute Error = ", show(sum(i in 1..N)(error[i])), "\n"
];