% Parameters
int: area1;    % Area of the top-left rectangle
int: area2;    % Area of the top-right rectangle
int: area3;    % Area of the bottom-left rectangle

% Variables
var 1..area2 * area3: area4;   % Area of the bottom-right rectangle (to be found)

% Constraints
constraint area1 * area4 = area2 * area3;

% Objective
solve satisfy;