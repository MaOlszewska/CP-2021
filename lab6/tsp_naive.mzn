include "globals.mzn";


int: Nodes;
set of int: NUM = 1..Nodes;
array[NUM,NUM] of int: Dist;
array[NUM] of var NUM: route;

constraint route[1] = 1;
constraint alldifferent(route);


var int: total_distance = sum(i in 1..(Nodes-1))(Dist[route[i], route[i+1]]) + Dist[route[Nodes], 1];

solve minimize total_distance;

/*
TODO: 
- the cities in the route should not repeat
- the first city in the route should be fixed to 1
- calculate the total distance based on the route
*/

output ["distance: \(total_distance)\nroute = \(route)"];