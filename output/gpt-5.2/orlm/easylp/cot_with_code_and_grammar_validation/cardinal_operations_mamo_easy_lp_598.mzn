% Parameters
int: risk_stocks = 3;
int: risk_bonds = 4;
int: risk_mutual = 2;
int: risk_deriv = 5;

int: min_stocks_plus_bonds = 1000;     % in $K
int: max_diff_mutual_deriv = 500;      % in $K
int: min_stocks_minus_mutual = 200;    % in $K
int: bonds_plus_deriv_eq = 1500;       % in $K

% Variables
var 0..100000: stocks;        % in $K
var 0..100000: bonds;         % in $K
var 0..100000: mutual_funds;  % in $K
var 0..100000: derivatives;   % in $K

var 0..1000000: total_risk;

% Constraints
constraint stocks + bonds >= min_stocks_plus_bonds;
constraint abs(mutual_funds - derivatives) <= max_diff_mutual_deriv;
constraint stocks - mutual_funds >= min_stocks_minus_mutual;
constraint bonds + derivatives = bonds_plus_deriv_eq;

constraint total_risk =
  risk_stocks * stocks +
  risk_bonds * bonds +
  risk_mutual * mutual_funds +
  risk_deriv * derivatives;

% Objective
solve minimize total_risk;