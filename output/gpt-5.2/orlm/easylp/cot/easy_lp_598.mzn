% Parameters (with values embedded)
int: risk_stocks = 3;
int: risk_bonds = 4;
int: risk_mutual = 2;
int: risk_deriv = 5;

int: min_stocks_bonds = 1000;      % in $K
int: max_diff_mutual_deriv = 500;  % in $K
int: min_stocks_over_mutual = 200; % in $K
int: bonds_plus_deriv_eq = 1500;   % in $K

% Variable upper bounds (safe finite bounds derived from constraints)
int: U = 3000; % $K

% Variables
var 0..U: Stocks;       % in $K
var 0..U: Bonds;        % in $K
var 0..U: MutualFunds;  % in $K
var 0..U: Derivatives;  % in $K

var 0..(risk_stocks*U + risk_bonds*U + risk_mutual*U + risk_deriv*U): TotalRisk;

% Constraints
constraint TotalRisk =
  risk_stocks*Stocks + risk_bonds*Bonds + risk_mutual*MutualFunds + risk_deriv*Derivatives;

constraint Stocks + Bonds >= min_stocks_bonds;

constraint abs(MutualFunds - Derivatives) <= max_diff_mutual_deriv;

constraint Stocks - MutualFunds >= min_stocks_over_mutual;

constraint Bonds + Derivatives = bonds_plus_deriv_eq;

% Objective
solve minimize TotalRisk;