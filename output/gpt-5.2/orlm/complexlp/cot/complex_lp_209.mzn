% Parameters (with values embedded)
int: n = 5;
set of int: I = 1..n;

array[I] of float: out0 = [11.0, 53.0, 5.0, 5.0, 29.0];   % time 0 cash outflows (million $)
array[I] of float: out1 = [3.0,  6.0, 5.0, 1.0, 34.0];    % time 1 cash outflows (million $)
array[I] of float: npv  = [13.0, 16.0, 16.0, 14.0, 39.0]; % NPV (million $)

float: budget0 = 40.0;  % available at time 0 (million $)
float: budget1 = 20.0;  % available at time 1 (million $)

% Variables
array[I] of var float: x;  % fraction of each investment purchased (0..1)

% Constraints
constraint forall(i in I) (0.0 <= x[i] /\ x[i] <= 1.0);

constraint sum(i in I) (out0[i] * x[i]) <= budget0;
constraint sum(i in I) (out1[i] * x[i]) <= budget1;

% Objective
solve maximize sum(i in I) (npv[i] * x[i]);