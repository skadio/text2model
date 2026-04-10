% Course selection with category coverage and prerequisites
% Minimize number of courses taken while satisfying:
% - at least 2 Mathematics
% - at least 2 Operations Research
% - at least 2 Computer Science
% Courses may count for multiple categories simultaneously.

enum Course = {
  Calculus,
  OperationsResearch,
  DataStructures,
  ManagementStatistics,
  ComputerSimulation,
  ComputerProgramming,
  Forecasting
};

set of Course: C = {c | c in Course};

% Decision: take course or not
array[Course] of var bool: take;

% Category membership (1 if course counts toward that category)
array[Course] of int: isMath = [
  1, % Calculus
  1, % OperationsResearch
  1, % DataStructures
  1, % ManagementStatistics
  0, % ComputerSimulation
  0, % ComputerProgramming
  1  % Forecasting
];

array[Course] of int: isOR = [
  0, % Calculus
  1, % OperationsResearch
  0, % DataStructures
  1, % ManagementStatistics
  1, % ComputerSimulation
  0, % ComputerProgramming
  1  % Forecasting
];

array[Course] of int: isCS = [
  0, % Calculus
  0, % OperationsResearch
  1, % DataStructures
  0, % ManagementStatistics
  1, % ComputerSimulation
  1, % ComputerProgramming
  0  % Forecasting
];

% Requirements: at least 2 in each category
constraint sum(c in C)(bool2int(take[c]) * isMath[c]) >= 2;
constraint sum(c in C)(bool2int(take[c]) * isOR[c])   >= 2;
constraint sum(c in C)(bool2int(take[c]) * isCS[c])   >= 2;

% Prerequisites
% Computer Simulation requires Computer Programming
constraint take[ComputerSimulation] -> take[ComputerProgramming];

% Data Structures requires Computer Programming
constraint take[DataStructures] -> take[ComputerProgramming];

% Management Statistics requires Calculus
constraint take[ManagementStatistics] -> take[Calculus];

% Forecasting requires Management Statistics (and thus Calculus via above)
constraint take[Forecasting] -> take[ManagementStatistics];

% Objective: minimize number of courses taken
var int: total = sum(c in C)(bool2int(take[c]));
solve minimize total;

output [
  "Minimum number of courses: ", show(total), "\n",
  "Courses taken:\n",
  concat([ if fix(take[c]) then " - " ++ show(c) ++ "\n" else "" endif | c in Course ])
];