include "globals.mzn";

int: ParticipantNum;                     % Total number of participants
int: CarNum;                             % Total number of available cars
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix; % Interest matrix

/* Variables */
array[1..ParticipantNum] of var 1..CarNum: assignment; % Car assigned to each participant

/* Constraints */
% Each participant can only be assigned to one car
constraint forall(i in 1..ParticipantNum)(
    assignment[i] in 1..CarNum
);

/* Ensure that a participant is assigned only to a car they are interested in */
constraint forall(i in 1..ParticipantNum)(
    InterestMatrix[i, assignment[i]] == 1
);

/* Objective: Maximize the number of participants assigned to cars they are interested in */
var 0..ParticipantNum: totalAssigned;
constraint totalAssigned = sum(i in 1..ParticipantNum)(InterestMatrix[i, assignment[i]]);

/* Solve & output */
solve maximize totalAssigned;
output [ "Total Assigned = ", show(totalAssigned), "\nAssignments = ", show(assignment), "\n" ];