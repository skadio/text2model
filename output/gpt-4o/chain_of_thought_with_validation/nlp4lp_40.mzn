% Parameters
int: K;
int: S;
array[1..K, 1..S] of int: Time;
array[1..K] of int: Profit;
array[1..S] of int: Capacity;

% Derived parameter: an upper bound on the production of each part
array[1..K] of int: MaxProd =
  [ min([ Capacity[s] div max(1, Time[k, s]) | s in 1..S ]) | k in 1..K ];

int: BigM = max([ MaxProd[k] | k in 1..K ]);

% Variables
array[1..K] of var 0..BigM: Quantity;

% Constraints
constraint
  forall(k in 1..K) (
    Quantity[k] <= MaxProd[k]
  );

constraint
  forall(s in 1..S) (
    sum(k in 1..K)( Time[k, s] * Quantity[k] ) <= Capacity[s]
  );

% Objective
solve maximize sum(k in 1..K)( Profit[k] * Quantity[k] );