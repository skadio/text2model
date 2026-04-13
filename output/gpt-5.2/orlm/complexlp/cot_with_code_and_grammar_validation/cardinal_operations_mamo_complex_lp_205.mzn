% Parameters
int: D = 7;
set of int: DAYS = 1..D;

% Day index: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
array[DAYS] of int: req = [17, 13, 15, 19, 14, 16, 11];

% Variables
% x[s] = number of employees whose 5-day work stretch starts on day s
array[DAYS] of var 0..sum(req): x;
var 0..sum(req): total;

% Constraints
constraint total = sum(d in DAYS)(x[d]);

% Coverage: an employee starting on day s works on days s, s+1, s+2, s+3, s+4 (mod 7)
constraint
  forall(d in DAYS) (
    x[d] +
    x[ if d-1 >= 1 then d-1 else d-1 + D endif ] +
    x[ if d-2 >= 1 then d-2 else d-2 + D endif ] +
    x[ if d-3 >= 1 then d-3 else d-3 + D endif ] +
    x[ if d-4 >= 1 then d-4 else d-4 + D endif ]
    >= req[d]
  );

% Objective
solve minimize total;

output [
  "Minimal employees = ", show(total), "\n",
  "Start Mon..Sun = ", show([x[d] | d in DAYS]), "\n"
];