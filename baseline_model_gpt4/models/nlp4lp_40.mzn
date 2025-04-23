% Number of different spare parts
int: K;

% Number of machines capable of making the spare parts
int: S;

% Time taken to make spare part k on machine s
array[1..K, 1..S] of int: Time;

% Profit obtained from making spare part k
array[1..K] of int: Profit;

% Capacity of machine s for the spare parts
array[1..S] of int: Capacity;

% Decision variable: quantity of each spare part to be made
array[1..K] of var 0..Capacity[S]: Quantity;

% Objective: maximize profit
var int: total_profit = sum(k in 1..K)(Profit[k]*Quantity[k]);
maximize total_profit;

% Constraint: each machine's capacity cannot be exceeded
constraint forall(s in 1..S)(
    sum(k in 1..K)(Time[k,s]*Quantity[k]) <= Capacity[s]
);

solve satisfy;
output ["Total profit: ", show(total_profit), "\nQuantities: ", show(Quantity)];