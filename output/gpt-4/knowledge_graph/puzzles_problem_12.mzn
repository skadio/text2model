% Parameters
int: area1; % Area of the first rectangle
int: area2; % Area of the second rectangle
int: area3; % Area of the third rectangle

% Variables
var 1..100: x; % Length of the large rectangle
var 1..100: y; % Width of the large rectangle
var 1..100: len; % Length of the smaller rectangle
var 1..100: height; % Height of the smaller rectangle

% Constraints
constraint x * y = area1 + area2 + area3 + len * height;
constraint x = area1 / y;
constraint len = area2 / y;
constraint x = area3 / height;

% Objective
var int: area4 = len * height;
solve satisfy;
output ["Area of the fourth rectangle: ", show(area4)];