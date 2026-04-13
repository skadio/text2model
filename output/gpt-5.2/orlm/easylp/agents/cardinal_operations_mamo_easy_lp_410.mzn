% Parameters
int: nProps = 4;                           % Number of property types
set of int: PROPS = 1..nProps;             % Index set for properties

% Property type indices (for readability)
int: RES = 1;
int: COM = 2;
int: IND = 3;
int: REC = 4;

array[PROPS] of int: cost = [5, 7, 3, 4];  % Cost per unit investment

int: total_invest_max = 100;               % Total investment upper bound

% Constraint 2 coefficients: x1 + 4x2 + x3 + 2x4 >= 50
array[PROPS] of int: a_div = [1, 4, 1, 2];
int: div_min = 50;

% Constraint 3 coefficients: 3x1 + 1x2 + 2x3 + 1x4 == 75
array[PROPS] of int: a_eq = [3, 1, 2, 1];
int: eq_rhs = 75;

% Per-property maximum investment limits
array[PROPS] of int: max_invest = [40, 50, 30, 20];

% Variables
array[PROPS] of var int: x;                % Investment units in each property type (integer)
var int: total_cost;                       % Total investment cost (integer dollars)

% Constraints

% Investment bounds: nonnegative and per-property maximum limits
constraint
  forall(p in PROPS) (
    0 <= x[p] /\ x[p] <= max_invest[p]
  );

% Total investment budget: sum of all investments cannot exceed the maximum
constraint
  sum(p in PROPS)(x[p]) <= total_invest_max;

% Diversification constraint: weighted sum must be at least the minimum required
constraint
  sum(p in PROPS)(a_div[p] * x[p]) >= div_min;

% Market equality constraint: weighted sum must match the required exact total
constraint
  sum(p in PROPS)(a_eq[p] * x[p]) = eq_rhs;

% Total cost definition: link total_cost to decision variables and costs
constraint
  total_cost = sum(p in PROPS)(cost[p] * x[p]);

% Objective
solve minimize total_cost;