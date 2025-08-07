int: area1;  % Area of the first rectangle
int: area2;  % Area of the second rectangle
int: area3;  % Area of the third rectangle

% The area of the fourth rectangle can be calculated as follows:
var int: area4;  % Area of the fourth rectangle

% The total area of the large rectangle is the sum of the areas of the four smaller rectangles
var int: total_area = area1 + area2 + area3 + area4;

% We need to find the area of the fourth rectangle
constraint area4 = total_area - (area1 + area2 + area3);

% Since the areas must be non-negative, we add a constraint for area4
constraint area4 >= 0;

% Solve the model
solve satisfy;

% Output the area of the fourth rectangle
output [ "Area of the fourth rectangle = ", show(area4), "\n" ];