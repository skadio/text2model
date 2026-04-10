include "globals.mzn";

% =======================
% Input data (from .dzn)
% =======================
int: N;                          % number of days in the recurring period
array[1..N] of int: Num;         % required employees on each day
int: WorkingDays;                % consecutive working days
int: RestingDays;                % consecutive resting days

% =======================
% Derived constants
% =======================
int: L = WorkingDays + RestingDays;  % cycle length for an employee

constraint N > 0 /\ WorkingDays >= 0 /\ RestingDays >= 0 /\ L > 0;
constraint forall(d in 1..N)(Num[d] >= 0);

% =======================
% Decision variables
% =======================
% x[s] = number of employees whose cycle starts (day 1 of work-block) on day s (mod N)
var 0..sum(Num): E;                % total employees to hire
array[1..N] of var 0..sum(Num): x;

% Total employees is the sum of starts over the period
constraint E = sum(s in 1..N)(x[s]);

% =======================
% Coverage constraints (recurring schedule over N days)
% =======================
% An employee starting at s works on days:
%   s, s+1, ..., s+WorkingDays-1 (mod N)
% For each day d, sum of all starts whose work window covers d must meet demand Num[d].
constraint
  forall(d in 1..N)(
    sum(s in 1..N)(
      x[s] * bool2int( ((d - s + N) mod N) < WorkingDays )
    ) >= Num[d]
  );

% =======================
% Objective
% =======================
solve minimize E;

% =======================
% Output
% =======================
output [
  "MinEmployees = ", show(E), "\n",
  "StartsPerDay = ", show(x), "\n"
];