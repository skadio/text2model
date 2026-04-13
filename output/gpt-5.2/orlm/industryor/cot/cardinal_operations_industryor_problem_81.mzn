% Parameters (with values embedded)
int: N = 5;
set of int: STORES = 1..N;

int: total_area = 5000;

array[STORES] of int: area_per_shop = [250, 350, 800, 400, 500];
array[STORES] of int: min_shops      = [1,   1,   1,   0,   1];
array[STORES] of int: max_shops      = [3,   2,   3,   2,   3];

% profit[i,k] = expected annual profit (ten thousand yuan) per store
% when there are k stores of type i in the mall (k in 1..3).
% Use 0 for not-applicable entries ("-").
array[STORES, 1..3] of int: profit_per_store = array2d(STORES, 1..3,
[
  9,  8,  7,   % 1 Jewelry
  10, 9,  0,   % 2 Shoes & Hats
  27, 21, 20,  % 3 General Merchandise
  16, 10, 0,   % 4 Bookstore
  17, 15, 12   % 5 Catering
]);

int: rent_rate_num = 1;   % rent = 20% of profit, scale by 5 => rent*5 = profit
int: rent_rate_den = 5;

% Variables
array[STORES] of var int: x;                 % number of shops of each type
array[STORES] of var 1..3: k;                % helper to index profit_per_store
array[STORES] of var int: total_profit_5x;   % total profit scaled by 5 (avoid fractions)
var int: total_rent_5x;                      % total rent scaled by 5

% Constraints
constraint forall(i in STORES) (
  x[i] >= min_shops[i] /\ x[i] <= max_shops[i]
);

constraint sum(i in STORES)(area_per_shop[i] * x[i]) <= total_area;

% Tie k to x (x is within 0..3 depending on type; but profit table defined for 1..3)
% For types that can have 0 shops (bookstore), handle x=0 as zero profit/rent.
constraint forall(i in STORES) (
  (x[i] = 0 -> total_profit_5x[i] = 0) /\
  (x[i] > 0 ->
     k[i] = x[i] /\
     profit_per_store[i, k[i]] > 0 /\
     total_profit_5x[i] = 5 * x[i] * profit_per_store[i, k[i]]
  )
);

% total_rent_5x = (1/5) * total_profit_5x, but scaled by 5 => total_rent_5x = sum profit
constraint total_rent_5x = sum(i in STORES)(total_profit_5x[i]) div 5;

% Objective
solve maximize total_rent_5x;