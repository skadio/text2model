int: area1;
int: area2;
int: area3;

var 1..(area1 + area2 + area3): area4;

var 1..(area1 + area2 + area3): x;
var 1..(area1 + area2 + area3): len;
var 1..(area1 + area2 + area3): y;
var 1..(area1 + area2 + area3): height;

constraint x * y = area1;
constraint len * y = area2;
constraint x * height = area3;
constraint len * height = area4;

solve satisfy;

output ["area4 = \(area4)\n"];