% Parameters
int: area1; % Area of the first rectangle
int: area2; % Area of the second rectangle
int: area3; % Area of the third rectangle

% Variables
var 1..100: x; % Length of the large rectangle
var 1..100: y; % Width of the large rectangle
var 1..100: len; % Length of the first and third rectangles
var 1..100: height; % Height of the first and second rectangles
var 1..100: area4; % Area of the fourth rectangle

% Constraints
constraint len * height = area1;
constraint (x - len) * height = area2;
constraint len * (y - height) = area3;
constraint (x - len) * (y - height) = area4;

% Objective
solve satisfy;