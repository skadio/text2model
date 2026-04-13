% Parameters
int: cost_W = 3;              % Cost per unit investment in Warehouse (W)
int: cost_T = 2;              % Cost per unit investment in Transport (T)
int: cost_R = 4;              % Cost per unit investment in Retail (R)

int: min_WT = 500;            % Minimum combined investment in W and T
int: max_diff_WR = 2000;      % Maximum allowed difference between W and R (|W - R|)
int: sum_WR = 3000;           % Required total investment in W and R

% Variables
var 0..sum_WR: W;             % Investment in Warehouse (non-negative; bounded by W+R=sum_WR)
var 0..max_diff_WR: T;        % Investment in Transport (bounded upper; non-negative)
var 0..sum_WR: R;             % Investment in Retail (non-negative; bounded by W+R=sum_WR)

var 0..(cost_W*sum_WR + cost_T*max_diff_WR + cost_R*sum_WR): total_cost; % Total operational cost

% Constraints
% Budget constraint: Warehouse and Retail investments must sum to the fixed budget
constraint W + R = sum_WR;

% Minimum capacity constraint: combined Warehouse and Transport investment must meet minimum
constraint W + T >= min_WT;

% Balance constraint: difference between Warehouse and Retail investments bounded by max_diff_WR
constraint abs(W - R) <= max_diff_WR;

% Total cost definition (linear cost aggregation)
constraint total_cost = cost_W * W + cost_T * T + cost_R * R;

% Objective
solve minimize total_cost;