% Parameters
int: n_investments = 4; % Number of investment categories
set of int: INVESTMENTS = 1..n_investments; % Index set for categories

% Indices (fixed mapping):
% 1 = Stocks, 2 = Bonds, 3 = Mutual Funds, 4 = Derivatives
array[INVESTMENTS] of int: risk_per_k = [3, 4, 2, 5]; % Risk score per $1K invested

int: min_stocks_bonds = 1000;     % Stocks + Bonds >= 1000 ($K)
int: max_diff_mutual_deriv = 500; % |Mutual - Deriv| <= 500 ($K)
int: min_stocks_over_mutual = 200;% Stocks - Mutual >= 200 ($K)
int: eq_bonds_deriv = 1500;       % Bonds + Deriv = 1500 ($K)

% Variables
array[INVESTMENTS] of var 0..3000: invest_k; % Investment amounts in $K (non-negative, integer)
var 0..(5 * 3000 * n_investments): total_risk; % Total portfolio risk score (bounded)

% Convenience variables for readability (aliases into invest_k)
var 0..3000: stocks = invest_k[1];
var 0..3000: bonds = invest_k[2];
var 0..3000: mutual_funds = invest_k[3];
var 0..3000: derivatives = invest_k[4];

% Constraints

% --- Total risk definition (linear aggregation of per-$K risks) ---
constraint
  total_risk = sum(i in INVESTMENTS)(risk_per_k[i] * invest_k[i]);

% --- Client preference: Stocks + Bonds must be at least the required minimum ---
constraint
  stocks + bonds >= min_stocks_bonds;

% --- Regulatory/Preference: Mutual Funds and Derivatives difference bounded ---
constraint
  abs(mutual_funds - derivatives) <= max_diff_mutual_deriv;

% --- Preference: Stocks exceed Mutual Funds by at least the required margin ---
constraint
  stocks - mutual_funds >= min_stocks_over_mutual;

% --- Regulatory requirement: Bonds + Derivatives must equal the required total ---
constraint
  bonds + derivatives = eq_bonds_deriv;

% Objective
solve minimize total_risk;