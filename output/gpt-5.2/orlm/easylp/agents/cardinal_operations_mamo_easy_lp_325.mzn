% Parameters
% Rates of return per unit investment (in dollars)
int: return_residential = 100;
int: return_commercial  = 200;
int: return_industrial  = 300;

% Budget and policy/risk constraints
int: max_total_investment = 50;   % x + y + z <= 50
int: min_diversification  = 30;   % 2x + y >= 30
int: max_comm_ind_sum     = 20;   % y + z <= 20

% No specific per-investment bounds were numerically provided; use non-negative bounds
% capped by the total investment limit.
int: lb_investment = 0;
int: ub_investment = max_total_investment;

% Variables
var lb_investment..ub_investment: x; % units invested in residential
var lb_investment..ub_investment: y; % units invested in commercial
var lb_investment..ub_investment: z; % units invested in industrial

% Total return (dollars)
var 0..(return_residential*ub_investment
      + return_commercial*ub_investment
      + return_industrial*ub_investment): total_return;

% Constraints
% Link total_return to the investment decisions and per-unit returns
constraint
  total_return =
    return_residential * x +
    return_commercial  * y +
    return_industrial  * z;

% Budget constraint
constraint x + y + z <= max_total_investment;

% Diversification constraint
constraint 2 * x + y >= min_diversification;

% Risk/regulatory constraint
constraint y + z <= max_comm_ind_sum;

% Objective
solve minimize total_return;