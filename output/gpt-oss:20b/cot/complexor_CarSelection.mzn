% Parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;

% Variables
array[1..ParticipantNum, 1..CarNum] of var bool: assign;

% Constraints
constraint
  forall(p in 1..ParticipantNum) (
    sum(assign[p, 1..CarNum]) <= 1
  );

constraint
  forall(c in 1..CarNum) (
    sum(assign[1..ParticipantNum, c]) <= 1
  );

constraint
  forall(p in 1..ParticipantNum, c in 1..CarNum) (
    int: assign[p, c] <= InterestMatrix[p, c]
  );

% Objective
solve maximize sum(assign[1..ParticipantNum, 1..CarNum]);