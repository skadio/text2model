% Parameters
int: K; % Number of different spare parts
int: S; % Number of machines capable of making the spare parts
array[1..K, 1..S] of int: Time; % Time taken to make spare part k on machine s
array[1..K] of int: Profit; % Profit obtained from making spare part k
array[1..S] of int: Capacity; % Capacity of machine s for the spare parts

% Variables
array[1..K, 1..S] of var 0..Capacity[S]: quantities; % Quantities of each spare part to be made on each machine

% Constraints

% The total time taken to make all spare parts on each machine should not exceed the machine's capacity
constraint forall(s in 1..S)(
  sum(k in 1..K)(Time[k,s]*quantities[k,s]) <= Capacity[s]
);

% The quantities of spare parts to be made should be non-negative
constraint forall(k in 1..K, s in 1..S)(
  quantities[k,s] >= 0
);

% Objective
solve maximize sum(k in 1..K)(Profit[k]*sum(s in 1..S)(quantities[k,s]));