% Parameters
% Days of week indexed 1..7 (1=Mon, 2=Tue, ..., 7=Sun)
int: nDays = 7;
set of int: DAYS = 1..nDays;

% Daily staffing requirements (Mon..Sun): 17,13,15,19,14,16,11
array[DAYS] of int: req = [17, 13, 15, 19, 14, 16, 11];

% Length of work stretch and days off (fixed by union rules)
int: workDays = 5;
int: offDays  = 2;

% Possible start days for a 5-consecutive-days schedule (start on any day)
set of int: START = DAYS;

% Maximum useful bound on number starting any given day (cannot exceed total needed)
int: UB = sum(d in DAYS)(req[d]);

% Variables
% x[s] = number of employees whose 5-day work period starts on day s
array[START] of var 0..UB: x;

% total number of employees hired
var 0..UB: totalEmployees;

% Constraints
% Link objective variable
constraint totalEmployees = sum(s in START)(x[s]);

% Coverage constraints: each day's requirement must be met by employees whose
% 5-day work stretch includes that day (cyclic over the 7-day week).
constraint
  forall(d in DAYS) (
    sum(s in START where ((d - s + nDays) mod nDays) < workDays)(x[s]) >= req[d]
  );

% Objective
solve minimize totalEmployees;