% Quarters (1=Winter, 2=Spring, 3=Summer, 4=Autumn)
int: Q = 4;
set of int: QUARTERS = 1..Q;

% Warehouse capacity (m^3)
int: capacity = 200000;

% Storage cost parameters: (a + b*u) yuan per m^3, where u is storage time in quarters
int: a = 70;
int: b = 100;

% Prices by quarter (table units imply 1 in table = 1 yuan/m^3)
array[QUARTERS] of int: buy_price  = [410, 430, 460, 450];
array[QUARTERS] of int: sell_price = [425, 440, 465, 455];

% Estimated maximum sales volumes by quarter (m^3); table is in 10,000 m^3
array[QUARTERS] of int: max_sales = [100*10000, 140*10000, 200*10000, 160*10000];

% Upper bound on purchases (safe bound for variable domains)
int: max_purchase = capacity + sum(q in QUARTERS)(max_sales[q]);

% Variables
array[QUARTERS] of var 0..max_purchase: buy;                 % purchase volume in quarter q (m^3)
array[QUARTERS, QUARTERS] of var 0..capacity: sell_from;     % sell_from[i,q]: sold in q from cohort bought in i
array[QUARTERS] of var 0..capacity: inv_end;                 % inventory at end of quarter q
var int: profit;                                             % annual profit (yuan)

% No selling from the future
constraint
  forall(i in QUARTERS, q in QUARTERS where i > q) (
    sell_from[i,q] = 0
  );

% For each purchase quarter i, cumulative sales up to quarter q cannot exceed amount bought in i
constraint
  forall(i in QUARTERS, q in QUARTERS where q >= i) (
    sum(t in i..q)(sell_from[i,t]) <= buy[i]
  );

% Sales limits per quarter
constraint
  forall(q in QUARTERS) (
    sum(i in 1..q)(sell_from[i,q]) <= max_sales[q]
  );

% Inventory at end of quarter q: total bought minus total sold up to q
constraint
  forall(q in QUARTERS) (
    inv_end[q] =
      sum(i in QUARTERS)(buy[i])
      - sum(t in 1..q, i in 1..t)(sell_from[i,t])
  );

% Warehouse capacity each quarter
constraint
  forall(q in QUARTERS) (
    inv_end[q] <= capacity
  );

% All inventory must be sold by end of autumn
constraint inv_end[Q] = 0;

% Profit = revenue - purchase cost - storage cost
% Storage cost applies only if sold later than purchase quarter:
% storage time u = q - i, cost per m^3 = a + b*u.
constraint
  profit =
    sum(q in QUARTERS)(
      sell_price[q] * sum(i in 1..q)(sell_from[i,q])
    )
    - sum(i in QUARTERS)(buy_price[i] * buy[i])
    - sum(i in QUARTERS, q in QUARTERS where q > i)(
        (a + b*(q - i)) * sell_from[i,q]
      );

solve maximize profit;