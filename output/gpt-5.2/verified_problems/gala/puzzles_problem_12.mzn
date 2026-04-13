% Rectangle partition area puzzle (2x2 grid)
% Given areas:
%   top-left  = area1 = x * y
%   top-right = area2 = len * y
%   bot-left  = area3 = x * height
% Find:
%   bot-right = ?     = len * height

include "globals.mzn";

int: area1;
int: area2;
int: area3;

% If areas are integers and come from integer side lengths, the unknown area is fixed:
% area4 = (area2 * area3) / area1, provided area1 divides area2*area3.
var int: area4;

constraint area1 > 0;
constraint area2 > 0;
constraint area3 > 0;

% Enforce integrality of the division in the model
constraint (area2 * area3) mod area1 = 0;
constraint area4 * area1 = area2 * area3;

solve satisfy;

output [
  "area4 = ", show(area4), "\n"
];