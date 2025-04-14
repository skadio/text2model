include "globals.mzn"; 

% Variables representing the areas of different sections
int: area1;
int: area2;
int: area3;
var 1..100: area4;

% Variables representing the dimensions of the overall area
var 1..100: len;
var 1..100: height;
var 1..100: x;
var 1..100: y;

solve satisfy;

% Constraints

% Area constraints for the given dimensions
constraint x * y == area1;
constraint (len - x) * y == area2;
constraint (height - y) * x == area3;
constraint (height - y) * (len - x) == area4;

% The total area must be equal to the sum of all individual areas
constraint len * height == area1 + area2 + area3 + area4;

% Output
output [ "area4: ", show(area4), "\n"];