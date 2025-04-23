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
array[1..T, 1..K] of var 0..MaxLevel[K]: generatorOutput; % Output of each generator in each period
array[1..T, 1..K] of var 0..1: generatorStatus; % Status of each generator in each period (0 = off, 1 = on)

% Constraints

% Constraint 1: The total output of all generators in each period must meet the demand
constraint forall(t in 1..T)(
  sum(k in 1..K)(generatorOutput[t,k]) = Demand[t]
);

% Constraint 2: The output of each generator must be within its minimum and maximum level
constraint forall(t in 1..T, k in 1..K)(
  generatorOutput[t,k] >= MinLevel[k] * generatorStatus[t,k],
  generatorOutput[t,k] <= MaxLevel[k] * generatorStatus[t,k]
);

% Constraint 3: The number of each type of generator must not exceed its availability
constraint forall(t in 1..T, k in 1..K)(
  sum(i in 1..t)(generatorStatus[i,k]) <= NumGenerator[k]
);

% Constraint 4: If a generator is on, it must have been started up at some point
constraint forall(t in 2..T, k in 1..K)(
  generatorStatus[t,k] <= max(generatorStatus[t-1,k], generatorStatus[t,k])
);

% Objective
solve minimize sum(t in 1..T, k in 1..K) (
  RunCost[k] * MinLevel[k] * generatorStatus[t,k] +
  ExtraCost[k] * max(0, generatorOutput[t,k] - MinLevel[k]) +
  StartCost[k] * max(0, generatorStatus[t,k] - generatorStatus[max(t-1,1),k])
);