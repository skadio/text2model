% Parameters
int: nTypes = 5;                         % number of store types
int: total_area = 5000;                  % total leasable area (m^2)
int: rent_pct = 20;                      % rent is 20% of annual profit
int: profit_scale = 10;                  % profit unit: ten-thousand yuan (kept as integer scale)

set of int: TYPES = 1..nTypes;           % index set for store types
int: maxMax = 3;                         % maximum possible store count across all types

array[TYPES] of int: area_per_shop =     % area per shop by type
  [250, 350, 800, 400, 500];

array[TYPES] of int: min_shops =         % minimum shops by type
  [1, 1, 1, 0, 1];

array[TYPES] of int: max_shops =         % maximum shops by type
  [3, 2, 3, 2, 3];

% profit_per_store[t,k] = expected annual profit (ten-thousand yuan) per store
% if there are k stores of type t in the mall. Use 0 for undefined entries.
array[TYPES, 1..maxMax] of int: profit_per_store =
  [|  9,  8,  7   % type 1: Jewelry (k=1..3)
   | 10,  9,  0   % type 2: Shoes & Hats (k=1..2)
   | 27, 21, 20   % type 3: General Merchandise (k=1..3)
   | 16, 10,  0   % type 4: Bookstore (k=1..2)
   | 17, 15, 12   % type 5: Catering (k=1..3)
  |];


% Variables
array[TYPES] of var int: shops;          % number of shops of each type
array[TYPES] of var int: type_profit;    % total profit by type (ten-thousand yuan)
var int: total_profit;                   % total profit across all types (ten-thousand yuan)
var int: total_rent;                     % total rental income (scaled: ten-thousand yuan * percent)


% Constraints

%--- Feasible shop count bounds per type (min/max requirements) ---
constraint
  forall(t in TYPES) (
    shops[t] >= min_shops[t] /\
    shops[t] <= max_shops[t]
  );

%--- Total area capacity of the mall ---
constraint
  sum(t in TYPES) (area_per_shop[t] * shops[t]) <= total_area;

%--- Link total profit per type to chosen number of shops (profit depends on count) ---
% type_profit[t] = shops[t] * profit_per_store[t, shops[t]]
% Use element() to select the per-store profit corresponding to shops[t].
constraint
  forall(t in TYPES) (
    type_profit[t] =
      shops[t] * element(shops[t], [profit_per_store[t,k] | k in 1..maxMax])
  );

%--- Aggregate total profit across types ---
constraint
  total_profit = sum(t in TYPES) (type_profit[t]);

%--- Compute total rent as 20% of total profit (kept integer-scaled) ---
% total_rent is in "ten-thousand yuan * percent" units (no division).
constraint
  total_rent = total_profit * rent_pct;


% Objective
solve maximize total_rent;