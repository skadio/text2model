% Parameters
int: oven_hours_available = 70;              % Total oven hours available per day
int: chef_hours_available = 32;              % Total pastry chef hours available per day

int: oven_hours_per_bagel_batch = 2;         % Oven hours required per bagel batch
float: chef_hours_per_bagel_batch = 0.25;    % Chef hours required per bagel batch

int: oven_hours_per_croissant_batch = 1;     % Oven hours required per croissant batch
int: chef_hours_per_croissant_batch = 2;     % Chef hours required per croissant batch

int: profit_per_bagel_batch = 20;            % Profit per bagel batch ($)
int: profit_per_croissant_batch = 40;        % Profit per croissant batch ($)

% Variables
var int: bagel_batches;                      % Number of bagel batches to bake
var int: croissant_batches;                  % Number of croissant batches to bake
var int: total_profit;                       % Total profit ($)

% Constraints
% Non-negativity (feasibility bounds)
constraint bagel_batches >= 0;
constraint croissant_batches >= 0;

% Link total_profit to decision variables (profit definition)
constraint
  total_profit =
    profit_per_bagel_batch * bagel_batches
  + profit_per_croissant_batch * croissant_batches;

% Oven capacity constraint (do not exceed available oven hours)
constraint
  oven_hours_per_bagel_batch * bagel_batches
+ oven_hours_per_croissant_batch * croissant_batches
<= oven_hours_available;

% Pastry chef capacity constraint (do not exceed available chef hours)
% Avoid float-in-int comparisons by scaling all chef-hour coefficients by 4:
% bagels: 0.25 * 4 = 1, croissants: 2 * 4 = 8, availability: 32 * 4 = 128
constraint
  (1 * bagel_batches)
+ (4 * chef_hours_per_croissant_batch * croissant_batches)
<= (4 * chef_hours_available);

% Objective
solve maximize total_profit;