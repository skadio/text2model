% Parameters (with values embedded)
int: Days = 7;
set of int: D = 1..Days;

array[D] of float: demand = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

% Every nurse works 5 consecutive days; start day i means working days i..i+4 (mod 7)
int: L = 5;
set of int: StartDays = D;

% Helper: 1 if a nurse starting on start day s works on day j, else 0
function int: works(int: s, int: j) =
  if (((j - s) mod Days + Days) mod Days) < L then 1 else 0 endif;

% Variables
% x[s] = number of nurses that start a 5-day block on day s (continuous, >= 0)
array[StartDays] of var float: x;

% total nurses used (can be fractional in the model)
var float: total_nurses = sum(s in StartDays)(x[s]);

% Constraints
constraint forall(s in StartDays)(x[s] >= 0.0);

% Cover demand each day
constraint
  forall(j in D)(
    sum(s in StartDays)( int2float(works(s,j)) * x[s] ) >= demand[j]
  );

% Objective
solve minimize total_nurses;

% Rounded-to-nearest-integer answer (as requested)
output [
  "Total nurses (fractional optimum) = ", show(total_nurses), "\n",
  "Total nurses (rounded) = ", show( round(total_nurses) ), "\n"
];