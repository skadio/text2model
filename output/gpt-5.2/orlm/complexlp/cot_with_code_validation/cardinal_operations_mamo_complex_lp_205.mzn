% Parameters
int: D = 7;
set of int: DAYS = 1..D; % 1=Mon,2=Tue,3=Wed,4=Thu,5=Fri,6=Sat,7=Sun

array[DAYS] of int: req = [17, 13, 15, 19, 14, 16, 11];

% Variables
% x[d] = number of employees whose 5-day work block starts on day d
array[DAYS] of var 0..sum(req): x;

var 0..sum(req): total;

% Constraints
constraint total = sum(d in DAYS)(x[d]);

% Coverage: employees starting on s work on days s, s+1, s+2, s+3, s+4 (mod 7)
constraint
  forall(d in DAYS)(
    sum(k in 0..4)(
      x[ ((d - k - 1 + D) mod D) + 1 ]
    ) >= req[d]
  );

% Objective
solve minimize total;