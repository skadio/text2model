% Parameters
int: nSecurities = 5;                 % number of securities
int: nCountries  = 5;                 % number of countries (states)

set of int: SEC = 1..nSecurities;     % security index set
set of int: CTRY = 1..nCountries;     % country/state index set

% Country order: 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain
array[SEC] of float: price =          % purchase price per share
  [0.75, 0.35, 0.40, 0.75, 0.65];

array[SEC] of int: shareLimit =       % maximum shares purchasable
  [10, 5, 10, 10, 5];

% payoff[s,c] is $ payoff per share of security s if country/state c wins
array[SEC, CTRY] of int: payoff =
  [| 1, 1, 1, 0, 0  % Security 1: A,B,E pay 1; G,S pay 0
   | 0, 0, 0, 1, 1  % Security 2: G,S pay 1
   | 1, 0, 1, 0, 1  % Security 3: A,E,S pay 1
   | 1, 1, 1, 1, 0  % Security 4: all except Spain
   | 0, 1, 0, 1, 1  % Security 5: B,G,S pay 1
  |];

% Variables
array[SEC] of var int: shares;        % number of shares purchased of each security
var float: worstCaseRevenue;          % minimum (over countries) of net revenue
array[CTRY] of var float: revenue;    % net revenue in each country/state

% Constraints

% --- Share bounds (cannot buy negative shares; must respect per-security limits) ---
constraint
  forall(s in SEC) (
    0 <= shares[s] /\ shares[s] <= shareLimit[s]
  );

% --- Revenue definition per country/state: payoff minus purchase cost ---
% revenue[c] = sum_s (shares[s] * payoff[s,c]) - sum_s (shares[s] * price[s])
constraint
  forall(c in CTRY) (
    revenue[c] =
      sum(s in SEC)( int2float(shares[s] * payoff[s,c]) )
      - sum(s in SEC)( int2float(shares[s]) * price[s] )
  );

% --- Worst-case revenue definition: worstCaseRevenue is <= each state's revenue ---
constraint
  forall(c in CTRY) (
    worstCaseRevenue <= revenue[c]
  );

% Objective
solve maximize worstCaseRevenue;