% Parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix;

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: AssignmentMatrix;

% Constraints
% Each participant can only be assigned to one car
constraint forall(i in 1..ParticipantNum) (
  sum(j in 1..CarNum) (AssignmentMatrix[i,j]) <= 1
);

% A participant can only be assigned to a car they are interested in
constraint forall(i in 1..ParticipantNum, j in 1..CarNum) (
  AssignmentMatrix[i,j] <= InterestMatrix[i,j]
);

% Objective
% Maximize the number of participants who get cars they are interested in
solve maximize sum(i in 1..ParticipantNum, j in 1..CarNum) (AssignmentMatrix[i,j]);