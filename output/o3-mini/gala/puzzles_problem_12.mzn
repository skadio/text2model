% A MiniZinc model for finding the unknown rectangle area.
% The large rectangle is divided into 4 smaller ones:
% ┌─────────────┬────────────┐
% │   area1     │   area2    │ 
% ├─────────────┼────────────┤
% │   area3     │   area4    │
% └─────────────┴────────────┘
%
% The known areas are:
%   area1 = x * y,
%   area2 = (len - x)* y,
%   area3 = x*(height - y),
%
% and the total area is len * height.
% By derivation, the area of the unknown rectangle area4 satisfies:
%   area4 = (area2 * area3) div area1
%
% Input parameters (to be provided via a .dzn file, e.g., area1=13; area2=39; area3=16;)
int: area1;
int: area2;
int: area3;

% The unknown rectangle area
var int: area4;

% Constraint linking the areas
constraint area1 * area4 = area2 * area3;

solve satisfy;

output ["The area of the fourth rectangle is: ", show(area4)];