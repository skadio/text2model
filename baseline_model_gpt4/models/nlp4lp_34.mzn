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

% Decision Variables
array[1..T, 1..K] of var 0..MaxLevel[K]: Power; % Power produced by generator k in period t
array[1..T, 1..K] of var 0..1: Start; % Whether generator k starts in period t

% Objective
var int: TotalCost;
constraint TotalCost = sum(t in 1..T, k in 1..K) (RunCost[k] * Start[t,k] + ExtraCost[k] * (Power[t,k] - MinLevel[k]) * Start[t,k] + StartCost[k] * bool2int((t > 1 /\ Start[t,k] > Start[t-1,k])));

% Constraints
constraint forall(t in 1..T) (sum(k in 1..K) (Power[t,k]) = Demand[t]);
constraint forall(t in 1..T, k in 1..K) (Power[t,k] >= MinLevel[k] * Start[t,k]);
constraint forall(t in 1..T, k in 1..K) (Power[t,k] <= MaxLevel[k] * Start[t,k]);
constraint forall(t in 1..T, k in 1..K) (Power[t,k] <= NumGenerator[k] * MaxLevel[k]);

% Solve
solve minimize TotalCost;

% Output
output [ "Total Cost: " ++ show(TotalCost) ++ "\n" ] ++
[ if fix(Start[t,k]) = 1 then "Generator " ++ show(k) ++ " starts at period " ++ show(t) ++ " with power " ++ show(Power[t,k]) ++ "\n" else "" endif | t in 1..T, k in 1..K ];