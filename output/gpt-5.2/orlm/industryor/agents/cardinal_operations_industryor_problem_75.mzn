% Parameters
% Quarters (1=Winter, 2=Spring, 3=Summer, 4=Autumn)
int: NQ = 4;
set of int: Q = 1..NQ;

% Warehouse capacity (m^3)
int: capacity = 200000;

% Storage cost parameters: (a + b*u) yuan per m^3, where u is storage time in quarters
int: a = 70;
int: b = 100;

% Purchase price per quarter (yuan per m^3)
% Given table units: (10,000 yuan / 10,000 m^3) => yuan/m^3 numerically equal to table entry
array[Q] of int: purchasePrice = [410, 430, 460, 450];

% Sale price per quarter (yuan per m^3)
array[Q] of int: salePrice = [425, 440, 465, 455];

% Maximum sales volume per quarter (m^3)
% Given table units: (10,000 m^3) => multiply by 10,000 to get m^3
array[Q] of int: maxSales = [1000000, 1400000, 2000000, 1600000];

% Storage cost per m^3 for holding inventory from quarter i to quarter j (i<j),
% with u = j-i quarters of storage time
array[Q, Q] of int: storageCost =
  array2d(Q, Q,
    [ if i < j then a + b*(j - i) else 0 endif
      | i in Q, j in Q
    ]
  );

% Variables
% buy[q]: amount purchased at beginning of quarter q (m^3)
array[Q] of var 0..capacity: buy;

% sell[i,j]: amount purchased in quarter i and sold in quarter j (m^3), only allowed for j>=i
array[Q, Q] of var 0..capacity: sell;

% inventoryEnd[q]: inventory remaining at end of quarter q (m^3)
array[Q] of var 0..capacity: inventoryEnd;

% profit: total annual profit (yuan)
var int: profit;

% Constraints
% --- Sales flow feasibility: cannot sell before buying (only allow j >= i) ---
constraint
  forall(i in Q, j in Q where j < i) (
    sell[i,j] = 0
  );

% --- Purchase allocation: all bought in quarter i is either sold in i..NQ ---
constraint
  forall(i in Q) (
    sum(j in i..NQ)(sell[i,j]) = buy[i]
  );

% --- Quarterly sales limits (market demand / max sales per quarter) ---
constraint
  forall(j in Q) (
    sum(i in 1..j)(sell[i,j]) <= maxSales[j]
  );

% --- Inventory balance at end of each quarter ---
% Inventory at end of q equals total bought up to q minus total sold up to q.
constraint
  forall(q in Q) (
    inventoryEnd[q] =
      sum(i in 1..q)(buy[i]) - sum(i in 1..q, j in 1..q)(sell[i,j])
  );

% --- Warehouse capacity: end-of-quarter inventory cannot exceed capacity ---
constraint
  forall(q in Q) (
    inventoryEnd[q] <= capacity
  );

% --- No long-term storage: all inventory must be sold by end of autumn (q=4) ---
constraint
  inventoryEnd[NQ] = 0;

% --- Define profit from revenues minus purchase costs minus storage costs ---
% Storage cost applies to units bought in i and sold in j>i with cost (a + b*(j-i)) per m^3.
constraint
  profit =
    sum(i in Q, j in i..NQ)(
      sell[i,j] * (salePrice[j] - purchasePrice[i] - storageCost[i,j])
    );

% Objective
solve maximize profit;