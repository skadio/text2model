% Parameters (with values embedded)
int: D = 7;
set of int: Days = 1..D;
% 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
array[Days] of int: req = [17, 13, 15, 19, 14, 16, 11];

% Variables
% x[s] = number of employees whose 5-day work stretch starts on day s
array[Days] of var 0..100: x;

% Constraints
% Coverage: on each day d, workers are those who started on d, d-1, d-2, d-3, d-4 (mod 7)
constraint
  forall(d in Days) (
    sum(k in 0..4) ( x[ ((d - 1 - k + D) mod D) + 1 ] ) >= req[d]
  );

% Objective
solve minimize sum(s in Days)(x[s]);

output [
  "Minimum full-time employees = ", show(sum(s in Days)(x[s])), "\n",
  "Start on Mon..Sun = ", show([x[s] | s in Days]), "\n"
];