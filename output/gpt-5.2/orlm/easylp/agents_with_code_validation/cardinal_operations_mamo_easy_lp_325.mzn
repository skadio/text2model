% Parameters
% Rates of return per unit investment (in dollars)
int: return_residential = 100;
int: return_commercial  = 200;
int: return_industrial  = 300;

% Budget and policy/regulatory limits (in units)
int: max_total_investment = 50;
int: min_diversification  = 30;  % 2*x + y >= 30
int: max_com_ind_sum      = 20;  % y + z <= 20

% Bounds on each investment type (units); assume nonnegative
int: min_investment = 0;
int: max_investment = max_total_investment;


% Variables
var min_investment..max_investment: x; % residential investment units
var min_investment..max_investment: y; % commercial investment units
var min_investment..max_investment: z; % industrial investment units

var int: total_return; % total return in dollars


% Constraints
% Total budget limit: x + y + z <= 50
constraint x + y + z <= max_total_investment;

% Diversification requirement: 2*x + y >= 30
constraint 2 * x + y >= min_diversification;

% Regulatory/risk cap: y + z <= 20
constraint y + z <= max_com_ind_sum;

% Define total return from investments
constraint
  total_return = return_residential * x
               + return_commercial  * y
               + return_industrial  * z;


% Objective
solve minimize total_return;