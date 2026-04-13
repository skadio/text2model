% Basel Tool and Die aggregate production planning (6 months)
% Data embedded as required.

int: nMonths = 6;
set of int: M = 1..nMonths;

array[M] of int: demand = [430, 430, 380, 450, 520, 440];

int: initInventory = 10;

int: regCap = 420;
int: otCap  = 80;

int: regCost = 40;
int: otCost  = 45;
int: invCost = 3;

% Upper bound for inventory: at most initial + cumulative max production up to month m - cumulative demand up to month m
function int: inv_ub(int: m) =
  max(0, initInventory + m * (regCap + otCap) - sum(i in 1..m)(demand[i]));

array[M] of var 0..regCap: regProd;
array[M] of var 0..otCap:  otProd;
array[M] of var 0..inv_ub(index_set_1of1(regProd)[1]): invEnd; % placeholder, will be redefined below

% Redefine invEnd with month-specific bounds (avoids huge domains/timeouts)
array[M] of var int: invEnd =
  [ var 0..inv_ub(m) | m in M ];

% Inventory balance
constraint invEnd[1] = initInventory + regProd[1] + otProd[1] - demand[1];
constraint forall(m in 2..nMonths) (
  invEnd[m] = invEnd[m-1] + regProd[m] + otProd[m] - demand[m]
);

% Cost
var int: totalCost =
  sum(m in M)(regCost * regProd[m] + otCost * otProd[m] + invCost * invEnd[m]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "regProd   = ", show(regProd), "\n",
  "otProd    = ", show(otProd), "\n",
  "invEnd    = ", show(invEnd), "\n"
];