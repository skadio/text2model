% Parameters
int: nCrude = 2;                      % Number of crude oil types
set of int: CRUDE = 1..nCrude;
int: A = 1;                           % Index for crude A
int: B = 2;                           % Index for crude B

int: nGas = 2;                        % Number of gasoline types
set of int: GAS = 1..nGas;
int: I  = 1;                          % Index for gasoline Type I
int: II = 2;                          % Index for gasoline Type II

array[CRUDE] of int: inventory = [500, 1000];            % Current inventory (t) of crude A,B
int: max_purchase_A = 1500;                               % Max purchasable crude A (t)

array[GAS] of int: min_prop_A_pct = [50, 60];            % Minimum % of crude A in Type I, II
array[GAS] of int: sell_price = [4800, 5600];            % Selling price (yuan/t) for Type I, II

% Piecewise purchase price for crude A (yuan/t)
int: tier1_cap = 500;                                     % Up to 500 t
int: tier2_cap = 500;                                     % Next 500 t (500..1000)
int: tier3_cap = max_purchase_A - tier1_cap - tier2_cap;  % Remaining (1000..1500)

int: price_tier1 = 10000;                                 % yuan/t for first 500 t
int: price_tier2 = 8000;                                  % yuan/t for next 500 t
int: price_tier3 = 6000;                                  % yuan/t beyond 1000 t


% Variables
var 0..max_purchase_A: buyA;                               % Total crude A purchased (t)

var 0..tier1_cap: buyA_t1;                                 % Purchased A in tier 1 (t)
var 0..tier2_cap: buyA_t2;                                 % Purchased A in tier 2 (t)
var 0..tier3_cap: buyA_t3;                                 % Purchased A in tier 3 (t)

% Upper bound large enough for any single use/prod variable
int: UB = inventory[A] + max_purchase_A + inventory[B];

array[CRUDE, GAS] of var 0..UB: use;
% use[c,g] = tons of crude c used to produce gasoline g

array[GAS] of var 0..UB: prod;
% prod[g] = total production (t) of gasoline g

var 0..UB: total_prod;                                     % Total gasoline production (t)

var int: revenue;                                          % Total sales revenue (yuan)
var int: purchase_cost;                                    % Total crude A purchase cost (yuan)
var int: profit;                                           % Profit = revenue - purchase_cost (yuan)


% Constraints

%--- Purchase decomposition into price tiers ---
constraint buyA = buyA_t1 + buyA_t2 + buyA_t3;

%--- Crude availability / material balance (do not exceed inventory + purchases) ---
constraint sum(g in GAS)(use[A,g]) <= inventory[A] + buyA;
constraint sum(g in GAS)(use[B,g]) <= inventory[B];

%--- Gasoline production definition (production equals sum of crudes blended) ---
constraint forall(g in GAS)(
  prod[g] = sum(c in CRUDE)(use[c,g])
);
constraint total_prod = sum(g in GAS)(prod[g]);

%--- Quality constraints: minimum proportion of crude A in each gasoline ---
constraint forall(g in GAS)(
  100 * use[A,g] >= min_prop_A_pct[g] * prod[g]
);

%--- Accounting constraints for revenue, purchase cost, and profit ---
constraint revenue = sum(g in GAS)(sell_price[g] * prod[g]);

constraint purchase_cost =
    price_tier1 * buyA_t1
  + price_tier2 * buyA_t2
  + price_tier3 * buyA_t3;

constraint profit = revenue - purchase_cost;


% Objective
solve maximize profit;