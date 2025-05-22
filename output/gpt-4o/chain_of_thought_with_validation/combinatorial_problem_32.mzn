% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of int: participation;

% Sets
set of int: DAYS   = 1..num_days;
set of int: PEOPLE = 1..num_people;

% Derived data
array[DAYS] of int: participants_per_day =
  [ sum(p in PEOPLE)( participation[p,d] ) | d in DAYS ];

% Guarantee that every considered day has at least one participant
constraint forall(d in DAYS)( participants_per_day[d] > 0 );

array[PEOPLE] of float: obligation =
  [ sum(d in DAYS)(
        if participation[p,d] == 1 then
            1.0 / float(participants_per_day[d])
        else
            0.0
        endif
    )
  | p in PEOPLE ];

% Decision variables
array[DAYS]   of var PEOPLE: driver;           % driver chosen for each day
array[PEOPLE] of var 0..num_days: drive_count; % how many times each person drives
array[PEOPLE] of var float: deviation;         % signed deviation from obligation
array[PEOPLE] of var float: abs_deviation;     % absolute deviation

% Constraints
constraint forall(d in DAYS)(
    participation[driver[d], d] == 1           % only a participant can be the driver
);

constraint forall(p in PEOPLE)(
    drive_count[p] = sum(d in DAYS)( bool2int(driver[d] == p) )
);

constraint forall(p in PEOPLE)(
    deviation[p] = float(drive_count[p]) - obligation[p]
);

constraint forall(p in PEOPLE)(
    abs_deviation[p] = abs(deviation[p])
);

% Objective
solve minimize sum(p in PEOPLE)( abs_deviation[p] );