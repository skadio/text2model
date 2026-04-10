% Parameters
int: n;  % Number of days in the recurring period

set of int: DAYS = 0..n-1;  % Day indices used by the input data

array[DAYS] of int: demand;  % Required number of employees per day

int: full_time_pay;   % Pay per day for a full-time worker
int: part_time_pay;   % Pay per day for a part-time worker

int: full_time_shift; % Consecutive working days for a full-time worker
int: part_time_shift; % Consecutive working days for a part-time worker


% Variables
array[DAYS] of var int: start_full_time;  % # full-time workers whose shift starts on day d
array[DAYS] of var int: start_part_time;  % # part-time workers whose shift starts on day d

array[DAYS] of var int: full_time_on;     % # full-time workers working on day d
array[DAYS] of var int: part_time_on;     % # part-time workers working on day d

var int: total_cost;  % Total staffing cost over the recurring period

% Bounds (kept separate to avoid type issues)
constraint forall(d in DAYS) (
  start_full_time[d] >= 0 /\ start_part_time[d] >= 0
);

constraint forall(d in DAYS) (
  full_time_on[d] >= 0 /\ part_time_on[d] >= 0
);

constraint total_cost >= 0;


% Constraints

% Link "on duty" counts to shift starts (cyclic over the recurring period)
% A worker who starts on day s works on days s, s+1, ..., s+shift-1 (mod n).
constraint
  forall(d in DAYS) (
    full_time_on[d] =
      sum(s in DAYS) (
        start_full_time[s] *
        bool2int( ((d - s + n) mod n) < full_time_shift )
      )
  );

constraint
  forall(d in DAYS) (
    part_time_on[d] =
      sum(s in DAYS) (
        start_part_time[s] *
        bool2int( ((d - s + n) mod n) < part_time_shift )
      )
  );

% Meet daily staffing demand (full-time + part-time must cover requirement)
constraint
  forall(d in DAYS) (
    full_time_on[d] + part_time_on[d] >= demand[d]
  );

% Total cost over the period:
% Each start corresponds to one worker working exactly (shift length) paid days in the period.
constraint
  total_cost =
    full_time_pay * full_time_shift * sum(d in DAYS)(start_full_time[d]) +
    part_time_pay * part_time_shift * sum(d in DAYS)(start_part_time[d]);


% Objective
solve minimize total_cost;