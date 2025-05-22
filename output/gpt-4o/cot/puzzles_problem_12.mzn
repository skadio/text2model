% Parameters
int: area1;
int: area2;
int: area3;

% Derived upper bounds
int: MAX_XY      = area1;                  % x and y cannot exceed area1 since x*y = area1
int: MAX_LEN     = area1 + area2;          % upper bound on the total width
int: MAX_HEIGHT  = area1 + area3;          % upper bound on the total height
int: MAX_AREA4   = MAX_LEN * MAX_HEIGHT;   % conservative upper bound on the unknown area

% Decision variables
var 1..MAX_XY     : x;         % position of the vertical cut
var 1..MAX_XY     : y;         % position of the horizontal cut
var 1..MAX_LEN    : len;       % total width  of the large rectangle
var 1..MAX_HEIGHT : height;    % total height of the large rectangle
var 1..MAX_AREA4  : area4;     % area of the fourth rectangle

% Constraints
constraint x * y = area1;
constraint (len - x) *  y          = area2;
constraint  x       * (height - y) = area3;
constraint (len - x) * (height - y) = area4;

constraint len > x /\ height > y;  % cuts must lie strictly inside the rectangle

% (Optional redundant constraint for consistency and propagation)
constraint len * height = area1 + area2 + area3 + area4;

solve satisfy;

output [
  "area4 = ", show(area4), "\n",
  "len   = ", show(len),   "\n",
  "height= ", show(height),"\n",
  "x     = ", show(x),     "\n",
  "y     = ", show(y),     "\n"
];