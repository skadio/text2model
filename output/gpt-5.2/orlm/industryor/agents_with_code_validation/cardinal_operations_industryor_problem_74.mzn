% Parameters
% Processing times (hours per unit)
int: timeA_p1 = 2;        % Product A, process 1
int: timeA_p2 = 3;        % Product A, process 2
int: timeB_p1 = 3;        % Product B, process 1
int: timeB_p2 = 4;        % Product B, process 2

% Available processing time (hours)
int: avail_p1 = 16;       % Available time for process 1
int: avail_p2 = 24;       % Available time for process 2

% By-product C generation and sales/disposal limits/costs
int: c_per_B = 2;         % Units of C generated per unit of B
int: c_sell_cap = 5;      % Maximum units of C that can be sold
int: c_dispose_cost = 2;  % Disposal cost per unit of C (yuan)

% Profits (yuan per unit sold)
int: profitA = 4;         % Profit per unit of A sold
int: profitB = 10;        % Profit per unit of B sold
int: profitC = 3;         % Profit per unit of C sold

% Simple upper bounds for production/sales variables (derived from time limits)
int: maxA = min(avail_p1 div timeA_p1, avail_p2 div timeA_p2);  % max A if only A produced
int: maxB = min(avail_p1 div timeB_p1, avail_p2 div timeB_p2);  % max B if only B produced
int: maxC = c_per_B * maxB;                                     % max C generated if only B produced


% Variables
var 0..maxA: xA;              % Units of product A produced (and sold)
var 0..maxB: xB;              % Units of product B produced (and sold)

var 0..maxC: c_generated;     % Total units of by-product C generated
var 0..c_sell_cap: c_sold;    % Units of C sold (limited by market)
var 0..maxC: c_disposed;      % Units of C disposed

var int: total_profit;        % Objective: total profit (yuan)


% Constraints

% --- Processing capacity constraints (time availability) ---
constraint
  timeA_p1 * xA + timeB_p1 * xB <= avail_p1;   % Process 1 total time limit

constraint
  timeA_p2 * xA + timeB_p2 * xB <= avail_p2;   % Process 2 total time limit

% --- By-product C generation constraint ---
constraint
  c_generated = c_per_B * xB;                  % C is generated proportionally to production of B

% --- By-product C flow balance (generated = sold + disposed) ---
constraint
  c_sold + c_disposed = c_generated;           % All generated C is either sold or disposed

% --- Total profit definition (revenue - disposal cost) ---
constraint
  total_profit =
    profitA * xA +
    profitB * xB +
    profitC * c_sold -
    c_dispose_cost * c_disposed;               % Disposal incurs a cost


% Objective
solve maximize total_profit;