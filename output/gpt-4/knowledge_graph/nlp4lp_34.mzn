include "globals.mzn";

% Parameters
int: T; % Total number of periods
int: K; % Total number of generators
array[1..T] of int: Demand; % Demand during period t
array[1..K] of int: NumGenerator; % Number of generator k
array[1..K] of int: MinLevel; % Minimum level of generator k
array[1..K] of int: MaxLevel; % Maximum level of generator k
array[1..K] of int: RunCost; % Running cost of generator k
array[1..K] of float: ExtraCost; % Extra cost of generator k
array[1..K] of int: StartCost; % Start-up cost of generator k

% Variables
array[1..T, 1..K] of var 0..MaxLevel[K]: Power; % Power produced by generator k during period t
array[1..T, 1..K] of var 0..1: Start; % Whether generator k starts during period t

% Constraints
constraint forall(t in 1..T)(sum(k in 1..K)(Power[t, k]) = Demand[t]); % Demand must be met
constraint forall(t in 1..T, k in 1..K)(Power[t, k] >= MinLevel[k] * Start[t, k]); % Minimum production level
constraint forall(t in 1..T, k in 1..K)(Power[t, k] <= MaxLevel[k] * Start[t, k]); % Maximum production level
constraint forall(t in 2..T, k in 1..K)(Start[t, k] >= Start[t-1, k] - Start[t, k]); % Start-up cost

% Objective
var int: TotalCost;
constraint TotalCost = sum(t in 1..T, k in 1..K)((RunCost[k] + ExtraCost[k] * (Power[t, k] - MinLevel[k])) * Start[t, k] + StartCost[k] * max(0, Start[t, k] - if t > 1 then Start[t-1, k] else 0 endif));
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Power: "] ++ [show(Power[t, k]) | t in 1..T, k in 1..K] ++
["\nStart: "] ++ [show(Start[t, k]) | t in 1..T, k in 1..K];