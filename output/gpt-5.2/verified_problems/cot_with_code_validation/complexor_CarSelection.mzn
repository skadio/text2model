% Car Selection Problem (maximize total assignments)

% Parameters
int: ParticipantNum;
int: CarNum;

set of int: PARTICIPANTS = 1..ParticipantNum;
set of int: CARS = 1..CarNum;

array[PARTICIPANTS, CARS] of 0..1: InterestMatrix;

% Decision variables: assign[p,c] = 1 if participant p is assigned to car c
array[PARTICIPANTS, CARS] of var 0..1: assign;

% Constraints
% Only assign participants to cars they are interested in
constraint forall(p in PARTICIPANTS, c in CARS) (
  assign[p,c] <= InterestMatrix[p,c]
);

% Each participant can be assigned to at most one car
constraint forall(p in PARTICIPANTS) (
  sum(c in CARS)(assign[p,c]) <= 1
);

% Objective: maximize total number of assignments
solve maximize sum(p in PARTICIPANTS, c in CARS)(assign[p,c]);