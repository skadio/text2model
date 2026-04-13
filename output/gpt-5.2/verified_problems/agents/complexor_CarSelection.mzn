% Parameters
int: ParticipantNum; % total number of participants (provided in .dzn)
int: CarNum;         % total number of cars (provided in .dzn)

array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;
% binary interest indicator: InterestMatrix[p,c] = 1 if participant p is interested in car c, else 0

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: Assign;
% Assign[p,c] = 1 if participant p is assigned to car c, else 0

array[1..ParticipantNum] of var 0..1: IsAssigned;
% IsAssigned[p] = 1 if participant p gets some car, else 0

var 0..ParticipantNum: TotalAssignments;
% total number of participants assigned (objective-related)

% Constraints

% Feasibility: only assign a participant to a car they are interested in
constraint
  forall(p in 1..ParticipantNum, c in 1..CarNum) (
    Assign[p,c] <= InterestMatrix[p,c]
  );

% Each participant can be assigned to at most one car
constraint
  forall(p in 1..ParticipantNum) (
    sum(c in 1..CarNum)(Assign[p,c]) <= 1
  );

% Link IsAssigned[p] with whether participant p is assigned some car
% Since Assign is 0/1 and at most one car can be chosen, this sum is in 0..1.
constraint
  forall(p in 1..ParticipantNum) (
    IsAssigned[p] = sum(c in 1..CarNum)(Assign[p,c])
  );

% Define total number of assigned participants
constraint
  TotalAssignments = sum(p in 1..ParticipantNum)(IsAssigned[p]);

% Objective
solve maximize TotalAssignments;