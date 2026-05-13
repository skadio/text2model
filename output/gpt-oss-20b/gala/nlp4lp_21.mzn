include "globals.mzn";

% ---------- Parameters ----------
int: M;                      % number of machine types
int: K;                      % number of product types
int: I;                      % number of time periods

array[1..M] of int: NumMachines;          % machines available per type
array[1..K] of int: Profit;                % profit per unit of product k
array[1..K,1..M] of float: Time;           % time needed on machine m for product k
array[1..I,1..M] of int: Maintain;         % number of machines of type m under maintenance in period i
array[1..K,1..I] of int: Limit;            % maximum storage for product k in period i
float: StorePrice;                         % cost per unit stored per month
array[1..K] of int: KeepQuantity;          % minimum stock that must remain at end of each period
float: WorkHours;                          % working hours per day

% ---------- Derived constants ----------
float: DaysPerMonth = 24.0;                          % fixed days per month
float: TotalHours = WorkHours * DaysPerMonth;        % working hours per machine per month

% ---------- Decision variables ----------
array[1..K,1..I] of var int: produce;   % units produced of product k in period i
array[1..K,1..I] of var int: sale;     % units sold of product k in period i
array[1..K,1..I] of var int: stock;    % inventory of product k at end of period i

% ---------- Constraints ----------

% Production must be at least what is sold
constraint forall(k in 1..K, i in 1..I) (
    0 <= sale[k,i] /\ sale[k,i] <= produce[k,i]
);

% Inventory flow
% Stock at period 1
constraint forall(k in 1..K) (
    stock[k,1] == produce[k,1] - sale[k,1]
);
% Stock for subsequent periods
constraint forall(k in 1..K, i in 2..I) (
    stock[k,i] == stock[k,i-1] + produce[k,i] - sale[k,i]
);

% Minimum stock requirement
constraint forall(k in 1..K, i in 1..I) (
    stock[k,i] >= KeepQuantity[k]
);

% Storage limits
constraint forall(k in 1..K, i in 1..I) (
    stock[k,i] <= Limit[k,i]
);

% Machine capacity in each period
constraint forall(i in 1..I, m in 1..M) (
    sum(k in 1..K)(Time[k,m] * produce[k,i]) <=
        (float(NumMachines[m]) - float(Maintain[i,m])) * TotalHours
);

% ---------- Objective ----------
var float: totalProfit = sum(k in 1..K, i in 1..I)(
    Profit[k] * sale[k,i] - StorePrice * stock[k,i]
);

solve maximize totalProfit;

% ---------- Output ----------
output [
    "Total Profit: ", show(totalProfit), "\n",
    "\nProduction:\n",
    concat([ "Period ", show(i), ":\n",
             concat([ "  Product ", show(k), ": ", show(produce[k,i]), "\n" | k in 1..K ])
           | i in 1..I ]),
    "\nSales:\n",
    concat([ "Period ", show(i), ":\n",
             concat([ "  Product ", show(k), ": ", show(sale[k,i]), "\n" | k in 1..K ])
           | i in 1..I ]),
    "\nStock at end of each period:\n",
    concat([ "Period ", show(i), ":\n",
             concat([ "  Product ", show(k), ": ", show(stock[k,i]), "\n" | k in 1..K ])
           | i in 1..I ])
];