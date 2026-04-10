% Parameters (with values embedded)
int: N = 6;                         % number of 4-hour time periods in the 24-hour cycle
set of int: P = 1..N;

array[P] of int: req =              % required staff in each period
  [60, 70, 60, 50, 20, 30];

% Each shift lasts 8 hours = 2 consecutive 4-hour periods.
% If staff start at period i, they cover period i and the next period (cyclically).
array[P] of set of int: covers = [
  {1,6},  % period 1 is covered by starts at 1 (covers 1-2) and 6 (covers 6-1)
  {1,2},  % period 2 is covered by starts at 1 and 2
  {2,3},  % period 3 is covered by starts at 2 and 3
  {3,4},  % period 4 is covered by starts at 3 and 4
  {4,5},  % period 5 is covered by starts at 4 and 5
  {5,6}   % period 6 is covered by starts at 5 and 6
];

int: UB = sum(req);                 % safe upper bound on number starting any period

% Variables
array[P] of var 0..UB: x;           % x[i] = number of staff starting at beginning of period i

% Constraints
constraint forall(p in P) (
  sum(i in covers[p])(x[i]) >= req[p]
);

% Objective
solve minimize sum(i in P)(x[i]);