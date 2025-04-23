% Parameters
int: T; % Total number of periods
int: K; % Total number of generators
array[1..T] of int: Demand; % Demand during period t
array[1..K] of int: NumGenerator; % Number of generator k
array[1..K] of int: MinLevel; % Minimum level of generator k
array[1..K] of int: MaxLevel; % Maximum level of generator k
array[1..K] of int: RunCost; % Running cost of generator k
array[1..K] of int: ExtraCost; % Extra cost of generator k
array[1..K] of int: StartCost; % Start-up cost of generator k

% Variables
array[1..T, 1..K] of var 0..MaxLevel[K]: generator_output; % Output of each generator at each period
array[1..T, 1..K] of var 0..1: generator_status; % Status of each generator at each period (0 = off, 1 = on)

% Constraints

% Constraint 1: The total output of all generators in each period must meet the demand
constraint forall(t in 1..T) (
    sum(k in 1..K) (generator_output[t,k]) = Demand[t]
);

% Constraint 2: The output of each generator must be within its minimum and maximum level
constraint forall(t in 1..T, k in 1..K) (
    generator_output[t,k] >= MinLevel[k] * generator_status[t,k],
    generator_output[t,k] <= MaxLevel[k] * generator_status[t,k]
);

% Constraint 3: If a generator is running, its running cost must be accounted for
constraint forall(t in 1..T, k in 1..K) (
    RunCost[k] * generator_status[t,k] <= generator_output[t,k]
);

% Constraint 4: If a generator is running above its minimum level, its extra cost must be accounted for
constraint forall(t in 1..T, k in 1..K) (
    ExtraCost[k] * (generator_output[t,k] - MinLevel[k]) <= generator_output[t,k]
);

% Constraint 5: If a generator is started, its start-up cost must be accounted for
constraint forall(t in 2..T, k in 1..K) (
    StartCost[k] * (generator_status[t,k] - generator_status[t-1,k]) <= generator_output[t,k]
);

% Objective
solve minimize sum(t in 1..T, k in 1..K) (
    RunCost[k] * generator_status[t,k] + 
    ExtraCost[k] * max(0, generator_output[t,k] - MinLevel[k]) + 
    StartCost[k] * max(0, generator_status[t,k] - generator_status[max(t-1,1),k])
);