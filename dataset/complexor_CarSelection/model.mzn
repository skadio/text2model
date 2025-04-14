% ============================================================
% CAR SELECTION PROBLEM
% ============================================================
%
% Description:
%  The Car Selection Problem aims to assign participants to cars in a way that maximizes
%  the total number of assignments. Each participant is interested in a subset of cars and 
%  can only be assigned to one car. Each car is assumed to be assigned to at most one participant.
%  The goal is to maximize the number of participants who are assigned a car they are interested in.
%
% Parameters (provided via a data file):
%   - ParticipantNum: Total number of participants.
%   - CarNum: Total number of available cars.
%   - InterestMatrix: A binary matrix (ParticipantNum x CarNum) where 1 indicates interest.
%
% Decision Variables:
%   - Assignment[i,j] is 1 if participant i is assigned to car j, 0 otherwise.
%
% Objective:
%   Maximize TotalAssignments, i.e. the total number of participants assigned a car.
%
% Output:
%   - Assignment: The assignment matrix.
%   - TotalAssignments: Total number of participants assigned to a car.
%
% ============================================================

% -----------------------------
% 1) PARAMETERS
% -----------------------------
int: ParticipantNum;
int: CarNum;

% Binary interest matrix: InterestMatrix[i,j] = 1 if participant i is interested in car j, 0 otherwise.
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;

% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------
% Assignment[i,j] = 1 if participant i is assigned to car j, 0 otherwise.
array[1..ParticipantNum, 1..CarNum] of var 0..1: Assignment;

% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% Each participant can be assigned to at most one car.
constraint
  forall(i in 1..ParticipantNum) (
    sum(j in 1..CarNum)(Assignment[i,j]) <= 1
  );

% Each car can be assigned to at most one participant.
constraint
  forall(j in 1..CarNum) (
    sum(i in 1..ParticipantNum)(Assignment[i,j]) <= 1
  );

% A participant can only be assigned to a car if they are interested in it.
constraint
  forall(i in 1..ParticipantNum, j in 1..CarNum) (
    Assignment[i,j] <= InterestMatrix[i,j]
  );

% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------
% Total number of assignments (i.e., total participants assigned a car).
var int: TotalAssignments = sum(i in 1..ParticipantNum, j in 1..CarNum)(Assignment[i,j]);

solve maximize TotalAssignments;

% -----------------------------
% 5) OUTPUT
% -----------------------------
output [
  "Assignment:\n",
  concat([
    "Participant " ++ show(i) ++ ": " ++ show([Assignment[i,j] | j in 1..CarNum]) ++ "\n"
    | i in 1..ParticipantNum
  ]),
  "TotalAssignments: ", show(TotalAssignments), "\n"
];