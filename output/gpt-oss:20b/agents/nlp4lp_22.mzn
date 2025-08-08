% ------------------------------------------------------------
%   Production / Storage / Selling optimisation
% ------------------------------------------------------------
include "globals.mzn";

% -------------------- parameters (from data file) ------------
int: M;                     % number of machine types
int: K;                     % number of product types
int: I;                     % number of time periods (months)

array[1..M] of int: NumMachines;            % machines available per type
array[1..K] of float: Profit;               % profit per unit sold
array[1..K,1..M] of float: Time;            % time per unit on machine m
array[1..M] of int: Downtime;               % 0 = available, 1 = down
array[1..K,1..I] of int: Limit;             % production limit per month
float: StorePrice;                          % storage cost per unit per month
int: KeepQuantity;                          % minimum inventory to keep each month
float: WorkHours;                           % work hours per shift per day

% -------------------- derived constants ---------------------
int: WorkDays   = 24;                        % days in a month
int: Shifts     = 2;                         % shifts per day
float: WorkHoursMonth = WorkHours * Shifts * WorkDays;  % work hours per machine per month

% -------------------- decision variables --------------------
array[1..I,1..K] of var 0..intmax: prod;    % units produced
array[1..I,1..K] of var 0..intmax: sell;   % units sold
array[1..I,1..K] of var 0..intmax: inv;    % inventory at month end

% -------------------- constraints ----------------------------
% Production limits per month
constraint forall(i in 1..I, k in 1..K) (
    prod[i,k] <= Limit[k,i]
);

% Machine capacity per month
constraint forall(i in 1..I, m in 1..M) (
    sum(k in 1..K) prod[i,k] * Time[k,m] <=
    NumMachines[m] * WorkHoursMonth * (1 - Downtime[m])
);

% Inventory dynamics
constraint forall(k in 1..K) (
    inv[1,k] == prod[1,k] - sell[1,k]
);
constraint forall(i in 2..I, k in 1..K) (
    inv[i,k] == inv[i-1,k] + prod[i,k] - sell[i,k]
);

% Inventory bounds
constraint forall(i in 1..I, k in 1..K) (
    inv[i,k] >= KeepQuantity /\          % minimum inventory
    inv[i,k] <= 100                      % maximum storage capacity
);

% Cannot sell more than available
constraint forall(i in 1..I, k in 1..K) (
    sell[i,k] <= prod[i,k] + (i==1 /\ 0 \/ inv[i-1,k])
);

% -------------------- objective ----------------------------
var float: profit = 
    sum(i in 1..I, k in 1..K) (sell[i,k] * Profit[k]) -
    sum(i in 1..I, k in 1..K) (inv[i,k] * StorePrice);

solve maximize profit;

% -------------------- output --------------------------------
output [
    "Maximum Profit = ", show(profit), "\n",
    "\nProduction Schedule:\n",
    "Month | ", 
    concat([ "P", show(k), " " | k in 1..K]), "\n",
    concat([ show(i), " | ",
             concat([ show(prod[i,k]), " " | k in 1..K]),
             "\n"] | i in 1..I),
    "\nInventory at month end:\n",
    "Month | ", 
    concat([ "P", show(k), " " | k in 1..K]), "\n",
    concat([ show(i), " | ",
             concat([ show(inv[i,k]), " " | k in 1..K]),
             "\n"] | i in 1..I),
    "\nSales:\n",
    "Month | ", 
    concat([ "P", show(k), " " | k in 1..K]), "\n",
    concat([ show(i), " | ",
             concat([ show(sell[i,k]), " " | k in 1..K]),
             "\n"] | i in 1..I)
];