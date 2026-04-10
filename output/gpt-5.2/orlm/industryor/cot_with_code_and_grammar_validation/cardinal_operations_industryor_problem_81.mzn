% Changjiang Comprehensive Shopping Mall tenant mix (embed all data)

int: N = 5;
set of int: STORES = 1..N;

int: total_area = 5000;

array[STORES] of int: area_per_shop = [250, 350, 800, 400, 500];
array[STORES] of int: min_shops     = [  1,   1,   1,   0,   1];
array[STORES] of int: max_shops     = [  3,   2,   3,   2,   3];

int: K = 3;
set of int: COUNT = 1..K;

% profit per shop (10k yuan) depending on how many shops of that type are opened
% For unavailable entries ("-"), set to 0 and forbid those counts via constraints.
array[STORES, COUNT] of int: profit_per_shop =
array2d(STORES, COUNT, [
  9,  8,  7,   % type 1: Jewelry
 10,  9,  0,   % type 2: Shoes & Hats (no 3-shop case)
 27, 21, 20,   % type 3: General Merchandise
 16, 10,  0,   % type 4: Bookstore (no 3-shop case)
 17, 15, 12    % type 5: Catering
]);

array[STORES] of bool: count_allowed_3 = [true, false, true, false, true];

% Decision variables
array[STORES] of var int: x;                 % number of shops of each type
array[STORES] of var int: total_profit_10k;  % total annual profit (10k yuan) for that type

var int: total_profit_all_10k;
var int: total_rent_10k;                     % total rent income (10k yuan); 20% of profit

% Constraints
constraint forall(i in STORES) (
  x[i] >= min_shops[i] /\ x[i] <= max_shops[i]
);

constraint sum(i in STORES) (area_per_shop[i] * x[i]) <= total_area;

constraint forall(i in STORES where not count_allowed_3[i]) (
  x[i] <= 2
);

constraint forall(i in STORES) (
  total_profit_10k[i] =
    if x[i] = 0 then 0
    elseif x[i] = 1 then profit_per_shop[i,1] * 1
    elseif x[i] = 2 then profit_per_shop[i,2] * 2
    else profit_per_shop[i,3] * 3
    endif
);

constraint total_profit_all_10k = sum(i in STORES)(total_profit_10k[i]);

% Rent = 20% of profit => rent = profit / 5 (must be integer here; it is for given data)
constraint total_rent_10k * 5 = total_profit_all_10k;

% Objective (maximize rental income)
solve maximize total_rent_10k;

output [
  "x = ", show(x), "\n",
  "used_area = ", show(sum(i in STORES)(area_per_shop[i]*x[i])), " / ", show(total_area), "\n",
  "total_profit_10k = ", show(total_profit_all_10k), "\n",
  "total_rent_10k = ", show(total_rent_10k), "\n"
];