% Parameters
int: risk_stocks = 3;
int: risk_bonds = 4;
int: risk_mutual = 2;
int: risk_deriv = 5;

int: min_stocks_bonds = 1000;      % K$
int: max_diff_mutual_deriv = 500;  % K$
int: min_stocks_over_mutual = 200; % K$
int: bonds_deriv_sum = 1500;       % K$

% Variables
var 0..5000: stocks;      % K$
var 0..5000: bonds;       % K$
var 0..5000: mutual;      % K$
var 0..5000: deriv;       % K$

var 0..100000: total_risk;

% Constraints
constraint stocks + bonds >= min_stocks_bonds;
constraint abs(mutual - deriv) <= max_diff_mutual_deriv;
constraint stocks - mutual >= min_stocks_over_mutual;
constraint bonds + deriv = bonds_deriv_sum;

constraint total_risk =
  risk_stocks * stocks +
  risk_bonds  * bonds +
  risk_mutual * mutual +
  risk_deriv  * deriv;

% Objective
solve minimize total_risk;