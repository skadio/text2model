% Parameters
int: ParticipantNum;
int: CarNum;

set of int: P = 1..ParticipantNum;
set of int: C = 1..CarNum;

array[P, C] of int: InterestMatrix; % expected 0/1 values

% Variables
array[P, C] of var 0..1: assign;     % assign[p,c] = 1 if participant p assigned to car c
array[P] of var 0..1: assigned;      % assigned[p] = 1 if participant p gets some car

% Constraints
constraint
  forall(p in P, c in C) (
    assign[p,c] <= InterestMatrix[p,c]
  );

constraint
  forall(p in P) (
    sum(c in C)(assign[p,c]) <= 1
  );

constraint
  forall(p in P) (
    assigned[p] = sum(c in C)(assign[p,c])
  );

% Objective
solve maximize sum(p in P)(assigned[p]);