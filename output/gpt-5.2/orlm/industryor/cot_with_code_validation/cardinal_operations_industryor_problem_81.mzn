% Parameters
int: N = 5;
set of int: STORES = 1..N;

int: total_area = 5000;
float: rent_rate = 0.20; % 20% of profit

array[STORES] of int: area_per_shop = [250, 350, 800, 400, 500];
array[STORES] of int: min_shops     = [1,   1,   1,   0,   1];
array[STORES] of int: max_shops     = [3,   2,   3,   2,   3];

% profit in (ten thousand yuan) per store, depending on number of stores (k)
% For unavailable entries ("-"), set to 0 and restrict x so they can't be used (via max_shops).
int: K = 3;
set of int: COUNT = 1..K;
array[STORES, COUNT] of int: profit_per_store = 
  [|  9,  8,  7  % 1 Jewelry
   | 10,  9,  0  % 2 Shoes & Hats
   | 27, 21, 20  % 3 General Merchandise
   | 16, 10,  0  % 4 Bookstore
   | 17, 15, 12  % 5 Catering
  |];

% Variables
array[STORES] of var int: x; % number of shops of each store type
var int: total_rent_scaled;  % objective scaled by 5 (see below)

% Constraints
constraint forall(i in STORES) (
  x[i] >= min_shops[i] /\ x[i] <= max_shops[i]
);

constraint sum(i in STORES)(area_per_shop[i] * x[i]) <= total_area;

% Compute rent: rent_rate * total_profit, where total_profit = sum_i x[i] * profit_per_store[i, x[i]]
% rent_rate = 0.2 = 1/5, so maximize total_profit, equivalently maximize total_profit/5.
constraint total_rent_scaled = sum(i in STORES)(
  x[i] * profit_per_store[i, x[i]]
);

% Objective
solve maximize total_rent_scaled;