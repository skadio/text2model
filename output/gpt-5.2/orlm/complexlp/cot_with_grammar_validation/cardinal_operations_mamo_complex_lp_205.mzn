% Parameters
int: D = 7;
set of int: Days = 1..D;

array[Days] of int: req = [17, 13, 15, 19, 14, 16, 11]; % Mon..Sun

% Variables
array[Days] of var 0..sum(req): start; % start[d] = employees whose 5-day work starts on day d
var 0..sum(req): total;

% Constraints
constraint total = sum(d in Days)(start[d]);

% Coverage: employees starting on day s work on days s, s+1, s+2, s+3, s+4 (mod 7)
constraint
  forall(d in Days) (
    sum(k in 0..4)(
      start[ ((d - k - 1) mod D) + 1 ]
    ) >= req[d]
  );

% Objective
solve minimize total;