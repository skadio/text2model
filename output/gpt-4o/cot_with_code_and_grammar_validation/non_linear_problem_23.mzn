int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

array[1..m] of var 1..n: path;

var float: log_sum;
var float: final_amount;
var float: profit;

constraint all_different(path);

constraint min(path) = path[1];

constraint
    log_sum = sum(i in 1..m)(
        log(currencies[path[i], path[(i mod m) + 1]])
    );

constraint log_sum > 0.0;

constraint final_amount = start * exp(log_sum);

constraint profit = final_amount - start;

solve maximize log_sum;