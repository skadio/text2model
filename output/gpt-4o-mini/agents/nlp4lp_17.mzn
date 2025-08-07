int: O;  % Number of options
int: P;  % Number of price points
int: L;  % Number of processes

array[1..O] of int: Allocated;  % Allocated resources for each option
array[1..P] of int: Price;       % Price at each price point
array[1..L, 1..O] of int: Input; % Input resources required for each option in each process
array[1..L, 1..P] of int: Output; % Output produced for each price point in each process
array[1..L] of int: Cost;        % Cost for each process

array[1..L] of var 0..+inf: ProcessCount;  % Number of times each process is executed

% Revenue calculation
array[1..P] of var 0..+inf: Revenue;  % Revenue for each price point

% Constraints to ensure that the allocated resources are not exceeded
constraint forall(o in 1..O)(
    sum(i in 1..L)(Input[i, o] * ProcessCount[i]) <= Allocated[o]
);

% Calculate revenue for each price point
constraint forall(p in 1..P)(
    Revenue[p] = sum(i in 1..L)(Output[i, p] * ProcessCount[i]) - sum(i in 1..L)(Cost[i] * ProcessCount[i])
);

% Objective: Maximize total revenue across all price points
var 0..+inf: TotalRevenue = sum(p in 1..P)(Revenue[p]);

solve maximize TotalRevenue;

output [ "Total Revenue = ", show(TotalRevenue), "\n", 
         "Process Counts = ", show(ProcessCount), "\n" ];