% Parameters
int: num_days;                         % Number of days in the schedule
int: num_people;                       % Number of people in the carpool

array[1..num_people, 1..num_days] of int: participation;
% participation[p,d] = 1 if person p participates on day d, else 0 (provided in .dzn)


% Variables
array[1..num_people, 1..num_days] of var 0..1: drives;
% drives[p,d] = 1 if person p is assigned to drive on day d, else 0

array[1..num_people, 1..num_days] of var 0.0..1.0: obligation;
% obligation[p,d] = participation[p,d] / (#participants on day d); in [0,1]

array[1..num_people] of var 0..num_days: actual_drive_days;
% Total number of days each person actually drives

array[1..num_people] of var 0.0..int2float(num_days): total_obligation;
% Sum of daily obligations for each person across all days

array[1..num_people] of var 0.0..int2float(num_days): deviation;
% |actual_drive_days[p] - total_obligation[p]| for fairness minimization


% Constraints

% Only participants can be assigned to drive; and at most one driver per day.
constraint
  forall(p in 1..num_people, d in 1..num_days) (
    drives[p,d] <= participation[p,d]
  );

constraint
  forall(d in 1..num_days) (
    sum(p in 1..num_people)(drives[p,d]) <= 1
  );

% Exactly one driver on days with participants; none otherwise.
constraint
  forall(d in 1..num_days) (
    let {
      int: part_count = sum(p in 1..num_people)(participation[p,d])
    } in
      (part_count = 0 /\ sum(p in 1..num_people)(drives[p,d]) = 0)
      \/
      (part_count > 0 /\ sum(p in 1..num_people)(drives[p,d]) = 1)
  );

% Obligation definition (avoid division by zero when no one participates that day).
constraint
  forall(p in 1..num_people, d in 1..num_days) (
    let {
      int: part_count = sum(pp in 1..num_people)(participation[pp,d])
    } in
      (part_count = 0 /\ obligation[p,d] = 0.0)
      \/
      (part_count > 0 /\ obligation[p,d] =
            int2float(participation[p,d]) / int2float(part_count))
  );

% Aggregate actual driving days per person.
constraint
  forall(p in 1..num_people) (
    actual_drive_days[p] = sum(d in 1..num_days)(drives[p,d])
  );

% Aggregate total obligation per person.
constraint
  forall(p in 1..num_people) (
    total_obligation[p] = sum(d in 1..num_days)(obligation[p,d])
  );

% Deviation as absolute difference between actual drives and total obligation.
constraint
  forall(p in 1..num_people) (
    deviation[p] = abs(int2float(actual_drive_days[p]) - total_obligation[p])
  );


% Objective
solve minimize sum(p in 1..num_people)(deviation[p]);