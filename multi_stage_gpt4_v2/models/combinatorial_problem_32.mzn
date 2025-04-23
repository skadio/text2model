% Parameters
int: num_days; % Number of days in the carpooling schedule
int: num_people; % Number of people participating in the carpool
array[1..num_people, 1..num_days] of 0..1: participation; % Array representing the participation of each person on each day of the carpool

% Variables
array[1..num_people, 1..num_days] of var 0..1: driving; % Array representing the driving responsibilities of each person on each day of the carpool
array[1..num_people] of var float: actual_driving_days; % Array representing the actual driving days of each person
array[1..num_people] of var float: obligations; % Array representing the obligations of each person

% Constraints

% Calculate the actual driving days for each person
constraint forall(i in 1..num_people) (
    actual_driving_days[i] = sum(j in 1..num_days)(driving[i,j])
);

% Calculate the obligations for each person
constraint forall(i in 1..num_people) (
    obligations[i] = sum(j in 1..num_days)(participation[i,j] / sum(k in 1..num_people)(participation[k,j]))
);

% Ensure that the driving responsibilities are allocated only to the participants
constraint forall(i in 1..num_people, j in 1..num_days) (
    driving[i,j] <= participation[i,j]
);

% Ensure that there is exactly one driver for each day
constraint forall(j in 1..num_days) (
    sum(i in 1..num_people)(driving[i,j]) = 1
);

% Minimize the differences between the actual driving days and the obligations
constraint forall(i in 1..num_people) (
    abs(actual_driving_days[i] - obligations[i]) <= 1
);

% Objective
solve minimize sum(i in 1..num_people)(abs(actual_driving_days[i] - obligations[i]));