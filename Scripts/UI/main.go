package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

var db *sql.DB
var queryMetadata map[string]QueryMetadata

const DbPath = "./db/pokemon.db"
const SqlPath = "./db/pokemon.db"
const QueriesPath = "./db/queries"
const QueriesMetaPath = "./db/queries.json"

const port = ":8765"

func main() {
	// Open SQLite3 database
	var err error
	db, err = sql.Open("sqlite3", DbPath)
	if err != nil {
		fmt.Println("Error opening database:", err)
		return
	}
	// "defer" closes the connection automatically when main() terminates
	defer db.Close()

	// Create tables if not exists
	createTables()

	// Load query metadata from queries.json
	queryMetadata, err := loadQueryMetadata(QueriesMetaPath)
	if err != nil {
		fmt.Println("Error loading query metadata:", err)
		return
	}
	fmt.Println("Query metadata", queryMetadata)

	// API endpoint to execute queries
	http.HandleFunc("/api/execute_query", executeQueryHandler)

	// API endpoint to get query metadata
	http.HandleFunc("/api/get_query_list", getQueryListHandler)

	http.HandleFunc("/api/test", testEndpoint)
	http.Handle("/", http.FileServer(http.Dir("./static")))
	fmt.Println("Server listening on ", port, "...")
	http.ListenAndServe(port, nil)
}

func createTables() {
	// Read the SQL initialization script from pokemon.sql
	sqlScript, err := os.ReadFile("testdata/hello")
	if err != nil {
		fmt.Println("Error reading pokemon.sql:", err)
		return
	}

	// Execute the SQL initialization script
	_, err = db.Exec(string(sqlScript))
	if err != nil {
		fmt.Println("Error executing SQL script:", err)
	}
}

func loadQueryMetadata(filename string) (map[string]QueryMetadata, error) {
	// Load query metadata from queries.json
	fileContent, err := os.ReadFile(QueriesMetaPath)
	if err != nil {
		return nil, err
	}

	var queryMetadata map[string]QueryMetadata
	if err := json.Unmarshal(fileContent, &queryMetadata); err != nil {
		return nil, err
	}

	return queryMetadata, nil
}

// QueryMetadata represents the metadata for a query
type QueryMetadata struct {
	QueryName        string       `json:"-"`
	Parameters       []QueryParam `json:"parameters"`
	ReturnParameters []QueryParam `json:"return_parameters"`
	Display          string       `json:"display,omitempty"`
	SQLFile          string       `json:"sql_file"`
}

type QueryParam struct {
	Type    ParameterType `json:"type"`
	Name    string        `json:"name"`
	Order   []int         `json:"order"`
	Options []int         `json:"options,omitempty"`
}

type ParameterType string

const (
	IntType       ParameterType = "int"
	StringType    ParameterType = "string"
	StringSetType ParameterType = "string_set"
	intSetType    ParameterType = "int_set"
)

/////////////////////////////////////
///////////// ENDPOINTs /////////////
/////////////////////////////////////

func executeQueryHandler(w http.ResponseWriter, r *http.Request) {
	var queryRequest QueryRequest
	if err := json.NewDecoder(r.Body).Decode(&queryRequest); err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	// Check if the query name exists in the metadata
	metadata, ok := queryMetadata[queryRequest.QueryName]
	if !ok {
		http.Error(w, "Query not found", http.StatusNotFound)
		return
	}

	// Validate the parameters
	if len(queryRequest.Parameters) != len(metadata.Parameters) {
		http.Error(w, "Invalid number of parameters", http.StatusBadRequest)
		return
	}

	// Execute the query (implementation omitted for simplicity)
	result, err := executeQuery(metadata.SQLFile, queryRequest.Parameters)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Return the result
	json.NewEncoder(w).Encode(result)
}

func getQueryListHandler(w http.ResponseWriter, r *http.Request) {
	// Return the query metadata
	fmt.Println("Endpoint hit: GET /api/get_query_list")
	// json.NewEncoder(w).Encode(queryMetadata)
	fileContent, err := os.ReadFile(QueriesMetaPath)
	if err != nil {
		fmt.Fprintf(w, getErrorMessage("Could not read metadata file"))
	}

	fileContentString := string(fileContent)
	responseMessage := getOkMessage(fileContentString)
	_, err = fmt.Fprintf(w, responseMessage)
}

func executeQuery(sqlFile string, parameters []interface{}) (interface{}, error) {
	fmt.Println("Endpoint hit: POST /api/execute_query")
	// Implementation to execute the query (e.g., read SQL from file, bind parameters, execute)
	// ...

	// For simplicity, return a placeholder result
	return "Query executed successfully", nil
}

func testEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint hit: test")
	fmt.Fprintf(w, "{\"name\":\"Bulbasaur\", \"id\":\"1\"}")
}

// QueryRequest represents the request format for executing a query
type QueryRequest struct {
	QueryName  string        `json:"query_name"`
	Parameters []interface{} `json:"parameters"`
}

//////////////////////
/// Helper Methods ///
//////////////////////

func getErrorMessage(message string) string {
	return "{\"status\":\"error\", \"error\":\"" + message + "\"}"
}

// expects a message like "{\"key\":\"value\"}"
func getOkMessage(message string) string {
	return "{\"status\":\"ok\", \"error\":\"\", \"data\":\"" + message + "\"}"
}
