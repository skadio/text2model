% Purchase and sales plan (July to December)
% Data embedded as per Table 1-21

int: T = 6;
set of int: M = 1..T;

array[M] of int: buyPrice  = [28, 24, 25, 27, 23, 23]; % Jul..Dec
array[M] of int: sellPrice = [29, 24, 26, 28, 22, 25]; % Jul..Dec

int: capacity = 500;
int: initStock = 200;

% Decision variables
array[M] of var 0..capacity: buy;   % bought at beginning of month
array[M] of var 0..capacity: sell;  % sold during month
array[0..T] of var 0..capacity: stock; % end-of-month stock, with stock[0]=end of June

constraint stock[0] = initStock;

% Inventory balance and feasibility
constraint forall(m in M) (
  stock[m] = stock[m-1] + buy[m] - sell[m]
  /\ sell[m] <= stock[m-1] + buy[m]
  /\ stock[m] <= capacity
);

% Maximize profit (revenue - cost)
var int: profit = sum(m in M)(sellPrice[m]*sell[m] - buyPrice[m]*buy[m]);
solve maximize profit;

output [
  "Max profit = ", show(profit), "\n",
  "Month order: Jul Aug Sep Oct Nov Dec\n",
  "Buy  = ", show([buy[m] | m in M]), "\n",
  "Sell = ", show([sell[m] | m in M]), "\n",
  "End stock = ", show([stock[m] | m in M]), "\n"
];