% Parameters
% Limits and thresholds
int: max_total_allocation = 5000;           % Total allocation across all channels cannot exceed this
int: min_effectiveness_x1 = 1000;           % Minimum required effectiveness for channel X1 expression
int: max_effectiveness_x2x3 = 4000;         % Maximum allowed effectiveness for combined X2 and X3 expression

% Coefficients (scaled by 2 to avoid decimals: 2.5, 4.5, 1.5)
int: scale = 2;                             % Common scale factor to linearize fractional coefficients

% Effectiveness coefficients (scaled)
% 5*x1 - 2.5*x2 >= 1000  ==>  10*x1 - 5*x2 >= 2000
int: eff_x1_x1 = 5 * scale;                 % 10
int: eff_x1_x2_scaled = -5;                 % -5
int: eff_x1_rhs = min_effectiveness_x1 * scale;  % 2000

% Combined effectiveness coefficients (scaled)
% 3*x2 + 4.5*x3 <= 4000  ==>  6*x2 + 9*x3 <= 8000
int: eff_x23_x2 = 3 * scale;                % 6
int: eff_x23_x3 = 9;                        % 9
int: eff_x23_rhs = max_effectiveness_x2x3 * scale; % 8000

% Balance coefficients (scaled)
% x1 - 1.5*x2 = x3  ==>  2*x1 - 3*x2 = 2*x3  ==>  2*x1 - 3*x2 - 2*x3 = 0
int: bal_x1 = 2;
int: bal_x2 = -3;
int: bal_x3 = -2;

% Unit costs
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;


% Variables
var 0..max_total_allocation: x1;            % Integer allocation to channel X1
var 0..max_total_allocation: x2;            % Integer allocation to channel X2
var 0..max_total_allocation: x3;            % Integer allocation to channel X3

var 0..(cost_x1*max_total_allocation + cost_x2*max_total_allocation + cost_x3*max_total_allocation): total_cost;


% Constraints
% Total allocation limit across all channels
constraint x1 + x2 + x3 <= max_total_allocation;

% Minimum effectiveness requirement for channel X1 (scaled)
% 10*x1 - 5*x2 >= 2000
constraint eff_x1_x1 * x1 + eff_x1_x2_scaled * x2 >= eff_x1_rhs;

% Maximum combined effectiveness for channels X2 and X3 (scaled)
% 6*x2 + 9*x3 <= 8000
constraint eff_x23_x2 * x2 + eff_x23_x3 * x3 <= eff_x23_rhs;

% Balance requirement between allocations (scaled)
% 2*x1 - 3*x2 - 2*x3 = 0
constraint bal_x1 * x1 + bal_x2 * x2 + bal_x3 * x3 = 0;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;