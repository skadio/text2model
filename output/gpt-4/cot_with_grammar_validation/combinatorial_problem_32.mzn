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
        total_driving_days[i] = sum(k in 1..num_days) (driving[i,k])
    else
        total_driving_days[i] = 0
    endif
);

constraint forall(i in 1..num_people, j in 1..num_days) (
    if participation[i,j] = 1 then
        obligation[i] = sum(k in 1..num_days) (participation[i,k]) div num_people
    else
        obligation[i] = 0
    endif
);

constraint forall(i in 1..num_people, j in 1..num_days) (
    driving[i,j] <= participation[i,j]
);

% Objective
var int: diff;
diff = sum(i in 1..num_people) (abs(total_driving_days[i] - obligation[i]));
solve minimize diff;