% Parameters
% Problem constants (embedded as per instructions)
int: max_total_units = 50;                 % Total investment across all property types cannot exceed this
int: min_weighted_investment = 30;         % 2*x + 3*y + z must be at least this
int: max_diff_res_comm = 10;               % |x - y| <= 10
int: min_comm_over_ind = 5;                % y >= z + 5

int: cost_residential = 500;               % Cost per unit of residential investment
int: cost_commercial  = 700;               % Cost per unit of commercial investment
int: cost_industrial  = 900;               % Cost per unit of industrial investment

% Note: "individual upper limits on each type" are mentioned but not specified numerically.
% Only the global max_total_units is used for variable bounds.

% Variables
var 0..max_total_units: x;                 % Units invested in residential properties (integer)
var 0..max_total_units: y;                 % Units invested in commercial properties (integer)
var 0..max_total_units: z;                 % Units invested in industrial properties (integer)

var 0..(max_total_units * max([cost_residential, cost_commercial, cost_industrial])): total_cost;
                                            % Total cost (bounded by worst-case per-unit cost)

% Constraints

%-----------------------------
% Total units (budget) constraint
%-----------------------------
constraint
  x + y + z <= max_total_units;

%-----------------------------
% Balanced portfolio (weighted investment) constraint
% Ensures: 2*x + 3*y + z >= minimum required
%-----------------------------
constraint
  2 * x + 3 * y + z >= min_weighted_investment;

%-----------------------------
% Risk control: residential vs commercial difference bound
% Ensures: |x - y| <= max_diff_res_comm
%-----------------------------
constraint
  abs(x - y) <= max_diff_res_comm;

%-----------------------------
% Return preference: commercial exceeds industrial by at least a margin
% Ensures: y >= z + min_comm_over_ind
%-----------------------------
constraint
  y >= z + min_comm_over_ind;

%-----------------------------
% Total cost definition
%-----------------------------
constraint
  total_cost = cost_residential * x + cost_commercial * y + cost_industrial * z;

% Objective
solve minimize total_cost;