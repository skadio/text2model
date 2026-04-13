% Parameters
int: cost_residential = 30000;     % cost per residential property (x)
int: cost_commercial  = 40000;     % cost per commercial property (y)
int: cost_industrial  = 50000;     % cost per industrial property (z)
int: cost_mixeduse    = 60000;     % cost per mixed-use property (w)

int: max_x = 15;                  % upper bound for x
int: max_y = 20;                  % upper bound for y
int: max_z = 25;                  % upper bound for z
int: max_w = 30;                  % upper bound for w

int: max_xy = 20;                 % x + y <= 20
int: max_zw = 30;                 % z + w <= 30
int: min_xz = 10;                 % x + z >= 10
int: min_yw = 15;                 % y + w >= 15


% Variables
var 0..max_x: x;                  % number of residential properties
var 0..max_y: y;                  % number of commercial properties
var 0..max_z: z;                  % number of industrial properties
var 0..max_w: w;                  % number of mixed-use properties

% total investment cost (upper bound is cost of maxing out all property types)
var 0..(cost_residential*max_x + cost_commercial*max_y + cost_industrial*max_z + cost_mixeduse*max_w): total_cost;


% Constraints
% Portfolio size / mix limitations
constraint x + y <= max_xy;   % residential + commercial cannot exceed limit
constraint z + w <= max_zw;   % industrial + mixed-use cannot exceed limit

% Diversification / return requirements
constraint x + z >= min_xz;   % at least this many are residential or industrial
constraint y + w >= min_yw;   % at least this many are commercial or mixed-use

% Total investment cost definition
constraint total_cost =
    cost_residential * x +
    cost_commercial  * y +
    cost_industrial  * z +
    cost_mixeduse    * w;


% Objective
solve minimize total_cost;

% Optional output (helps verify the optimum and its cost)
output [
  "x=", show(x), " y=", show(y), " z=", show(z), " w=", show(w), "\n",
  "total_cost=", show(total_cost), "\n"
];