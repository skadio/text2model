int: OriginNum;                          % Number of origins
int: DestinationNum;                     % Number of destinations
array[1..OriginNum] of int: Supply;     % Supply at each origin
array[1..DestinationNum] of int: Demand; % Demand at each destination
array[1..OriginNum, 1..DestinationNum] of int: Cost; % Transportation cost

% Decision variables: amount of goods transported from origin i to destination j
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply): Transport;

% Objective: Minimize total transportation cost
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum)(Transport[i,j] * Cost[i,j]);

% Constraints
% Supply constraints: total goods transported from each origin should not exceed its supply
constraint forall(i in 1..OriginNum)(
    sum(j in 1..DestinationNum)(Transport[i,j]) <= Supply[i]
);

% Demand constraints: total goods received at each destination should meet its demand
constraint forall(j in 1..DestinationNum)(
    sum(i in 1..OriginNum)(Transport[i,j]) >= Demand[j]
);

% Solve the model
solve minimize TotalCost;

% Output the results
output [
    "Total Transportation Cost = ", show(TotalCost), "\n",
    "Transport Matrix:\n" ++
    concat([ show(Transport[i,j]) ++ if j < DestinationNum then ", " else "\n" endif | i in 1..OriginNum, j in 1..DestinationNum ])
];