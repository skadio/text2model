% Parameters
int: area1; % Area of the first (top-left) rectangle
int: area2; % Area of the second (top-right) rectangle
int: area3; % Area of the third (bottom-left) rectangle

% Variables
var int: x;      % Width of the left column (shared by area1 and area3)
var int: len;    % Width of the right column (shared by area2 and the unknown rectangle)
var int: y;      % Height of the top row (shared by area1 and area2)
var int: height; % Height of the bottom row (shared by area3 and the unknown rectangle)

var int: area4;  % Area of the fourth (bottom-right) rectangle (unknown)

% Constraints
% --- Rectangle area definitions (top-left, top-right, bottom-left) ---
constraint x * y = area1;          % area1 = (left width) * (top height)
constraint len * y = area2;        % area2 = (right width) * (top height)
constraint x * height = area3;     % area3 = (left width) * (bottom height)

% --- Define the unknown area (bottom-right) consistently ---
constraint area4 = len * height;   % area4 = (right width) * (bottom height)

% --- Basic geometric feasibility (positive dimensions and area) ---
constraint x > 0 /\ len > 0 /\ y > 0 /\ height > 0;  % all side lengths must be positive
constraint area4 > 0;                                 % area must be positive

% Objective
solve satisfy;