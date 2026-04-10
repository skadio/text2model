% Investment allocation problem (all data embedded)

% Parameters
int: total_investment = 1000000;
int: n_funds = 3;
set of int: FUNDS = 1..n_funds;

array[FUNDS] of int: min_invest = [200000, 150000, 250000]; % X, Y, Z

% Use basis points (1/100 of a percent) to keep everything integral and avoid overflow:
% 2% = 200 bp, 3% = 300 bp, 4% = 400 bp
array[FUNDS] of int: rate_bp = [200, 300, 400];

% Variables
array[FUNDS] of var int: invest;
var int: total_return_cents;

% Domains
constraint forall(f in FUNDS) (0 <= invest[f] /\ invest[f] <= total_investment);

% Constraints
constraint forall(f in FUNDS) (invest[f] >= min_invest[f]);
constraint sum(f in FUNDS) (invest[f]) = total_investment;

% Return in cents:
% return = invest * (rate_bp / 10000) dollars
% cents = dollars * 100 = invest * rate_bp / 100
constraint total_return_cents = sum(f in FUNDS) (invest[f] * rate_bp[f] div 100);

% Objective
solve minimize total_return_cents;

% Output (rounded to nearest dollar; here cents are integral already)
output [
  "Investments: ", show(invest), "\n",
  "Total return (cents): ", show(total_return_cents), "\n",
  "Total return (dollars, rounded): ", show((total_return_cents + 50) div 100), "\n"
];