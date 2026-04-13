% Parameters
int: min_total_goods = 50;          % Minimum total goods to transport
int: max_diff_goods = 30;           % Maximum allowed difference |X - Y|
int: cost_per_good_X = 20;          % Cost per unit carried by vehicle X
int: cost_per_good_Y = 15;          % Cost per unit carried by vehicle Y

% Variables
var 0..min_total_goods + max_diff_goods: goods_X;   % Units carried by vehicle X (nonnegative integer)
var 0..min_total_goods + max_diff_goods: goods_Y;   % Units carried by vehicle Y (nonnegative integer)
var 0..(cost_per_good_X + cost_per_good_Y) * (min_total_goods + max_diff_goods): total_cost;
                                                    % Total cost (integer dollars)

% Constraints
% --- Total goods requirement ---
constraint
  goods_X + goods_Y >= min_total_goods;

% --- Workload balance constraint (absolute difference) ---
constraint
  abs(goods_X - goods_Y) <= max_diff_goods;

% --- Total cost definition ---
constraint
  total_cost = cost_per_good_X * goods_X + cost_per_good_Y * goods_Y;

% Objective
solve minimize total_cost;