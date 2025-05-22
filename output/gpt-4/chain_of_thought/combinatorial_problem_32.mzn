% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of 0..1: participation;

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving;
array[1..num_people] of var 0..num_days: total_driving_days;
array[1..num_days] of var 0..num_people: num_people_per_day;

% Constraints
constraint forall(i in 1..num_people, j in 1..num_days) (
    total_driving_days[i] = sum(k in 1..num_days) (driving[i,k])
);

constraint forall(j in 1..num_days) (
    num_people_per_day[j] = sum(i in 1..num_people) (participation[i,j])
);

constraint forall(i in 1..num_people, j in 1..num_days) (
    driving[i,j] <= participation[i,j]
);

% Objective
var int: diff = sum(i in 1..num_people, j in 1..num_days) (
    if participation[i,j] = 1 then
        abs(driving[i,j] - 1/num_people_per_day[j])
    else
        0
    endif
);
solve minimize diff;