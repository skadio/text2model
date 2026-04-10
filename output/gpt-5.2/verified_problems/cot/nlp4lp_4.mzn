% Parameters
int: Period;
array[1..7] of int: Demand;

set of int: DAYS = 1..7;

% Variables
array[DAYS] of var 0..sum(Demand): Start;   % nurses whose work-block starts on day d
array[DAYS] of var 0..sum(Demand): OnDuty;  % nurses working on day d
var 0..sum(Demand): N;                      % total nurses hired

% Constraints
constraint N = sum(d in DAYS)(Start[d]);

% Cyclic coverage: if a nurse starts on day s, they work Period consecutive days (mod 7)
constraint
  forall(d in DAYS)(
    OnDuty[d] =
      sum(s in DAYS)(
        Start[s] * bool2int( ((d - s + 7) mod 7) < Period )
      )
  );

% Meet demand each day
constraint forall(d in DAYS)(OnDuty[d] >= Demand[d]);

% Objective
solve minimize N;