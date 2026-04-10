% Parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: assign;

% Constraints
constraint
  forall(p in 1..ParticipantNum, c in 1..CarNum) (
    assign[p,c] <= InterestMatrix[p,c]
  );

constraint
  forall(p in 1..ParticipantNum) (
    sum(c in 1..CarNum)(assign[p,c]) <= 1
  );

% Objective
solve maximize sum(p in 1..ParticipantNum, c in 1..CarNum)(assign[p,c]);