% Parameters
% Risk score per 1K investment unit in each category (given in problem)
int: risk_stocks      = 3;
int: risk_bonds       = 4;
int: risk_mutualFunds = 2;
int: risk_derivatives = 5;

% Constraint constants (all amounts in thousand dollars, i.e., K)
int: min_stocks_plus_bonds   = 1000;
int: max_diff_mutual_deriv   = 500;
int: min_stocks_minus_mutual = 200;
int: bonds_plus_deriv_eq     = 1500;

% A safe upper bound for each investment variable (in K)
int: UB = 3000;

% Variables
var 0..UB: invest_stocks;       % Investment in Stocks (K)
var 0..UB: invest_bonds;        % Investment in Bonds (K)
var 0..UB: invest_mutualFunds;  % Investment in Mutual Funds (K)
var 0..UB: invest_derivatives;  % Investment in Derivatives (K)

% Total risk (upper bound based on UB)
var 0..(risk_stocks*UB + risk_bonds*UB + risk_mutualFunds*UB + risk_derivatives*UB): total_risk;

% Constraints
% --- Total risk definition (linear expression) ---
constraint
  total_risk =
    risk_stocks      * invest_stocks +
    risk_bonds       * invest_bonds +
    risk_mutualFunds * invest_mutualFunds +
    risk_derivatives * invest_derivatives;

% --- Minimum combined investment in Stocks and Bonds ---
constraint
  invest_stocks + invest_bonds >= min_stocks_plus_bonds;

% --- Mutual Funds vs Derivatives difference bounded (absolute difference) ---
constraint
  abs(invest_mutualFunds - invest_derivatives) <= max_diff_mutual_deriv;

% --- Stocks must exceed Mutual Funds by at least a given amount ---
constraint
  invest_stocks - invest_mutualFunds >= min_stocks_minus_mutual;

% --- Exact sum of Bonds and Derivatives ---
constraint
  invest_bonds + invest_derivatives = bonds_plus_deriv_eq;

% Objective
solve minimize total_risk;