include "alldifferent_except_0.mzn";

% ----- Input -----
int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;   % 1 = interested, 0 = not

% ----- Decision variables -----
array[1..ParticipantNum] of var 0..CarNum: assignment;   % 0 = unassigned

% ----- Constraints -----
% Each car can be used by at most one participant (0 is allowed many times)
constraint alldifferent_except_0(assignment);

% A participant can only be assigned to a car they are interested in
constraint forall(i in 1..ParticipantNum, j in 1..CarNum) (
    assignment[i] == j -> InterestMatrix[i][j] == 1
);

% Count the number of unassigned participants
var int: unassignedCount;
constraint count(assignment, 0, unassignedCount);

% ----- Objective -----
solve maximize ParticipantNum - unassignedCount;   % maximise number of assignments

% ----- Output -----
output [
    "Assignment: ", show(assignment), "\n"
];