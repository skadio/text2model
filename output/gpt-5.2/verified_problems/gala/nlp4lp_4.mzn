include "globals.mzn";

% INPUT DATA
int: Period;                 % number of weeks in the planning horizon
array[1..7] of int: Demand;  % demand for each weekday (1..7), repeated each week

int: H = 7 * Period;         % total days in horizon

% Upper bound: in worst case hire enough nurses to cover max daily demand
int: Nmax = max(Demand);

% DECISION VARIABLES
var 0..Nmax: N;                          % number of nurses hired (minimize)
var 1..6: x;                             % consecutive work days (then 7-x off days)
array[1..Nmax] of var 1..7: start;       % start day-of-week (1..7) for each nurse's cycle (week is circular)
array[1..Nmax] of var 0..1: hired;       % whether nurse i is used
array[1..Nmax, 1..H] of var 0..1: works; % whether nurse i works on day d in horizon

% LINKING / STRUCTURE
constraint N = sum(i in 1..Nmax)(hired[i]);

% Symmetry breaking: use first N nurses
constraint forall(i in 1..Nmax-1)(hired[i] >= hired[i+1]);

% Define works pattern: if hired, nurse works x consecutive days starting at 'start' in each 7-day cycle
constraint
  forall(i in 1..Nmax, d in 1..H) (
    let {
      int: dow = ((d - 1) mod 7) + 1,                           % day-of-week of day d
      var 0..6: dist = (dow - start[i] + 7) mod 7               % distance from start in 0..6
    } in
      works[i,d] = hired[i] * bool2int(dist < x)
  );

% DEMAND COVERAGE EACH DAY
constraint
  forall(d in 1..H) (
    sum(i in 1..Nmax)(works[i,d]) >= Demand[((d - 1) mod 7) + 1]
  );

% OBJECTIVE
solve minimize N;

% OUTPUT
output [
  "Period = ", show(Period), "\n",
  "x (work days in a row) = ", show(x), "\n",
  "N (nurses hired) = ", show(N), "\n",
  "start days (for hired nurses, 1..7) = ",
  show([ start[i] | i in 1..Nmax where fix(hired[i]) = 1 ]), "\n"
];