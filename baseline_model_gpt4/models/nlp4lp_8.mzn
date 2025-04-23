% Define the parameters
int: NumParts;
int: NumMachines;
array[1..NumParts, 1..NumMachines] of int: Time;
array[1..NumParts] of int: Profit;
array[1..NumMachines] of int: Capacity;

% Define the decision variables
array[1..NumParts] of var 0..Capacity[1]: PartsProduced;

% Define the objective function
var int: totalProfit = sum(k in 1..NumParts)(Profit[k]*PartsProduced[k]);
maximize totalProfit;

% Define the constraints
constraint forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(Time[k,s]*PartsProduced[k]) <= Capacity[s]
);

% Output the solution
output ["Total profit: ", show(totalProfit), "\nParts produced: ", show(PartsProduced)];