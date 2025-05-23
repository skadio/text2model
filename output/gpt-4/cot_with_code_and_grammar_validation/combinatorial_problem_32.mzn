% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of 0..1: participation;

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving;
array[1..num_people] of var 0..num_days: total_driving_days;
array[1..num_people] of var 0..num_days: obligation;

% Constraints
constraint forall(i in 1..num_people, j in 1..num_days) (
    if participation[i,j] = 1 then
        driving[i,j] = 1 div sum(k in 1..num_people)(participation[k,j])
    else
        driving[i,j] = 0
    endif
);

constraint forall(i in 1..num_people) (
    total_driving_days[i] = sum(j in 1..num_days)(driving[i,j])
);

constraint forall(i in 1..num_people) (
    obligation[i] = sum(j in 1..num_days)(participation[i,j]) div num_days
);

% Objective
solve minimize sum(i in 1..num_people)(abs(total_driving_days[i] - obligation[i]));