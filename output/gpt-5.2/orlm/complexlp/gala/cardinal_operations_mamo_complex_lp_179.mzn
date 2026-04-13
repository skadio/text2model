% Night-shift staffing with 5-consecutive-day work blocks (cyclic over 7 days)
% Continuous relaxation: allow fractional nurses.
% Objective: minimize total nurses while meeting daily demand.

include "globals.mzn";

int: Days = 7;
int: L = 5; % consecutive working days per nurse

array[1..Days] of float: d = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];

% x[s] = number of nurses whose 5-day block starts on day s (fractional allowed)
array[1..Days] of var 0.0..1000.0: x;

% Coverage on each day j is sum of starts s whose 5-day block includes day j (cyclic)
constraint
  forall(j in 1..Days)(
    sum(s in 1..Days)(
      x[s] * bool2int( ((j - s + Days) mod Days) < L )
    ) >= d[j]
  );

var 0.0..10000.0: total = sum(s in 1..Days)(x[s]);

solve minimize total;

% Rounded answer to nearest integer (half-up)
output [
  "x(startDay)= ", show(x), "\n",
  "Total nurses (continuous) = ", show(total), "\n",
  "Rounded total = ", show(round(total)), "\n"
];