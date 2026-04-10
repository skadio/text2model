% Carpool Fairness

% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of int: participation; % 0/1

set of int: PEOPLE = 1..num_people;
set of int: DAYS   = 1..num_days;

% Variables
array[PEOPLE, DAYS] of var 0..1: drive;

% Scale factor (common denominator)
int: DEN = num_people * num_days;

array[PEOPLE] of var 0..(DEN * num_days): oblig_scaled;
array[PEOPLE] of var 0..(DEN * num_days): actual_scaled;
array[PEOPLE] of var 0..(DEN * num_days): diff_scaled;
var 0..(num_people * DEN * num_days): obj;

% Constraints

% Can only drive on days you participate
constraint forall(p in PEOPLE, d in DAYS) (
  drive[p,d] <= participation[p,d]
);

% Exactly one driver per day if at least one participant, otherwise none
constraint forall(d in DAYS) (
  sum(p in PEOPLE)(drive[p,d]) =
    bool2int(sum(p in PEOPLE)(participation[p,d]) > 0)
);

% Scaled actual driving: DEN * (#days driven)
constraint forall(p in PEOPLE) (
  actual_scaled[p] = DEN * sum(d in DAYS)(drive[p,d])
);

% Scaled obligation: sum over days participated of DEN / (#participants that day)
constraint forall(p in PEOPLE) (
  oblig_scaled[p] =
    sum(d in DAYS)(
      if participation[p,d] = 1 then
        let { var int: n = sum(pp in PEOPLE)(participation[pp,d]) } in
          DEN div n
      else
        0
      endif
    )
);

% Absolute deviation in scaled units
constraint forall(p in PEOPLE) (
  diff_scaled[p] >= actual_scaled[p] - oblig_scaled[p] /\
  diff_scaled[p] >= oblig_scaled[p] - actual_scaled[p]
);

constraint obj = sum(p in PEOPLE)(diff_scaled[p]);

solve minimize obj;