% Parameters
% Resource usage per container
int: a_per_max = 46;        % grams of substance A used by one Oil Max
int: b_per_max = 43;        % grams of substance B used by one Oil Max
int: c_per_max = 56;        % grams of substance C used by one Oil Max

int: a_per_pro = 13;        % grams of substance A used by one Oil Max Pro
int: b_per_pro = 4;         % grams of substance B used by one Oil Max Pro
int: c_per_pro = 45;        % grams of substance C used by one Oil Max Pro

% Available resources
int: a_avail = 1345;        % total grams of substance A available
int: b_avail = 346;         % total grams of substance B available
int: c_avail = 1643;        % total grams of substance C available

% Profit per container
int: profit_max = 10;       % profit ($) per Oil Max container
int: profit_pro = 15;       % profit ($) per Oil Max Pro container

% Simple upper bounds derived from resources (to bound decision variables)
int: ub_max = min(a_avail div a_per_max, min(b_avail div b_per_max, c_avail div c_per_max));
int: ub_pro = min(a_avail div a_per_pro, min(b_avail div b_per_pro, c_avail div c_per_pro));

% Variables
var 0..ub_max: n_max;       % number of Oil Max containers to produce
var 0..ub_pro: n_pro;       % number of Oil Max Pro containers to produce

var 0..(profit_max * ub_max + profit_pro * ub_pro): total_profit; % total profit ($)

% Constraints
% Link total_profit to production quantities (profit accounting)
constraint
  total_profit = profit_max * n_max + profit_pro * n_pro;

% Substance A availability constraint
constraint
  a_per_max * n_max + a_per_pro * n_pro <= a_avail;

% Substance B availability constraint
constraint
  b_per_max * n_max + b_per_pro * n_pro <= b_avail;

% Substance C availability constraint
constraint
  c_per_max * n_max + c_per_pro * n_pro <= c_avail;

% Objective
solve maximize total_profit;