% Post office staffing with 5 consecutive workdays + 2 consecutive days off (cyclic over 7 days)
% Minimize total full-time employees.

include "globals.mzn";

int: nDays = 7;
set of int: DAYS = 1..nDays;

% 1=Mon,2=Tue,3=Wed,4=Thu,5=Fri,6=Sat,7=Sun
array[DAYS] of int: req = [17, 13, 15, 19, 14, 16, 11];

% x[d] = number of employees whose 5-day work block starts on day d
array[DAYS] of var 0..100: x;

% Coverage: an employee starting on s works on days s, s+1, s+2, s+3, s+4 (mod 7)
constraint
  forall(d in DAYS)(
    sum(s in DAYS where ((d - s + nDays) mod nDays) < 5)( x[s] ) >= req[d]
  );

var 0..1000: total = sum(d in DAYS)(x[d]);
solve minimize total;

output [
  "Minimum full-time employees = ", show(total), "\n",
  "Start Mon..Sun = ", show([x[d] | d in DAYS]), "\n"
];