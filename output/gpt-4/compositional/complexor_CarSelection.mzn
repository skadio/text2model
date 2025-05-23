% Parameters
int: ParticipantNum; % The total number of participants
int: CarNum; % The total number of available cars
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix; % A binary matrix indicating whether a participant is interested in a particular car

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: CarAssignment; % Binary matrix indicating the assignment of participants to cars

% Constraints

% Each participant can only be assigned to one car
constraint forall(i in 1..ParticipantNum) (
  sum(j in 1..CarNum) (CarAssignment[i,j]) <= 1
);

% A participant can only be assigned to a car they are interested in
constraint forall(i in 1..ParticipantNum, j in 1..CarNum) (
  CarAssignment[i,j] <= InterestMatrix[i,j]
);

% Each car can only be assigned to one participant
constraint forall(j in 1..CarNum) (
  sum(i in 1..ParticipantNum) (CarAssignment[i,j]) <= 1
);

% Objective
solve maximize sum(i in 1..ParticipantNum, j in 1..CarNum) (CarAssignment[i,j]);