% ----- Oil refinery optimisation ---------------------------------------

% Problem parameters (provided in the .dzn data file)
int: O;                           % number of crude oil types (options)
int: P;                           % number of price points
int: L;                           % number of processes

array[1..O] of int: Allocated;    % available barrels of each oil type
array[1..P] of int: Price;        % selling price for each price point
array[1..L] of int: Cost;         % cost per barrel of product produced by each process

array[1..L, 1..O] of int: Input;  % barrels of each oil type required by each process
array[1..L, 1..P] of int: Output; % barrels of each product produced by each process

% Decision variables: how many times each process is executed
array[1..L] of var 0.0..+inf: x;

% Resource consumption constraints
constraint
    forall(o in 1..O)(
        sum(l in 1..L)( Input[l,o] * x[l] ) <= Allocated[o]
    );

% Objective: maximise revenue minus processing cost
var float: objective = 
    sum(l in 1..L)(
        sum(p in 1..P)( Output[l,p] * (Price[p] - Cost[l]) * x[l] )
    );

solve maximize objective;

% Output the optimal number of executions for each process
output [
    "Optimal process counts (x):\n",
    concat([ show(x[l]), if l < L then ", " else "\n" endif | l in 1..L ])
];