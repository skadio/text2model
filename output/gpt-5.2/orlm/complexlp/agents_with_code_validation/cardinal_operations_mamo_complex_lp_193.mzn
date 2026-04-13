% Maximize daily profit for two-product production with possible assembly overtime.
% Use integer arithmetic by scaling time to 24ths of an hour to avoid float constraints.

% Index set
int: nProducts = 2;
set of int: PRODUCTS = 1..nProducts;

% Time scaling: 1 unit = 1/24 hour
int: SCALE = 24;

% Per-unit requirements in scaled integer time units
% Product 1: assembly 1/4 = 6/24, testing 1/8 = 3/24
% Product 2: assembly 1/3 = 8/24, testing 1/3 = 8/24
array[PRODUCTS] of int: assemblyReq = [6, 8];
array[PRODUCTS] of int: testingReq  = [3, 8];

% Available capacities in scaled units
int: assemblyAvail = 90 * SCALE;            % 2160
int: testingAvail  = 80 * SCALE;            % 1920
int: maxOvertimeAssembly = 50 * SCALE;      % 1200

% Monetary scaling: cents
int: marketValue_c = 0; % dummy to emphasize cents used below (not required)

array[PRODUCTS] of int: revenue_c   = [900, 800];   % $9, $8
array[PRODUCTS] of int: rawCost_c   = [120, 90];    % $1.2, $0.9
array[PRODUCTS] of int: profitPerUnit_c = [780, 710];

% Overtime cost: $9 per hour = 900 cents/hour => 900/24 = 37.5 cents per scaled unit
% So per scaled unit (1/24 hr): 75/2 cents
int: OT_NUM = 75;  % numerator
int: OT_DEN = 2;   % denominator

% Decision variables
array[PRODUCTS] of var 0..100000: x;              % units produced
var 0..maxOvertimeAssembly: overtime;             % overtime assembly in scaled units (1/24 hr)

% Constraints
constraint sum(p in PRODUCTS)(assemblyReq[p] * x[p]) <= assemblyAvail + overtime;
constraint sum(p in PRODUCTS)(testingReq[p]  * x[p]) <= testingAvail;

% Objective in "half-cents" to avoid fractions:
% profit_halfc = 2 * (unit profits in cents) - overtime * 75
var int: profit_halfc =
  sum(p in PRODUCTS)( (2 * profitPerUnit_c[p]) * x[p] ) - OT_NUM * overtime;

solve maximize profit_halfc;

% Optional output: profit rounded to nearest dollar
% Convert half-cents -> cents: (profit_halfc / 2) with rounding to nearest cent,
% then to dollars: /100 with rounding to nearest dollar.
int: profit_c_rounded = (profit_halfc + 1) div 2;           % half-up to nearest cent
int: profit_dollars_rounded = (profit_c_rounded + 50) div 100; % nearest dollar

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " overtime_hours=",
  show(overtime / SCALE), ".", show((overtime mod SCALE) * 100 div SCALE), "\n",
  "profit_rounded_dollars=", show(profit_dollars_rounded), "\n"
];