include "globals.mzn";

% Parameters
int: O; % Number of options
int: P; % Number of price points
int: L; % Number of processes
array[1..O] of int: Allocated; % Allocated resources for each option
array[1..P] of int: Price; % Price at each price point
array[1..L, 1..O] of int: Input; % Input resources required for each option in each process
array[1..L, 1..P] of int: Output; % Output produced for each price point in each process
array[1..L] of int: Cost; % Cost for each process

% Decision variables
array[1..L] of var 0.0..1000000.0: ProcessExecutions; % Number of times each process is executed

% Constraints
constraint forall(i in 1..O)(
  sum(j in 1..L)(Input[j,i]*ProcessExecutions[j]) <= Allocated[i]
);

% Objective function
var float: revenue = sum(i in 1..L)(
  (sum(j in 1..P)(Output[i,j]*Price[j]) - Cost[i])*ProcessExecutions[i]
);

% Solve
solve maximize revenue;

% Output
output [ "Process " ++ show(i) ++ " should be executed " ++ show(ProcessExecutions[i]) ++ " times\n" | i in 1..L ];