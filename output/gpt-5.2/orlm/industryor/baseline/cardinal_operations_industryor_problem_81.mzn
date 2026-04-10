% Changjiang Comprehensive Shopping Mall tenant mix optimization
% Maximize rental income (20% of annual profit) subject to space and min/max shops.

int: total_area = 5000;
int: nTypes = 5;

set of int: T = 1..nTypes;

array[T] of string: name = ["Jewelry", "ShoesHats", "GeneralMerch", "Bookstore", "Catering"];

array[T] of int: area = [250, 350, 800, 400, 500];
array[T] of int: minShops = [1, 1, 1, 0, 1];
array[T] of int: maxShops = [3, 2, 3, 2, 3];

% Profit per store (in ten-thousand yuan) depends on how many stores of that type are opened.
% profit_per_store[t,k] is defined for k=1..maxShops[t].
% Use 0 for undefined entries (won't be used due to constraints on x[t]).
int: Kmax = 3;
array[T, 1..Kmax] of int: profit_per_store = 
[
  % k=1  k=2  k=3
    9,    8,    7,   % Jewelry
   10,    9,    0,   % Shoes & Hats (no 3 stores)
   27,   21,   20,   % General Merchandise
   16,   10,    0,   % Bookstore (no 3 stores)
   17,   15,   12    % Catering
];

array[T] of var int: x;
constraint forall(t in T)(x[t] >= minShops[t] /\ x[t] <= maxShops[t]);

constraint sum(t in T)(area[t] * x[t]) <= total_area;

% Total profit (ten-thousand yuan) = sum over types of (number of stores) * (profit per store at that count)
var int: total_profit_10k = sum(t in T)( x[t] * profit_per_store[t, x[t]] );

% Rental income is 20% of profit. Maximize 0.2 * profit == maximize profit.
solve maximize total_profit_10k;

output [
  "Selected shop counts:\n"
] ++
[
  name[t] ++ ": " ++ show(x[t]) ++ "\n"
  | t in T
] ++
[
  "\nTotal used area: " ++ show(sum(t in T)(area[t] * x[t])) ++ " m^2\n",
  "Total annual profit: " ++ show(total_profit_10k) ++ " (ten-thousand yuan)\n",
  "Total annual rent (20%): " ++ show(total_profit_10k) ++ " * 0.2 = " ++ show(2 * total_profit_10k) ++ " (thousand yuan)\n"
];