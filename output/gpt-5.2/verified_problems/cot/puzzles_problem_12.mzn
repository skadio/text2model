% Parameters
int: area1;
int: area2;
int: area3;

% Variables
var 1..max(area1, max(area2, area3)): x;        % left column width
var 1..max(area1, max(area2, area3)): len;      % right column width
var 1..max(area1, max(area2, area3)): y;        % top row height
var 1..max(area1, max(area2, area3)): height;   % bottom row height

var 1..(max(area1, max(area2, area3)) * max(area1, max(area2, area3))): area4;

% Constraints
constraint x * y = area1;
constraint len * y = area2;
constraint x * height = area3;
constraint len * height = area4;

% Objective
solve satisfy;