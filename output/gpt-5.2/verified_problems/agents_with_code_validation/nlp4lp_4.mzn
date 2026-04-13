% Parameters
int: Period;                          % number of consecutive working days in the 7-day cycle
int: DAYS = 7;                        % days in a week
array[1..DAYS] of int: Demand;        % required nurses for each day (length 7)

% Variables
int: maxDemand = max(d in 1..DAYS)(Demand[d]);   % helper upper bound from input demand
int: maxStart  = maxDemand;                      % safe per-day upper bound for start-pattern counts

var 0..(DAYS * maxDemand): totalNurses;          % total number of nurses hired

array[1..DAYS] of var 0..maxStart: startCount;   % startCount[d] = nurses whose work block starts on day d

array[1..DAYS] of var 0..(DAYS * maxDemand): coverage; % coverage[d] = nurses working on day d

% Constraints
% Ensure Period is within the 7-day week so the 0..Period-1 range is well-defined
constraint Period >= 0 /\ Period <= DAYS;

% Total nurses equals sum of start-pattern counts
constraint
  totalNurses = sum(d in 1..DAYS)(startCount[d]);

% Weekly cyclic coverage computation:
% A nurse starting on day s works Period consecutive days (wrapping mod 7).
% coverage[d] sums all start days in the Period-day window ending at day d.
constraint
  forall(d in 1..DAYS) (
    coverage[d] =
      sum(k in 0..Period-1)(
        startCount[ ((d - k - 1 + DAYS) mod DAYS) + 1 ]
      )
  );

% Demand satisfaction
constraint
  forall(d in 1..DAYS) (
    coverage[d] >= Demand[d]
  );

% Objective
solve minimize totalNurses;