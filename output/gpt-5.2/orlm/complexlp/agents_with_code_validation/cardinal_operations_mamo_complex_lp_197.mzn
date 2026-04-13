% Parameters
% Sets
int: nSecurities = 5;
set of int: SEC = 1..nSecurities;

int: nCountries = 5;
set of int: CTR = 1..nCountries;

% Country indices (for readability)
int: ARG = 1;
int: BRA = 2;
int: ENG = 3;
int: GER = 4;
int: SPA = 5;

% Security prices (per share)
array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];

% Share limits (max shares purchasable of each security)
array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

% Payoff per share of each security contingent on country winning (0/1 dollars)
% payoff[s,c] = payoff of security s if country c wins
array[SEC, CTR] of int: payoff =
  array2d(SEC, CTR,
    [
      % c: ARG BRA ENG GER SPA
         1,  1,  1,  0,  0,   % Security 1
         0,  0,  0,  1,  1,   % Security 2
         1,  0,  1,  0,  1,   % Security 3
         1,  1,  1,  1,  0,   % Security 4
         0,  1,  0,  1,  1    % Security 5
    ]
  );

% Derived bounds (used to bound decision variables)
float: maxTotalPayoff = sum(s in SEC)(int2float(shareLimit[s]));          % each share pays at most 1
float: maxTotalCost   = sum(s in SEC)(price[s] * int2float(shareLimit[s]));
float: profit_ub      = maxTotalPayoff - maxTotalCost;                    % profit can't exceed this

% Variables
% Number of shares purchased of each security
array[SEC] of var 0..max(shareLimit): shares;

% Worst-case (minimum over countries) net revenue (payoff - cost)
var -ceil(maxTotalCost)..ceil(profit_ub): worst_case_revenue;

% Helper: revenue in each country outcome (float because prices are float)
array[CTR] of var float: revenue;


% Constraints

% --- Share-purchase bounds (respect per-security share limits) ---
constraint
  forall(s in SEC) (
    shares[s] <= shareLimit[s]
  );

% --- Revenue definition per country outcome ---
% revenue[c] = total payoff in country c minus total purchase cost
constraint
  forall(c in CTR) (
    revenue[c]
    =
    sum(s in SEC)( int2float(payoff[s,c]) * int2float(shares[s]) )
    -
    sum(s in SEC)( price[s] * int2float(shares[s]) )
  );

% --- Worst-case revenue definition (minimum across countries) ---
% worst_case_revenue <= revenue[c] for all c, so maximizing it yields the min revenue
constraint
  forall(c in CTR) (
    int2float(worst_case_revenue) <= revenue[c]
  );


% Objective
solve maximize worst_case_revenue;