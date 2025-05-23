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
constraint x * y = area1 + area2 + area3 + area4;
constraint x * height = area1 + area3;
constraint y * len = area1 + area2;

% Objective
solve satisfy;