% Parameters
int: T = 6;                               % number of months in planning horizon (Jul..Dec)
set of int: Months = 1..T;                % month index set (1=Jul, 6=Dec)

set of int: Products = 1..2;              % 1=Product I, 2=Product II

array[Products, Months] of int: demand =  % demand[p,t] in units
[
  % Product I (Jul..Dec): Jul 30000, Aug 30000, Sep 30000, Oct 100000, Nov 100000, Dec 100000
  [30000, 30000, 30000, 100000, 100000, 100000],
  % Product II (Jul..Dec): Jul 15000, Aug 15000, Sep 15000, Oct 50000, Nov 50000, Dec 50000
  [15000, 15000, 15000, 50000, 50000, 50000]
];

array[Products, Months] of float: prodCost =  % production cost per unit
[
  % Product I: Jul..Dec are all in Jun..Dec cost = 4.5
  [4.5, 4.5, 4.5, 4.5, 4.5, 4.5],
  % Product II: Jul..Dec are all in Jun..Dec cost = 7
  [7.0, 7.0, 7.0, 7.0, 7.0, 7.0]
];

int: monthlyProdCap = 120000;             % combined monthly production capacity (units/month)

array[Products] of float: volume = [0.2, 0.4];   % cubic meters per unit for each product
float: ownWarehouseCap = 15000.0;                % factory warehouse capacity in cubic meters

float: ownStorageCost = 1.0;               % yuan per cubic meter per month (own warehouse)
float: extStorageCost = 1.5;               % yuan per cubic meter per month (external warehouse)

array[Products] of int: initInventory = [0, 0];  % initial inventory at start of July (units)

% Useful bounds (derived from data) to keep variables bounded
int: maxDemand = max([demand[p,t] | p in Products, t in Months]);
int: maxMonthlyProd = monthlyProdCap;
int: invUB = sum(t in Months)(max([demand[p,t] | p in Products])); % loose per-product upper bound

% Variables
array[Products, Months] of var 0..maxMonthlyProd: produce;  % units produced of product p in month t
array[Products, Months] of var 0..invUB: inventory;         % end-of-month inventory (units) for product p

array[Months] of var 0.0..float(invUB)*max(volume): totalInvVolume; % total inventory volume (m^3) at month end
array[Months] of var 0.0..ownWarehouseCap: ownUsedVolume;           % volume stored in own warehouse (m^3)
array[Months] of var 0.0..float(invUB)*max(volume): extUsedVolume;  % volume stored externally (m^3)

% Constraints

%--- Inventory balance and demand satisfaction (flow conservation) ---
% End-of-month inventory equals previous inventory + production - demand.
constraint
  forall(p in Products, t in Months) (
    inventory[p,t] =
      (if t = 1 then initInventory[p] else inventory[p,t-1] endif)
      + produce[p,t]
      - demand[p,t]
  );

%--- Monthly combined production capacity ---
constraint
  forall(t in Months) (
    sum(p in Products)(produce[p,t]) <= monthlyProdCap
  );

%--- Inventory volume computation (convert unit inventories to cubic meters) ---
constraint
  forall(t in Months) (
    totalInvVolume[t] = sum(p in Products)(volume[p] * inventory[p,t])
  );

%--- Warehouse split between own and external storage ---
% All inventory volume must be stored either in own warehouse or external rented space.
constraint
  forall(t in Months) (
    ownUsedVolume[t] + extUsedVolume[t] = totalInvVolume[t]
  );

% Objective
solve minimize
  sum(p in Products, t in Months)(prodCost[p,t] * produce[p,t])
+ sum(t in Months)(ownStorageCost * ownUsedVolume[t] + extStorageCost * extUsedVolume[t]);