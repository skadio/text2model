% Parameters
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix;

% Variables
array[1..ParticipantNum, 1..CarNum] of var 0..1: Assign;

% Constraints
constraint
  forall(p in 1..ParticipantNum)(
    sum(c in 1..CarNum)(Assign[p,c]) <= 1
  );

constraint
  forall(c in 1..CarNum)(
    sum(p in 1..ParticipantNum)(Assign[p,c]) <= 1
  );

constraint
  forall(p in 1..ParticipantNum, c in 1..CarNum)(
    Assign[p,c] <= InterestMatrix[p,c]
  );

% Objective
solve maximize sum(p in 1..ParticipantNum, c in 1..CarNum)(Assign[p,c]);