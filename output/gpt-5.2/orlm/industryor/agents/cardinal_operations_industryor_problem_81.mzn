% Parameters
int: num_store_types = 5;                  % Number of store types
set of int: TYPES = 1..num_store_types;    % Store type codes

int: mall_area = 5000;                     % Total leasable area (m^2)
float: rent_rate = 0.20;                   % Rent as fraction of annual profit

array[TYPES] of int: area_per_shop =       % Area per shop (m^2)
  [250, 350, 800, 400, 500];

array[TYPES] of int: min_shops =           % Minimum number of shops
  [1, 1, 1, 0, 1];

array[TYPES] of int: max_shops =           % Maximum number of shops
  [3, 2, 3, 2, 3];

int: max_k = 3;                            % Maximum number of shops with profit entries
set of int: K = 1..max_k;                  % Profit entry index (1 store, 2 stores, 3 stores)

% profit_10k[t,k] = expected annual profit (10k yuan) per store when there are k stores of type t
% Use 0 for non-applicable combinations (where "-" appears in the table).
array[TYPES, K] of int: profit_10k =
  array2d(TYPES, K,
    [  9,  8,  7,   % Type 1: Jewelry
      10,  9,  0,   % Type 2: Shoes & Hats (no 3-store case)
      27, 21, 20,   % Type 3: General Merchandise
      16, 10,  0,   % Type 4: Bookstore (no 3-store case)
      17, 15, 12    % Type 5: Catering
    ]);

% Variables
array[TYPES] of var int: shops;            % Number of shops leased for each store type
var float: total_rent_10k;                 % Total rental income (10k yuan), equals 20% of total profit

% Constraints
%-----------------------------
% Bounds/feasibility constraints for variables
%-----------------------------
constraint forall(t in TYPES) (
  shops[t] >= min_shops[t] /\ shops[t] <= max_shops[t]
);

%-----------------------------
% Total area constraint
%-----------------------------
constraint sum(t in TYPES) (area_per_shop[t] * shops[t]) <= mall_area;

%-----------------------------
% Feasible profit-table choices
%-----------------------------
% If a (type, k) combination is non-applicable (profit=0), then it must not be chosen.
% Note: shops[t] is never 0 for types with min_shops[t]=1, but could be 0 for bookstore (type 4).
constraint
  forall(t in TYPES) (
    (profit_10k[t, shops[t]] > 0) \/ (shops[t] = 0)
  );

%-----------------------------
% Total rental income definition
%-----------------------------
% total_rent_10k = rent_rate * sum over store types of (shops[t] * profit_per_store_given_shops[t])
constraint
  total_rent_10k =
    rent_rate * sum(t in TYPES) (
      int2float(shops[t] * profit_10k[t, shops[t]])
    );

% Objective
solve maximize total_rent_10k;