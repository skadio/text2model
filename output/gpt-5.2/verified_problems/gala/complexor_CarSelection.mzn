include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix; % 1 = interested, 0 = not

%----------------------------
% Decision variables
%----------------------------
% assign[p,c] = 1 if participant p is assigned to car c, else 0
array[1..ParticipantNum, 1..CarNum] of var 0..1: assign;

%----------------------------
% Constraints
%----------------------------

% A participant can be assigned to at most one car
constraint forall(p in 1..ParticipantNum) (
  sum(c in 1..CarNum)(assign[p,c]) <= 1
);

% A car can be assigned to at most one participant (one seat per car)
constraint forall(c in 1..CarNum) (
  sum(p in 1..ParticipantNum)(assign[p,c]) <= 1
);

% Assignments only allowed if participant is interested in that car
constraint forall(p in 1..ParticipantNum, c in 1..CarNum) (
  assign[p,c] <= InterestMatrix[p,c]
);

%----------------------------
% Objective: maximize total number of assignments
%----------------------------
var 0..min(ParticipantNum, CarNum): totalAssigned =
  sum(p in 1..ParticipantNum, c in 1..CarNum)(assign[p,c]);

solve maximize totalAssigned;

%----------------------------
% Output
%----------------------------
output [
  "TotalAssigned = ", show(totalAssigned), "\n",
  "Assignments (participant -> car, 0 = unassigned):\n",
  concat([
    "p" ++ show(p) ++ " -> " ++
    show(sum(c in 1..CarNum)(c * assign[p,c])) ++ "\n"
  | p in 1..ParticipantNum])
];