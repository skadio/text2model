include "globals.mzn";

% ----------------------------
% Data (embedded from problem)
% ----------------------------
% course indices:
% 1 Calculus
% 2 Operations Research
% 3 Data Structures
% 4 Management Statistics
% 5 Computer Simulation
% 6 Computer Programming
% 7 Forecasting
int: nCourses = 7;
set of int: COURSES = 1..nCourses;

set of int: MATH = {1,2,3,4,7};     % Calculus, OR, Data Structures, Mgmt Stats, Forecasting
set of int: ORCAT = {2,4,5,7};      % OR, Mgmt Stats, Simulation, Forecasting
set of int: CSCAT = {3,5,6};        % Data Structures, Simulation, Programming

% ----------------------------
% Decision variables
% ----------------------------
array[COURSES] of var 0..1: take;

% Minimum number of courses taken (hint uses count)
var 0..nCourses: numTaken;
constraint count(take, 1, numTaken);

% ----------------------------
% Requirements (2 in each category; multi-category counts simultaneously)
% ----------------------------
constraint sum(i in MATH)(take[i]) >= 2;
constraint sum(i in ORCAT)(take[i]) >= 2;
constraint sum(i in CSCAT)(take[i]) >= 2;

% ----------------------------
% Prerequisites
% ----------------------------
% Computer Simulation or Data Structures requires Computer Programming first
constraint take[5] = 1 -> take[6] = 1;  % Simulation -> Programming
constraint take[3] = 1 -> take[6] = 1;  % Data Structures -> Programming

% Management Statistics requires Calculus first
constraint take[4] = 1 -> take[1] = 1;

% Forecasting requires Management Statistics first
constraint take[7] = 1 -> take[4] = 1;

% ----------------------------
% Objective
% ----------------------------
solve minimize numTaken;

% ----------------------------
% Output
% ----------------------------
array[COURSES] of string: cname = [
  "Calculus",
  "Operations Research",
  "Data Structures",
  "Management Statistics",
  "Computer Simulation",
  "Computer Programming",
  "Forecasting"
];

output [
  "Minimum number of courses = ", show(numTaken), "\n",
  "Take = ", show([ if fix(take[i]) = 1 then cname[i] else "" endif | i in COURSES ]), "\n",
  "Binary take vector (1..7) = ", show(take), "\n"
];