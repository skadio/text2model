% Parameters (with values embedded)
int: Q = 4;
set of int: Quarters = 1..Q; % 1=Winter, 2=Spring, 3=Summer, 4=Autumn

int: capacity = 200000; % m^3 warehouse capacity

% Storage cost (yuan/m^3): a + b*u, where u is storage time in quarters
int: a = 70;
int: b = 100;

% Prices given in table (units of 10,000 yuan per 10,000 m^3 => equals yuan/m^3)
array[Quarters] of int: buyPrice  = [410, 430, 460, 450]; % yuan/m^3
array[Quarters] of int: sellPrice = [425, 440, 465, 455]; % yuan/m^3

% Estimated maximum sales volume (10,000 m^3) converted to m^3
array[Quarters] of int: maxSales = [100, 140, 200, 160] * 10000; % m^3

% Storage cost per quarter of holding from quarter i to quarter j (i<j):
% cost = (j-i) * (a + b*(j-i)) in yuan/m^3
array[Quarters, Quarters] of int: holdCost =
array2d(Quarters, Quarters,
[
  0,   (1)*(a+b*1), (2)*(a+b*2), (3)*(a+b*3),
  0,   0,           (1)*(a+b*1), (2)*(a+b*2),
  0,   0,           0,           (1)*(a+b*1),
  0,   0,           0,           0
]);

% Variables
% x[i,j] = amount (m^3) purchased in quarter i and sold in quarter j (j>=i)
array[Quarters, Quarters] of var 0..capacity: x;

% Constraints
% Disallow selling before purchasing
constraint forall(i in Quarters, j in Quarters where j < i)(x[i,j] = 0);

% Sales capacity each quarter
constraint forall(j in Quarters)(
  sum(i in Quarters where i <= j)(x[i,j]) <= maxSales[j]
);

% Warehouse capacity: inventory held at end of each quarter t
% inventory_end[t] = sum over purchases already made but not yet sold by end of t
constraint forall(t in Quarters)(
  sum(i in Quarters, j in Quarters where i <= t /\ j > t)(x[i,j]) <= capacity
);

% All inventory sold by end of autumn is enforced by allowing only j in 1..4
% (no variables for sales after quarter 4)

% Objective
% Profit = revenue - purchase cost - storage cost for items held across quarters
var int: profit =
  sum(i in Quarters, j in Quarters where j >= i)(
      x[i,j] * (sellPrice[j] - buyPrice[i] - holdCost[i,j])
  );

solve maximize profit;