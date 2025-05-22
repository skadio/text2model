% Parameters
int: area1; % Area of the first rectangle
int: area2; % Area of the second rectangle
int: area3; % Area of the third rectangle

% Variables
var 1..100: x; % Length of the large rectangle
var 1..100: y; % Width of the large rectangle
var 1..100: len; % Length of the smaller rectangle
var 1..100: height; % Height of the smaller rectangle
var 1..100: area4; % Area of the fourth rectangle

% Constraints
constraint x = len + y;
constraint area1 = len * height;
constraint area2 = y * height;
constraint area3 = len * (x - len);
constraint area4 = y * (x - len);

% Objective
solve satisfy;