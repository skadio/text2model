% Parameters
%-------------------------------
% Unit costs
%-------------------------------
int: cost_W = 3;
int: cost_T = 2;
int: cost_R = 4;

%-------------------------------
% Constraint constants
%-------------------------------
int: min_WT = 500;        % W + T >= 500
int: max_WR_diff = 2000;  % |W - R| <= 2000
int: sum_WR = 3000;       % W + R = 3000


% Variables
%-------------------------------
% Investment decision variables (integers)
%-------------------------------
var int: W;  % Warehouse
var int: T;  % Transport
var int: R;  % Retail

% Aggregated objective variable
var int: total_cost;


% Constraints
%-------------------------------
% Domain / bounds constraints
%-------------------------------
% Non-negativity and safe upper bounds based on total WR budget
constraint W >= 0 /\ W <= sum_WR;
constraint R >= 0 /\ R <= sum_WR;
constraint T >= 0;

%-------------------------------
% Capacity requirement constraints
%-------------------------------
% Minimum combined investment in Warehouse and Transport
constraint W + T >= min_WT;

%-------------------------------
% Balance constraints
%-------------------------------
% Limit the imbalance between Warehouse and Retail investments
constraint abs(W - R) <= max_WR_diff;

%-------------------------------
% Budget / linking constraints
%-------------------------------
% Fixed total investment for Warehouse + Retail
constraint W + R = sum_WR;

%-------------------------------
% Cost aggregation constraint (for objective usage)
%-------------------------------
constraint total_cost = cost_W * W + cost_T * T + cost_R * R;


% Objective
solve minimize total_cost;