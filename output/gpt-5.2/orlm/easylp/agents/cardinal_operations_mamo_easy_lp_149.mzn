% Parameters
int: min_total_goods = 50;          % Minimum total goods to transport
int: max_diff_goods = 30;           % Maximum allowed absolute difference between X and Y
int: cost_per_good_X = 20;          % Cost per good carried by vehicle X (dollars)
int: cost_per_good_Y = 15;          % Cost per good carried by vehicle Y (dollars)

% Variables
var 0..min_total_goods: goods_X;    % Number of goods carried by vehicle X (integer, nonnegative)
var 0..min_total_goods: goods_Y;    % Number of goods carried by vehicle Y (integer, nonnegative)
var 0..(cost_per_good_X*min_total_goods + cost_per_good_Y*min_total_goods): total_cost;
                                   % Total cost (dollars)

% Constraints
% Link total_cost to the decision variables via linear cost expression
constraint
  total_cost = cost_per_good_X * goods_X + cost_per_good_Y * goods_Y;

% Ensure at least the minimum required total goods are transported
constraint
  goods_X + goods_Y >= min_total_goods;

% Balance workload: absolute difference between goods carried by X and Y is bounded
constraint
  abs(goods_X - goods_Y) <= max_diff_goods;

% Objective
solve minimize total_cost;