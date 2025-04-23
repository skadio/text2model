% Define the parameters
int: OriginNum;
int: DestinationNum;
array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

% Define the decision variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply) : Transport;

% Define the objective function
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum) (Transport[i,j] * Cost[i,j]);

% Define the constraints
constraint forall(i in 1..OriginNum) (sum(j in 1..DestinationNum) (Transport[i,j]) <= Supply[i]);
constraint forall(j in 1..DestinationNum) (sum(i in 1..OriginNum) (Transport[i,j]) >= Demand[j]);

% Minimize the total cost
solve minimize TotalCost;

% Output the solution
output ["Total cost: ", show(TotalCost), "\n"] ++
       ["Transport matrix: \n"] ++
       [show(Transport[i,j]) ++ " " | i in 1..OriginNum, j in 1..DestinationNum] ++ ["\n"];