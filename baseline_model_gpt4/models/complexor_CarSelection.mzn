% Input parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix;

% Decision variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: AssignMatrix;

% Each participant can only be assigned to one car
constraint forall(i in 1..ParticipantNum) (
  sum(j in 1..CarNum) (AssignMatrix[i,j]) <= 1
);

% A participant can only be assigned to a car they are interested in
constraint forall(i in 1..ParticipantNum, j in 1..CarNum) (
  AssignMatrix[i,j] <= InterestMatrix[i,j]
);

% Objective function: maximize the number of participants who get cars they are interested in
solve maximize sum(i in 1..ParticipantNum, j in 1..CarNum) (AssignMatrix[i,j]);

% Output
output [ "AssignMatrix = ", show(AssignMatrix) ];