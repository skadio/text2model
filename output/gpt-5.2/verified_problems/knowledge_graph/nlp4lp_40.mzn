int: K; % number of spare parts
int: S; % number of machines/shops

array[1..K, 1..S] of int: Time;      % worker-hours per unit of part k on machine s
array[1..K] of int: Profit;          % profit per unit of part k
array[1..S] of int: Capacity;        % available hours on machine s

array[1..K] of var int: Qty;         % quantity to produce of each part

constraint forall(k in 1..K) (Qty[k] >= 0);

% Machine capacity constraints
constraint
  forall(s in 1..S) (
    sum(k in 1..K) (Time[k,s] * Qty[k]) <= Capacity[s]
  );

% Objective: maximize total profit
var int: TotalProfit = sum(k in 1..K) (Profit[k] * Qty[k]);

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "Qty=", show(Qty), "\n"
];