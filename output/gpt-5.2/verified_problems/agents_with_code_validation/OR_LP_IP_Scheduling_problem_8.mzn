% Parameters
int: n;  % Number of days in the recurring period

set of int: DAYS = 0..n-1;  % Day indices (matches demand indexing in .dzn)

array[DAYS] of int: demand;  % Required employees per day

int: full_time_pay;    % Pay per day for a full-time worker
int: part_time_pay;    % Pay per day for a part-time worker

int: full_time_shift;  % Consecutive working days in a full-time shift
int: part_time_shift;  % Consecutive working days in a part-time shift


% Variables
array[DAYS] of var int: start_full_time;    % # full-time workers whose shift starts on day d
array[DAYS] of var int: start_part_time;    % # part-time workers whose shift starts on day d

array[DAYS] of var int: full_time_working;  % # full-time workers working on day d
array[DAYS] of var int: part_time_working;  % # part-time workers working on day d

var int: total_cost;  % Total staffing cost over the period


% Constraints

%----------------------------
% Non-negativity / integrality domain restrictions
%----------------------------
constraint forall(d in DAYS) (start_full_time[d] >= 0);
constraint forall(d in DAYS) (start_part_time[d] >= 0);
constraint forall(d in DAYS) (full_time_working[d] >= 0);
constraint forall(d in DAYS) (part_time_working[d] >= 0);

%----------------------------
% Link "starts" to "working" counts via cyclic (wrap-around) shifts
% A worker starting on day s works on days s, s+1, ..., s+shift-1 (mod n)
%----------------------------

% Full-time working computation
constraint
  forall(d in DAYS) (
    full_time_working[d] =
      sum(s in DAYS where ((d - s + n) mod n) < full_time_shift) (start_full_time[s])
  );

% Part-time working computation
constraint
  forall(d in DAYS) (
    part_time_working[d] =
      sum(s in DAYS where ((d - s + n) mod n) < part_time_shift) (start_part_time[s])
  );

%----------------------------
% Demand coverage constraints
% Ensure enough total workers (full-time + part-time) each day
%----------------------------
constraint
  forall(d in DAYS) (
    full_time_working[d] + part_time_working[d] >= demand[d]
  );

%----------------------------
% Total cost definition (cost per day * number working each day)
%----------------------------
constraint
  total_cost =
    sum(d in DAYS) (
      full_time_pay * full_time_working[d] +
      part_time_pay * part_time_working[d]
    );


% Objective
solve minimize total_cost;