include "globals.mzn";

int: num_days;  % Number of days in the carpooling schedule
int: num_people; % Number of people participating in the carpool
array[1..num_people, 1..num_days] of var 0..1: participation; % Participation matrix

/* Variables */
array[1..num_people] of var 0..num_days: driving_days;  % Number of days each person drives
array[1..num_people] of int: values = [1..num_people];  % Each person
array[1..num_people] of var 0..num_days: counts;         % Counts of driving days for each person
array[1..num_days] of var 0..num_people: num_participants; % Number of participants each day

/* Constraints */
constraint global_cardinality(driving_days, values, counts);

% Count the number of participants for each day
constraint forall(d in 1..num_days) (
    num_participants[d] = count(participation[:, d], 1)
);

/* Fairness constraint: driving days should be proportional to participation */
constraint forall(p in 1..num_people, d in 1..num_days) (
    participation[p, d] = 1 -> driving_days[p] >= (1 / num_participants[d]) * driving_days[p]
);

/* Objective: Minimize the differences between actual driving days and obligations */
var 0..num_days: total_difference;
constraint total_difference = sum(p in 1..num_people)(abs(driving_days[p] - (1 / num_participants[d]) * driving_days[p]));

/* Solve & output */
solve minimize total_difference;
output [ "Driving Days = ", show(driving_days), "\n" ];