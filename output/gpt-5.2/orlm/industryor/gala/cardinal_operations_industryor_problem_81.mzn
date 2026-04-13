include "globals.mzn";

% Mall leasing optimization (maximize rental income)
% Data embedded from the problem statement.

int: nTypes = 5;
set of int: T = 1..nTypes;

array[T] of string: name = ["Jewelry", "Shoes&Hats", "GeneralMerch", "Bookstore", "Catering"];

int: totalArea = 5000;

array[T] of int: areaPerShop = [250, 350, 800, 400, 500];
array[T] of int: minShops    = [  1,   1,   1,   0,   1];
array[T] of int: maxShops    = [  3,   2,   3,   2,   3];

% profitPerStore[t,k] = expected annual profit (in 10k yuan) per store
% if there are exactly k stores of type t.
% Undefined entries are set to 0 but will be forbidden by constraints.
int: K = 3;
array[T, 1..K] of int: profitPerStore = array2d(T, 1..K, [
  % k=1, k=2, k=3
     9,   8,   7,   % 1 Jewelry
    10,   9,   0,   % 2 Shoes & Hats (no 3-store case)
    27,  21,  20,   % 3 General Merchandise
    16,  10,   0,   % 4 Bookstore (no 3-store case)
    17,  15,  12    % 5 Catering
]);

% Decision variables: number of stores of each type
array[T] of var int: x;
constraint forall(t in T)(x[t] >= minShops[t] /\ x[t] <= maxShops[t]);

% Forbid selecting store counts that have no defined profit case (shown as "-" in table)
constraint x[2] != 3;
constraint x[4] != 3;

% Area constraint
constraint sum(t in T)(areaPerShop[t] * x[t]) <= totalArea;

% Objective: maximize rent = 20% of total profit.
% Profit units are in 10k yuan; multiplying by 20 gives rent in 0.1 * 10k = 1k yuan units.
array[T] of var int: totalProfit_t;   % in 10k yuan
constraint forall(t in T)(
  totalProfit_t[t] =
    (profitPerStore[t,1] * x[t]) * bool2int(x[t] = 1) +
    (profitPerStore[t,2] * x[t]) * bool2int(x[t] = 2) +
    (profitPerStore[t,3] * x[t]) * bool2int(x[t] = 3)
);

var int: totalProfit = sum(t in T)(totalProfit_t[t]);       % in 10k yuan
var int: totalRentK  = 20 * totalProfit;                   % in 1k yuan (since 0.2 * 10k = 2k; but using integer scaling: 20*(10k)=200k? see below)

% Explanation of scaling:
% totalProfit is in "10,000 yuan". Rent is 20% => 0.2 * totalProfit * 10,000 yuan.
% If we measure rent in "1,000 yuan", rent = 0.2 * totalProfit * 10 = 2 * totalProfit.
% To keep integers clean in MiniZinc, we output both:
var int: totalRent_in_1k = 2 * totalProfit;  % rent in 1,000 yuan
var int: totalRent_in_10k = totalProfit div 5; % rent in 10k yuan, only exact if totalProfit multiple of 5

solve maximize totalRent_in_1k;

output [
  "Chosen number of stores per type:\n",
  concat([ name[t] ++ ": " ++ show(x[t]) ++ "\n" | t in T ]),
  "\nTotal area used (m^2): ", show(sum(t in T)(areaPerShop[t] * x[t])), " / ", show(totalArea), "\n",
  "Total profit (10k yuan): ", show(totalProfit), "\n",
  "Total rent (1k yuan): ", show(totalRent_in_1k), "\n",
  "Total rent (10k yuan, integer approx): ", show(totalRent_in_10k), "\n"
];