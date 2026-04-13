% Parameters
int: total_acres = 1000;              % Total available farm acres
int: revenue_wheat = 2;               % Revenue per acre of wheat ($/acre)
int: revenue_corn  = 3;               % Revenue per acre of corn ($/acre)
int: revenue_barley= 1;               % Revenue per acre of barley ($/acre)

% Constraint constants derived from the description
int: min_wheat_expr_rhs = 500;        % For: 2*wheat + corn >= 500
int: barley_expr_rhs    = 600;        % For: wheat + 2*barley <= 600

% Variables
var 0..total_acres: acres_wheat;      % Acres allocated to wheat (integer acres)
var 0..total_acres: acres_corn;       % Acres allocated to corn (integer acres)
var 0..total_acres: acres_barley;     % Acres allocated to barley (integer acres)

% Upper bound on revenue is achieved by planting all acres with the highest revenue crop (corn)
var 0..(revenue_corn * total_acres): total_revenue;  % Total revenue in dollars (integer)

% Constraints
% Land availability: total planted area cannot exceed the farm size
constraint land_use_limit:
  acres_wheat + acres_corn + acres_barley <= total_acres;

% Wheat requirement: ensure sufficient wheat relative to wheat+corn mix
% As given: 2*wheat + corn >= 500
constraint wheat_minimum_expression:
  2 * acres_wheat + acres_corn >= min_wheat_expr_rhs;

% Barley limitation: cap barley relative to wheat+barley mix
% As given: wheat + 2*barley <= 600
constraint barley_maximum_expression:
  acres_wheat + 2 * acres_barley <= barley_expr_rhs;

% Revenue definition: total revenue from all planted acres
constraint total_revenue_definition:
  total_revenue =
    revenue_wheat * acres_wheat +
    revenue_corn  * acres_corn  +
    revenue_barley * acres_barley;

% Objective
solve minimize total_revenue;