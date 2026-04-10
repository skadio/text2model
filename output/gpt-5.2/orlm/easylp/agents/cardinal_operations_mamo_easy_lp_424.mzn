% Parameters
% Coefficients for capacity constraint: 10*X1 + 15*X2 <= 2000
int: cap_a1 = 10;
int: cap_a2 = 15;
int: cap_rhs = 2000;

% Coefficients for minimum productivity constraint: 12*X1 + 6*X2 >= 800
int: prod_a1 = 12;
int: prod_a2 = 6;
int: prod_rhs = 800;

% Balanced line constraint: X1 - 0.5*X2 <= 100
% (Scaled to avoid fractions): 2*X1 - X2 <= 200
int: bal_a1 = 2;
int: bal_a2 = -1;
int: bal_rhs = 200;

% Unit costs
int: cost_x1 = 50;
int: cost_x2 = 75;

% Variable bounds (non-negative production quantities)
int: lb_prod = 0;
int: ub_x1 = cap_rhs div cap_a1; % upper bound from capacity with X2 = 0
int: ub_x2 = cap_rhs div cap_a2; % upper bound from capacity with X1 = 0


% Variables
var lb_prod..ub_x1: x1; % integer units of product X1
var lb_prod..ub_x2: x2; % integer units of product X2

var int: total_cost;    % total cost in dollars (integer)


% Constraints
%--- Machine capacity constraint: 10*X1 + 15*X2 <= 2000
constraint cap_a1 * x1 + cap_a2 * x2 <= cap_rhs;

%--- Minimum productivity constraint: 12*X1 + 6*X2 >= 800
constraint prod_a1 * x1 + prod_a2 * x2 >= prod_rhs;

%--- Balanced production line constraint (scaled): 2*X1 - X2 <= 200
constraint bal_a1 * x1 + bal_a2 * x2 <= bal_rhs;

%--- Define total cost from unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2;


% Objective
solve minimize total_cost;