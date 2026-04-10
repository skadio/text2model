% Weekly night shift staffing with 5-consecutive-day work pattern (cyclic week)
% LP relaxation: allow fractional nurses. Objective: minimize total nurses.

int: nDays = 7;
set of int: DAYS = 1..nDays;

array[DAYS] of float: d = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];

% x[s] = number (possibly fractional) of nurses whose 5-day block starts on day s
array[DAYS] of var float: x;

% Helper: whether a nurse starting on s works on day j (5 consecutive days, wrap-around)
function bool: works(int: s, int: j) =
  let { int: dist = (j - s + nDays) mod nDays } in dist >= 0 /\ dist <= 4;

% Coverage constraints
constraint
  forall(j in DAYS)(
    sum(s in DAYS)( if works(s,j) then x[s] else 0.0 endif ) >= d[j]
  );

% Nonnegativity
constraint forall(s in DAYS)( x[s] >= 0.0 );

var float: total = sum(s in DAYS)(x[s]);

solve minimize total;

% Rounded result requested
output [
  "total_nurses_LP = ", show(total), "\n",
  "total_nurses_rounded = ", show(round(total)), "\n",
  "x_start = ", show(x), "\n"
];