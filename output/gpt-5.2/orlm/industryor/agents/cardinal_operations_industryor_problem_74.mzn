% Parameters
% Processing times (hours per unit)
int: timeA_p1 = 2;
int: timeA_p2 = 3;
int: timeB_p1 = 3;
int: timeB_p2 = 4;

% Available processing time (hours)
int: cap_p1 = 16;
int: cap_p2 = 24;

% By-product generation and limits
int: c_per_B = 2;          % units of C generated per unit of B
int: c_sell_cap = 5;       % maximum units of C that can be sold

% Profits / costs (yuan per unit)
int: profit_A = 4;
int: profit_B = 10;
int: profit_C_sell = 3;
int: cost_C_dispose = 2;


% Variables
var int: xA;        % units of product A produced/sold
var int: xB;        % units of product B produced/sold
var int: cSold;     % units of by-product C sold
var int: cDisposed; % units of by-product C disposed

% Total profit to maximize (linear expression)
var int: totalProfit;


% Constraints
%--- Non-negativity (feasible production and handling amounts)
constraint xA >= 0;
constraint xB >= 0;
constraint cSold >= 0;
constraint cDisposed >= 0;

%--- Process capacity limits (time availability in each successive process)
constraint timeA_p1 * xA + timeB_p1 * xB <= cap_p1;  % process 1 capacity
constraint timeA_p2 * xA + timeB_p2 * xB <= cap_p2;  % process 2 capacity

%--- By-product C accounting and sales limit
constraint cSold + cDisposed = c_per_B * xB;  % all generated C is either sold or disposed
constraint cSold <= c_sell_cap;               % sales capped by market limit

%--- Total profit definition (revenues minus disposal costs)
constraint totalProfit =
    profit_A * xA
  + profit_B * xB
  + profit_C_sell * cSold
  - cost_C_dispose * cDisposed;


% Objective
solve maximize totalProfit;