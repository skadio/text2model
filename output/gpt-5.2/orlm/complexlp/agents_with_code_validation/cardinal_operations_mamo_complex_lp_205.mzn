% Parameters
% Days of week indexed 1..7 (Mon..Sun)
int: nDays = 7;
set of int: DAYS = 1..nDays;

% Demand (required full-time employees) for each day (Mon..Sun)
array[DAYS] of int: req = [17, 13, 15, 19, 14, 16, 11];

% Work pattern parameters: 5 consecutive workdays, then 2 days off
int: workLen = 5;
int: offLen  = 2; % not directly used (implied by 7-day cycle and workLen=5)

% Variables
% start[d] = number of employees whose 5-day work block starts on day d
% (they work days d, d+1, ..., d+4 modulo 7)
array[DAYS] of var 0..sum(req): start;

% total number of employees hired
var 0..sum(req): totalEmployees;

% Constraints
% --- Link totalEmployees to the number of employees starting on each day ---
constraint
  totalEmployees = sum(d in DAYS)(start[d]);

% --- Coverage constraints: daily staffing must meet or exceed requirements ---
% An employee starting on day s works day d iff (d-s mod 7) is in {0,1,2,3,4}.
constraint
  forall(d in DAYS)(
    sum(s in DAYS)(
      start[s] * bool2int(((d - s + nDays) mod nDays) < workLen)
    ) >= req[d]
  );

% Objective
solve minimize totalEmployees;