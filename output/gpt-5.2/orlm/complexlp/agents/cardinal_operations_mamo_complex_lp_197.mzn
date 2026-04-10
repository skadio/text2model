% Parameters
int: nSecurities = 5;                 % number of securities
int: nOutcomes = 5;                   % number of World Cup outcomes (countries)

set of int: SEC = 1..nSecurities;     % securities index set
set of int: OUT = 1..nOutcomes;       % outcomes index set

array[OUT] of string: country =       % outcome names (for readability)
  ["Argentina","Brazil","England","Germany","Spain"];

array[SEC] of float: price =          % purchase price per share
  [0.75, 0.35, 0.40, 0.75, 0.65];

array[SEC] of int: shareLimit =       % maximum shares purchasable for each security
  [10, 5, 10, 10, 5];

% payoff[o,s] = payoff (in dollars) of 1 share of security s if outcome o occurs
% Outcome order: Argentina, Brazil, England, Germany, Spain
array[OUT, SEC] of int: payoff =
  [| 1, 0, 1, 1, 0   % Argentina
   | 1, 0, 0, 1, 1   % Brazil
   | 1, 0, 1, 1, 0   % England
   | 0, 1, 0, 1, 1   % Germany
   | 0, 1, 1, 0, 1   % Spain
  |];

% Variables
array[SEC] of var 0..10: shares;        % shares purchased of each security
array[OUT] of var float: revenue_outcome; % net revenue per outcome
var float: worst_case_revenue;          % minimum net revenue across outcomes (to maximize)

% Constraints

% --- Outcome revenue definitions (net revenue per outcome) ---
% Net revenue in outcome o = total payoff received - total purchase cost
constraint forall(o in OUT) (
  revenue_outcome[o] =
    sum(s in SEC) ( float(payoff[o,s]) * shares[s] )
    - sum(s in SEC) ( price[s] * shares[s] )
);

% --- Share limit constraints (per-security purchase caps) ---
constraint forall(s in SEC) (
  shares[s] <= shareLimit[s]
);

% --- Worst-case revenue definition (lower bound across all outcomes) ---
% worst_case_revenue is constrained to be <= every outcome's revenue,
% so maximizing it will make it equal to the minimum revenue across outcomes.
constraint forall(o in OUT) (
  worst_case_revenue <= revenue_outcome[o]
);

% Objective
solve maximize worst_case_revenue;