% Transportation problem: minimize total shipping cost

% Parameters
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

% Precompute totals
int: TotalSupply = sum(i in 1..OriginNum)(Supply[i]);
int: TotalDemand = sum(j in 1..DestinationNum)(Demand[j]);

% Variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(TotalSupply, TotalDemand): Ship;

% Constraints
constraint forall(i in 1..OriginNum) (
  sum(j in 1..DestinationNum)(Ship[i,j]) <= Supply[i]
);

constraint forall(j in 1..DestinationNum) (
  sum(i in 1..OriginNum)(Ship[i,j]) = Demand[j]
);

% Feasibility (demands must be satisfiable)
constraint TotalSupply >= TotalDemand;

% Objective
solve minimize sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j] * Ship[i,j]);