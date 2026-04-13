% Parameters
int: max_XY = 50;                 % Budget constraint: X + Y cannot exceed this
int: min_X  = 20;                 % Minimum employees required in department X
int: max_Y  = 30;                 % Maximum employees allowed in department Y

% Costs scaled by 10 to keep everything integral (1.5 -> 15, etc.)
int: costX = 15;
int: costY = 20;
int: costZ = 30;
int: costW = 40;

% Variables
var int: x;                       % Employees in department X (indivisible)
var int: y;                       % Employees in department Y (indivisible)
var int: z;                       % Employees in department Z (indivisible)
var int: w;                       % Employees in department W (indivisible)

var int: total_cost10;            % Total cost scaled by 10
var int: total_cost_rounded;      % Total cost rounded to nearest whole number

% Constraints

% --- Nonnegativity of manpower decision variables ---
constraint x >= 0;
constraint y >= 0;
constraint z >= 0;
constraint w >= 0;

% --- Department capacity / requirement constraints ---
constraint x + y <= max_XY;       % Budget/capacity for departments X and Y combined
constraint x >= min_X;            % Minimum staffing requirement for X
constraint y <= max_Y;            % Maximum staffing allowed for Y
constraint x >= z + w;            % X must be at least as large as Z and W combined

% --- Total cost computation (scaled by 10 to avoid fractions) ---
constraint total_cost10 = costX * x + costY * y + costZ * z + costW * w;

% --- Rounded total cost (nearest whole number of true cost) ---
% true_cost = total_cost10 / 10, nearest integer = floor((total_cost10 + 5) / 10)
constraint total_cost_rounded = (total_cost10 + 5) div 10;

% Objective
solve minimize total_cost10;