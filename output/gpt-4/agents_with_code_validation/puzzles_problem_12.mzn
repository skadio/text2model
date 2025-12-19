% Parameters
int: area1; % Area of the first rectangle
int: area2; % Area of the second rectangle
int: area3; % Area of the third rectangle

% Variables
var 1..100: x; % Length of the large rectangle
var 1..100: y; % Width of the large rectangle
var 1..100: len; % Length of the second rectangle
var 1..100: height; % Height of the third rectangle
var 1..100: area4; % Area of the fourth rectangle

% Constraints

% The area of a rectangle is the product of its length and width
% Therefore, the length of the large rectangle (x) is the sum of the lengths of the first and second rectangles
% And the width of the large rectangle (y) is the sum of the widths of the first and third rectangles

% Constraint for the length of the large rectangle
constraint x = area1 / y + len;

% Constraint for the width of the large rectangle
constraint y = area1 / x + height;

% The area of the fourth rectangle is the product of its length and width
% Therefore, the area of the fourth rectangle is the difference between the area of the large rectangle and the sum of the areas of the first, second, and third rectangles

% Constraint for the area of the fourth rectangle
constraint area4 = x * y - area1 - area2 - area3;

% Objective
solve satisfy;