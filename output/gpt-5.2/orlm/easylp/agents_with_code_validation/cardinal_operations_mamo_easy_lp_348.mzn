% Parameters
int: nPortfolios = 4;                               % Number of portfolios (X,Y,Z,W)
set of int: P = 1..nPortfolios;                     % Portfolio index set

int: totalFund = 100000;                            % Total investment fund (dollars)

array[P] of float: feeRate = [0.05, 0.07, 0.06, 0.09];    % Annual fee rates for X,Y,Z,W
array[P] of int:   minInvest = [20000, 15000, 25000, 40000]; % Minimum investments for X,Y,Z,W

% Variables
array[P] of var 0..totalFund: invest;               % Investment in each portfolio (whole dollars)
var 0.0..(max(feeRate) * int2float(totalFund)): totalFee; % Total annual management fee (dollars, float)
var int: totalFeeRounded;                            % Total fee rounded to nearest dollar (for reporting)

% Constraints
% Fund allocation: invest the entire available fund across all portfolios
constraint
  sum(p in P)(invest[p]) = totalFund;

% Minimum investment requirements: enforce minimum allocation per portfolio
constraint
  forall(p in P)(
    invest[p] >= minInvest[p]
  );

% Total management fee definition: weighted sum of investments by fee rates
constraint
  totalFee = sum(p in P)(
    feeRate[p] * int2float(invest[p])
  );

% Rounded total fee (nearest dollar) for reporting
constraint
  totalFeeRounded = round(totalFee);

% Objective
solve minimize totalFee;

output [
  "invest = ", show(invest), "\n",
  "totalFee = ", show(totalFee), "\n",
  "totalFeeRounded = ", show(totalFeeRounded), "\n"
];