% Parameters
int: num_days;                              % Number of days in the schedule
int: num_people;                            % Number of people in the carpool

set of int: DAYS = 1..num_days;             % Day index set
set of int: PEOPLE = 1..num_people;         % People index set

array[PEOPLE, DAYS] of int: participation;  % 1 if person participates on day, else 0


% Variables
array[DAYS] of var 0..num_people: num_participants; % Number of participants each day

array[PEOPLE, DAYS] of var 0..1: drives;            % 1 if person drives on day, else 0

array[PEOPLE] of var float: actual_driving_days;    % Total days each person actually drives
array[PEOPLE] of var float: driving_obligation;     % Sum of per-day obligations over attended days

array[PEOPLE] of var float: deviation;              % actual_driving_days - driving_obligation
array[PEOPLE] of var float: abs_deviation;          % |deviation| for fairness objective


% Constraints

% --- Participation count per day ---
% Compute the number of participants each day from the participation matrix.
constraint
  forall(d in DAYS) (
    num_participants[d] = sum(p in PEOPLE)(participation[p,d])
  );

% --- Driving eligibility and uniqueness per day ---
% A person can only drive on a day they participate.
constraint
  forall(p in PEOPLE, d in DAYS) (
    drives[p,d] <= participation[p,d]
  );

% If there is at least one participant on a day, exactly one of the participants drives.
% If there are no participants, nobody drives.
constraint
  forall(d in DAYS) (
    sum(p in PEOPLE)(drives[p,d]) = bool2int(num_participants[d] > 0)
  );

% --- Actual driving days per person ---
% Total number of days each person drives (as float).
constraint
  forall(p in PEOPLE) (
    actual_driving_days[p] = int2float(sum(d in DAYS)(drives[p,d]))
  );

% --- Driving obligation per person ---
% Obligation is sum over attended days of 1/num_participants[d].
% Guard against division by zero by contributing 0 on days with no participants.
constraint
  forall(p in PEOPLE) (
    driving_obligation[p] =
      sum(d in DAYS)(
        (participation[p,d] = 1 /\ num_participants[d] > 0)
        ? (1.0 / int2float(num_participants[d]))
        : 0.0
      )
  );

% --- Deviation and absolute deviation (fairness metric) ---
constraint
  forall(p in PEOPLE) (
    deviation[p] = actual_driving_days[p] - driving_obligation[p]
  );

constraint
  forall(p in PEOPLE) (
    abs_deviation[p] = abs(deviation[p])
  );


% Objective
solve minimize sum(p in PEOPLE)(abs_deviation[p]);