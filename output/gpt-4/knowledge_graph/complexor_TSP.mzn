% Input Data Nomenclature
int: OriginNum; % The total number of origins
int: DestinationNum; % The total number of destinations
array[1..OriginNum] of int: Supply; % The supply of goods available at each origin
array[1..DestinationNum] of int: Demand; % The demand for goods to be satisfied at each destination
array[1..OriginNum, 1..DestinationNum] of int: Cost; % The cost of transporting goods from origin i to destination j per good

% Decision Variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply): X; % The amount of goods transported from origin i to destination j

% Constraints
constraint forall(i in 1..OriginNum)(sum(j in 1..DestinationNum)(X[i,j]) <= Supply[i]); % The total amount of goods transported from each origin should not exceed its supply
constraint forall(j in 1..DestinationNum)(sum(i in 1..OriginNum)(X[i,j]) = Demand[j]); % The total amount of goods transported to each destination should meet its demand

% Objective
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j]*X[i,j]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Goods transported from each origin to each destination: \n"] ++
[ if fix(X[i,j]) > 0 then "From origin " ++ show(i) ++ " to destination " ++ show(j) ++ ": " ++ show(X[i,j]) ++ " goods\n" else "" endif | i in 1..OriginNum, j in 1..DestinationNum];