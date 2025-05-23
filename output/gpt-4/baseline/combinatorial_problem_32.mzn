include "globals.mzn";

% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of 0..1: participation;

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving;
array[1..num_people] of var 0..num_days: total_driving_days;
array[1..num_people] of var 0..num_days: total_obligation;

% Constraints
constraint forall(i in 1..num_people, j in 1..num_days) (
    if participation[i,j] = 1 then
        total_obligation[i] = total_obligation[i] + 1 div sum(k in 1..num_people) (participation[k,j])
    endif
);

constraint forall(i in 1..num_people, j in 1..num_days) (
    if driving[i,j] = 1 then
        total_driving_days[i] = total_driving_days[i] + 1
    endif
);

constraint forall(j in 1..num_days) (
    sum(i in 1..num_people) (driving[i,j]) = 1
);

% Objective
var int: diff = sum(i in 1..num_people) (abs(total_driving_days[i] - total_obligation[i]));
solve minimize diff;

% Output
output [ "Person " ++ show(i) ++ " drives on day " ++ show(j) ++ "\n" | i in 1..num_people, j in 1..num_days where driving[i,j] = 1 ];