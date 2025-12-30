include "globals.mzn";

% Parameters (provided via the data file)
int: N;                        % Number of days in the recurring period
array[1..N] of int: Num;       % Required number of employees on each day
int: WorkingDays;              % Number of consecutive working days
int: RestingDays;              % Number of consecutive resting days

% Derived parameter: cycle length of each employee's schedule
int: T = WorkingDays + RestingDays;

% We set an upper bound on the number of employees.
% A safe upper bound is the total demand over all days.
int: E_max = sum(Num);

% Decision variables:
% employed[e] = 1 if employee e (with e in 1..E_max) is hired, 0 otherwise.
array[1..E_max] of var 0..1: employed;

% For each potential employee, we choose a starting offset in the cycle.
% The schedule for employee e is then: 
%   working on day d  if ((d-1 - start[e]) mod T) < WorkingDays, 
%   and resting otherwise.
array[1..E_max] of var 0..T-1: start;

% For each day in the period, the total number of employees working (i.e., on duty)
% must be at least the required number Num[d].
%
% Notice that an employee contributes 1 on day d if he is hired (employed[e]=1)
% and his schedule (determined by start[e]) indicates a work day.
constraint
  forall(d in 1..N) (
    sum(e in 1..E_max)(
      employed[e] * ( if ((d - 1 - start[e]) mod T < WorkingDays) then 1 else 0 endif )
    ) >= Num[d]
  );

% Objective: minimize the total number of employees hired.
var int: totalEmployees = sum(e in 1..E_max)(employed[e]);
solve minimize totalEmployees;

% Output the minimum number of employees needed and the starting shift offsets 
% for those employees that are hired.
output [
  "Minimum number of employees = ", show(totalEmployees), "\n",
  "Hired employees' start offsets = ", show([ start[e] | e in 1..E_max where employed[e] = 1 ]), "\n"
];