% Parameters
% Time periods (each is 4 hours) starting at: 2, 6, 10, 14, 18, 22
int: nPeriods = 6;
set of int: PERIODS = 1..nPeriods;

% Required number of salespeople in each period (in order: 2-6, 6-10, 10-14, 14-18, 18-22, 22-2)
array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12];

% Shift start options (one per period start); each shift lasts 8 hours = 2 consecutive periods
int: shiftLengthPeriods = 2;

% Coverage matrix: cover[p,s] = 1 if a shift starting at s covers period p (with wrap-around)
array[PERIODS, PERIODS] of int: cover =
  array2d(PERIODS, PERIODS,
    [ if (p == s) \/ (p == ((s mod nPeriods) + 1)) then 1 else 0 endif
      | p in PERIODS, s in PERIODS ]);

% Variables
% x[s] = number of salespeople starting at period-start s (2:00, 6:00, ..., 22:00)
% Upper bound: cannot need more than sum(demand) starters in any single start time in an optimal solution
int: UB = sum(p in PERIODS)(demand[p]);
array[PERIODS] of var 0..UB: x;

% total number of salespeople used
var 0..(nPeriods * UB): totalStaff;

% Constraints

% Link totalStaff to the total number of started shifts (salespeople)
constraint
  totalStaff = sum(s in PERIODS)(x[s]);

% Demand coverage constraints: each period must be covered by enough staff
% A shift starting at s covers period p if cover[p,s] = 1 (two consecutive periods, with wrap-around)
constraint
  forall(p in PERIODS) (
    sum(s in PERIODS)(cover[p, s] * x[s]) >= demand[p]
  );

% Objective
solve minimize totalStaff;