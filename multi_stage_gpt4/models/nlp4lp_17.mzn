% Parameters
int: O; % Number of options
int: P; % Number of price points
int: L; % Number of processes
array[1..O] of float: Allocated; % Allocated resources for each option
array[1..P] of float: Price; % Price at each price point
array[1..L, 1..O] of float: Input; % Input resources required for each option in each process
array[1..L, 1..P] of float: Output; % Output produced for each price point in each process
array[1..L] of float: Cost; % Cost for each process

% Variables
array[1..L] of var float+: ProcessExecution; % Number of times each process is executed

% Constraints

% The total input resources used in all processes should not exceed the allocated resources for each option
constraint forall(o in 1..O)(
  sum(l in 1..L)(Input[l,o]*ProcessExecution[l]) <= Allocated[o]
);

% The revenue from selling the products should be greater than or equal to the cost of executing the processes
constraint forall(l in 1..L)(
  sum(p in 1..P)(Output[l,p]*Price[p]*ProcessExecution[l]) >= Cost[l]*ProcessExecution[l]
);

% Objective
solve maximize sum(l in 1..L)(sum(p in 1..P)(Output[l,p]*Price[p]*ProcessExecution[l]) - Cost[l]*ProcessExecution[l]);