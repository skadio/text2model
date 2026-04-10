% Parameters (provided in .dzn)
int: area1;
int: area2;
int: area3;

% Variables
var int: area4;

% Constraints
% For a rectangle split by one vertical and one horizontal cut:
% area1 = x*y, area2 = len*y, area3 = x*height, area4 = len*height
% Eliminating dimensions gives: area1 * area4 = area2 * area3
constraint area1 > 0 /\ area2 > 0 /\ area3 > 0;
constraint area1 * area4 = area2 * area3;
constraint area4 >= 0;
constraint (area2 * area3) mod area1 = 0; % ensure integer area4

% Solve
solve satisfy;

output ["area4 = \(area4)\n"];