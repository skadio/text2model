% Parameters
int: num_days; % Number of days in the carpooling schedule
int: num_people; % Number of people participating in the carpool
array[1..num_people, 1..num_days] of 0..1: participation; % Array representing the participation of each person on each day of the carpool

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving; % Array representing the driving responsibilities of each person on each day of the carpool

% Constraints

% Each person can only drive on the days they participate
constraint forall(i in 1..num_people, j in 1..num_days) (
    driving[i,j] <= participation[i,j]
);

% On each day, exactly one person drives
constraint forall(j in 1..num_days) (
    sum(i in 1..num_people) (driving[i,j]) = 1
);

% The total driving days for each person should be as close as possible to their obligation
% The obligation of a person on a day is 1 divided by the number of participants on that day
constraint forall(i in 1..num_people) (
    abs(sum(j in 1..num_days) (driving[i,j]) - sum(j in 1..num_days) (participation[i,j] / sum(k in 1..num_people) (participation[k,j]))) <= 1
);

% Objective
solve minimize sum(i in 1..num_people) (
    abs(sum(j in 1..num_days) (driving[i,j]) - sum(j in 1..num_days) (participation[i,j] / sum(k in 1..num_people) (participation[k,j])))
);