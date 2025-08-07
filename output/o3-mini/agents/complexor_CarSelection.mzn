include "globals.mzn";
include "alldifferent_except_0.mzn";

% Data declarations (provided via the .dzn file)
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;

% Decision Variables: For each participant, assign a car (1..CarNum) or 0 if no car is assigned.
array[1..ParticipantNum] of var 0..CarNum: car_assignment;

% Constraint 1: If a participant is assigned to a car j (> 0), then that participant must be interested in it.
constraint
  forall(i in 1..ParticipantNum) (
    car_assignment[i] = 0 \/ (car_assignment[i] > 0 /\ InterestMatrix[i, car_assignment[i]] = 1)
  );

% Constraint 2: Each car can be assigned to at most one participant.
% This is enforced by applying the alldifferent_except_0 constraint.
constraint alldifferent_except_0(car_assignment);

% Objective: Maximize the total number of assignments (participants assigned a non-zero car).
var 0..ParticipantNum: total_assigned = sum(i in 1..ParticipantNum)( bool2int(car_assignment[i] > 0) );

solve maximize total_assigned;

output [
  "Car Assignment: ", show(car_assignment), "\n",
  "Total Participants Assigned: ", show(total_assigned)
];