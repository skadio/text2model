% Parameters
int: risk_stocks = 3;
int: risk_bonds = 4;
int: risk_mutual = 2;
int: risk_deriv = 5;

int: min_stocks_bonds = 1000;      % in $K
int: max_diff_mutual_deriv = 500;  % in $K
int: min_stocks_over_mutual = 200; % in $K
int: bonds_deriv_sum = 1500;       % in $K

% Safe upper bounds (in $K) derived from constraints:
% B + D = 1500 => 0..1500 each
% S + B >= 1000 with B<=1500; also from S >= M+200 and |M-D|<=500 with D<=1500 => M<=2000 => S<=2200
int: ub_stocks = 2200;
int: ub_mutual = 2000;
int: ub_bonds = 1500;
int: ub_deriv = 1500;

% Variables
var 0..ub_stocks: S; % Stocks ($K)
var 0..ub_bonds:  B; % Bonds ($K)
var 0..ub_mutual: M; % Mutual Funds ($K)
var 0..ub_deriv:  D; % Derivatives ($K)

var 0..(risk_stocks*ub_stocks + risk_bonds*ub_bonds + risk_mutual*ub_mutual + risk_deriv*ub_deriv): total_risk;

% Constraints
constraint S + B >= min_stocks_bonds;

constraint M - D <= max_diff_mutual_deriv;
constraint D - M <= max_diff_mutual_deriv;

constraint S - M >= min_stocks_over_mutual;

constraint B + D = bonds_deriv_sum;

constraint total_risk = risk_stocks*S + risk_bonds*B + risk_mutual*M + risk_deriv*D;

% Objective
solve minimize total_risk;