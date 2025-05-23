% Parameters
float: area1;  % Area of the first (top-left) rectangle
float: area2;  % Area of the second (top-right) rectangle
float: area3;  % Area of the third (bottom-left) rectangle

% Variables
var 0.0..1.0e9: area4;  % Area of the fourth (bottom-right) rectangle

% Constraints
constraint area4 = (area2 * area3) / area1;

% Objective
solve satisfy;