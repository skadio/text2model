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
% Similarly, the width of the large rectangle (y) is the sum of the widths of the first and third rectangles
constraint x = area1 / y + len;
constraint y = area1 / x + height;

% The area of the second rectangle is the product of its length and the width of the large rectangle
constraint area2 = len * y;

% The area of the third rectangle is the product of its height and the length of the large rectangle
constraint area3 = height * x;

% The area of the fourth rectangle is the product of the remaining length and width in the large rectangle
constraint area4 = (x - area1 / y) * (y - area1 / x);

% Objective
solve satisfy;