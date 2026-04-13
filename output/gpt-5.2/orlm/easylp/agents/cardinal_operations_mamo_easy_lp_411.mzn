% Parameters
int: cost_residential = 30000;      % Cost per residential property (x)
int: cost_commercial  = 40000;      % Cost per commercial property (y)
int: cost_industrial  = 50000;      % Cost per industrial property (z)
int: cost_mixed_use   = 60000;      % Cost per mixed-use property (w)

int: max_res_plus_com = 20;         % x + y <= 20
int: max_ind_plus_mix = 30;         % z + w <= 30
int: min_res_or_ind   = 10;         % x + z >= 10
int: min_com_or_mix   = 15;         % y + w >= 15

int: x_lb = 0;  int: x_ub = 15;     % Bounds for x
int: y_lb = 0;  int: y_ub = 20;     % Bounds for y
int: z_lb = 0;  int: z_ub = 25;     % Bounds for z
int: w_lb = 0;  int: w_ub = 30;     % Bounds for w

% Variables
var x_lb..x_ub: x;                  % Number of residential properties
var y_lb..y_ub: y;                  % Number of commercial properties
var z_lb..z_ub: z;                  % Number of industrial properties
var w_lb..w_ub: w;                  % Number of mixed-use properties

% Total investment cost (objective variable with safe upper bound)
var 0..(cost_residential*x_ub
      + cost_commercial*y_ub
      + cost_industrial*z_ub
      + cost_mixed_use*w_ub): total_cost;

% Constraints

% ---- Portfolio composition limits ----
constraint
  x + y <= max_res_plus_com;   % Residential + Commercial cannot exceed limit

constraint
  z + w <= max_ind_plus_mix;   % Industrial + Mixed-use cannot exceed limit

% ---- Diversification / minimum allocation requirements ----
constraint
  x + z >= min_res_or_ind;     % At least min number of (Residential or Industrial)

constraint
  y + w >= min_com_or_mix;     % At least min number of (Commercial or Mixed-use)

% ---- Total cost definition ----
constraint
  total_cost =
    cost_residential * x +
    cost_commercial  * y +
    cost_industrial  * z +
    cost_mixed_use   * w;      % Compute total investment cost from chosen quantities

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "z (industrial)  = ", show(z), "\n",
  "w (mixed-use)   = ", show(w), "\n",
  "minimum total_cost = $", show(total_cost), "\n"
];