% Parameters
int: num_days; % Number of days in the carpooling schedule
int: num_people; % Number of people participating in the carpool
array[1..num_people, 1..num_days] of 0..1: participation; % Participation of each person on each day

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving; % Driving responsibilities of each person on each day

% Constraints
constraint forall(i in 1..num_people, j in 1..num_days) (
    if participation[i,j] = 1 then
        sum(k in 1..num_people) (participation[k,j] * driving[i,j]) = 1
    else
        driving[i,j] = 0
    endif
);

% Objective
var float: max_diff;
constraint max_diff = max(i in 1..num_people) (
    abs(sum(j in 1..num_days) (driving[i,j]) - sum(j in 1..num_days) (participation[i,j] / sum(k in 1..num_people) (participation[k,j])))
);
solve minimize max_diff;

% Output
output [ "Person " ++ show(i) ++ " drives on day " ++ show(j) ++ "\n" | i in 1..num_people, j in 1..num_days where driving[i,j] = 1 ];