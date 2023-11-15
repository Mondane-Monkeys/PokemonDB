# Parameter Types
Each parameter is one of the below types. 
 - int : a single number like eg 123
 - string : a string of characters eg "abcd"
 - string_set : a list of strings, eg ["abc", "abc", "abc"]
 - int_set : a list of integers eg [1,2,3]

# Display Types
Each query returns information. The display type indicates how that information should be displayed
 - string: concatenates all return parameters into a string, and displays a list of strings to the user
 - graph: Graphs a result on the X-Y plane. Uses return_parameter.order 1 as x value, and 2 as y value

# Query metadata
Each query will need an entry in the queries.json document

Each query entry will have a 
1. query_name : to uniquely identify that query 
2. parameters : to indicate what values are needed from the user
3. sql_file : the name/location of that query

for example:

    "query_name": {
        "parameters": [
            {
                "type": "int",
                "name": "pokemon_id",
                "order": [1,3]
            },
            {
                "type": "int_set",
                "name": "level",
                "order": [2],
                "options": [1,2,3,4,5,6,7,8,9,10]
            }
        ],
        "return_parameters": [
            {
                "type": "int_set",
                "name": "pokemon_id",
                "order": 1
            }
        ],
        "display": "graph",
        "sql_file": "example.sql"
    }

## Parameters 
Parameters are a list of parameter objects. Each object has a 
1. type: (as seen in the parameter types section)
2. name: to uniquely identify the paramater.
3. order: which indicates which '?' to replace in the prepared query
4. [optional] options, which restricts the domain of the parameter.
    - Can also be another query request to get the results of a subquery. 
    - The identifying value will the return_parameter.order 1 

## Return Parameters
These are the peices of data that get returned.
They should be explicitly ordered in your query 
- (ie, "SELECT a,b,c" is preferred over "SELECT *")
1. The "type" indicates what kind of data is returned from each found tuple
2. the "name" controls the label shown to the user
3. the "order" indicates which column to extract that data from. 
    - From the above example, result order 2 will always extract the 'b' column data, regardless of the name

# Query Request:
When a client wants to run a query, this is what the message should contain

    {
            "query":"query_name",
            "parameters":{
                {
                    "name": "pokemon_id"
                    "value": 1
                },
                {
                    "name": "level",
                    "value": [1,2,3,4,5,6]
                }
            }
    }