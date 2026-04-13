% Night shift staffing with 5-consecutive-day work blocks (cyclic over 7 days)
% Continuous (fractional) nurses allowed; minimize total nurses used.
% Demand is embedded directly; output the optimum rounded to nearest integer.

int: days = 7;
int: L = 5; % consecutive working days per nurse

array[1..days] of float: d = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

% x[s] = number of nurses whose 5-day block starts on day s
array[1..days] of var float: x;
constraint forall(s in 1..days)(x[s] >= 0.0);

% Coverage: a nurse starting at s covers days s, s+1, ..., s+L-1 (mod 7)
constraint
  forall(j in 1..days)(
    sum(s in 1..days where ((j - s + days) mod days) < L)( x[s] ) >= d[j]
  );

var float: total = sum(s in 1..days)(x[s]);

solve minimize total;

output [
  "Start-day nurses (fractional allowed) x = ", show(x), "\n",
  "Total nurses (fractional optimum) = ", show(total), "\n",
  "Total nurses rounded = ", show(round(total)), "\n"
];