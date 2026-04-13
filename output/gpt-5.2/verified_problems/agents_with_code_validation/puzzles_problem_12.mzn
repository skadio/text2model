% Parameters
% Known areas of three rectangles in a 2x2 partition of a large rectangle
int: area1;  % top-left
int: area2;  % top-right
int: area3;  % bottom-left

% Variables
% Shared dimensions of the partition:
% left column width = x, right column width = len
% top row height = y, bottom row height = height
var 0..max(area1, max(area2, area3)): x;
var 0..(area1 + area2 + area3): len;
var 0..max(area1, max(area2, area3)): y;
var 0..(area1 + area2 + area3): height;

% Unknown area of the bottom-right rectangle
var 0..(area1 + area2 + area3) * (area1 + area2 + area3): area4;

% Constraints
% --- Dimension positivity (avoid degenerate rectangles with zero side) ---
constraint x > 0 /\ len > 0 /\ y > 0 /\ height > 0;

% --- Known rectangle area relationships ---
constraint x * y = area1;         % top-left
constraint len * y = area2;       % top-right
constraint x * height = area3;    % bottom-left

% --- Unknown rectangle area relationship ---
constraint len * height = area4;  % bottom-right

% --- Consistency implied by shared cuts (redundant but strengthening) ---
constraint area1 * height = area3 * y;
constraint area2 * height = area4 * y;

% Objective
solve satisfy;