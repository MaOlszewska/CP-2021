include "globals.mzn";

% how many types of items do we produce
int: nbTypes;
set of int: Types = 1..nbTypes;
% for how many timeslots do we plan the production
int: nbTimeslots;
set of int: Timeslots = 1..nbTimeslots;
% how many items do we have to produce
int: nbItems;
set of int: Items = 1..nbItems;
% how much does cost storage for a single timeslot
int: storageCost;
% how much costs reconfiguration of the assembly line
array[Types, Types] of int: changeCost;
% what are the types of each item
array[Items] of Types:  types;
% what are the deadlines of each item
array[Items] of Timeslots: dueTimeslots;

set of int: options = 0..nbItems;
% highest possible storageCost
int: storageCostMax = storageCost * sum([dueTimeslots[i] | i in Items]);
% settings for the factory line on each day 
array[Timeslots] of var Types: factorySettings;

array[Timeslots] of var options: preSolution;
array[Timeslots] of var int: solution;

%summary cost of changes of the factory settings
var 0..(nbItems-1)*max(changeCost): costOfChange = sum ( i in Timeslots where i > 1 ) ( changeCost[factorySettings[i-1], factorySettings[i]] );

%summary cost of storage times
var 0..storageCostMax: costOfStorage = storageCost * (sum ( day in Timeslots where preSolution[day] > 0) ( dueTimeslots[preSolution[day]] - day));

constraint costOfChange >= nbTypes * min(changeCost);
% constraint for correct factory settings per day
constraint forall(i in Timeslots where preSolution[i] > 0) ( factorySettings[i] = types[preSolution[i]]);

% given item must be produced before the deadline
constraint forall(i in Timeslots where preSolution[i] > 0) ( dueTimeslots[preSolution[i]] >= i );

constraint forall(i, j in Timeslots where preSolution[i] > 0 /\ preSolution[j] > 0 /\ i < j) ( preSolution[i] != preSolution[j]);
%constraint alldifferent_except_0(preSolution);
% items must appear in solution once and only once :D
constraint nvalue(factorySettings) = nbTypes;
% Facotry has to work more than not work, so 0 is difference between days to be planned and number of items
constraint count(preSolution, 0, nbTimeslots - nbItems);

% rewrite solution but with -1 instead of 0 as non working days
constraint forall(i in Timeslots where preSolution[i] > 0) (solution[i] = preSolution[i] - 1);
constraint forall(i in Timeslots where preSolution[i] = 0) (solution[i] = -1);

% Objective is to minimize the cost of storage and reconfiguration
var int: obj = costOfChange + costOfStorage;
% solve minimize obj ;

solve:: int_search(preSolution, smallest, indomain_min, complete) minimize obj;
output ["solution: " ++ show(solution) ++ ";\nobj = " ++ show(obj) ++ ";"];
