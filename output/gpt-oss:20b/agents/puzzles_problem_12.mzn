int: area1;  % area of the first rectangle
int: area2;  % area of the second rectangle
int: area3;  % area of the third rectangle

var int: w1, w2, h1, h2;   % dimensions of the sub‑rectangles
var int: area4;            % area of the fourth rectangle

% basic equations describing the layout
constraint w1 * h1 = area1;
constraint w2 * h1 = area2;
constraint w1 * h2 = area3;
constraint area4   = w2 * h2;

% dimensions must be positive integers
constraint w1 >= 1 /\ w2 >= 1 /\ h1 >= 1 /\ h2 >= 1;

solve satisfy;

output [ "Area4 = ", show(area4), "\n" ];