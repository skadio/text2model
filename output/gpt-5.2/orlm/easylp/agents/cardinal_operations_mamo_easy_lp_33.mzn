% Parameters
int: min_invest_X = 5000;              % Minimum investment in option X ($)
int: min_invest_Y = 2000;              % Minimum investment in option Y ($)
int: max_total_invest = 10000;         % Maximum total investment ($)

float: yield_rate_X = 0.07;            % Interest yield rate for X
float: yield_rate_Y = 0.08;            % Interest yield rate for Y
float: min_interest_income = 700.0;    % Minimum required interest income ($)

float: tx_cost_per_dollar_X = 0.01;    % Transaction cost per $ invested in X
float: tx_cost_per_dollar_Y = 0.02;    % Transaction cost per $ invested in Y

% Variables
var min_invest_X..max_total_invest: invest_X;  % Investment amount in X ($), integer
var min_invest_Y..max_total_invest: invest_Y;  % Investment amount in Y ($), integer

var 0.0..(tx_cost_per_dollar_X * max_total_invest
        + tx_cost_per_dollar_Y * max_total_invest): total_tx_cost; % Total transaction cost ($)

% Constraints

%--- Investment budget constraints ---
constraint
  invest_X + invest_Y <= max_total_invest;   % Total investment cannot exceed budget

%--- Minimum interest income constraint ---
constraint
  yield_rate_X * int2float(invest_X) + yield_rate_Y * int2float(invest_Y)
    >= min_interest_income;                  % Required minimum interest income

%--- Transaction cost definition constraint ---
constraint
  total_tx_cost =
    tx_cost_per_dollar_X * int2float(invest_X)
  + tx_cost_per_dollar_Y * int2float(invest_Y); % Total transaction cost from both investments

% Objective
solve minimize total_tx_cost;

% Output (includes cost rounded to 2 decimals)
output [
  "invest_X=", show(invest_X), "\n",
  "invest_Y=", show(invest_Y), "\n",
  "total_tx_cost=", show(total_tx_cost), "\n",
  "total_tx_cost_rounded_2dp=",
    show(fix(total_tx_cost * 100.0 + 0.5) / 100.0), "\n"
];