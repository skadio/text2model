% Parameters
int: ParticipantNum; % Number of participants
int: CarNum; % Number of cars
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix; % Interest matrix

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: AssignmentMatrix; % Assignment matrix

% Constraints
% Each participant can only be assigned to one car
constraint forall(i in 1..ParticipantNum) (
  sum(j in 1..CarNum) (AssignmentMatrix[i,j]) <= 1
);

% A participant can only be assigned to a car if they are interested in it
constraint forall(i in 1..ParticipantNum, j in 1..CarNum) (
  AssignmentMatrix[i,j] <= InterestMatrix[i,j]
);

% Objective
% Maximize the number of participants who get cars they are interested in
var int: TotalAssignments = sum(i in 1..ParticipantNum, j in 1..CarNum) (AssignmentMatrix[i,j]);
solve maximize TotalAssignments;

% Output
output [ "Total Assignments: ", show(TotalAssignments), "\n" ] ++
[ if fix(AssignmentMatrix[i,j]) = 1 then "Participant " ++ show(i) ++ " is assigned to Car " ++ show(j) ++ "\n" else "" endif | i in 1..ParticipantNum, j in 1..CarNum ];