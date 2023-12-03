package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"reflect"
	"sort"
	"strings"

	_ "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	"github.com/pelletier/go-toml"
)

var db *sqlx.DB

// var queryMetadata map[string]QueryMetadata

// const DbPath = "./db/pokemon.db" //use this if persistence is desired
const DbPath = ":memory:" //use this if persistance is not desired
const SqlPath = "./db/pokemon.sql"
const QueriesPath = "./db/queries"
const QueriesMetaPath = "./db/queries.json"
const QueriesDirectory = "./db/queries/"
const connectionFile = "connectionStrings.toml"

const port = ":8765"

func main() {
	var err error
	//get congif
	config, err := loadConfig(connectionFile)
	if err != nil {
		log.Fatal("Error loading configuration:", err)
	}

	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;database=%s;",
		config.Server.Server, config.Credentials.Username, config.Credentials.Password, config.Server.Database)

	// Open msSQL database
	fmt.Println("Opening db...")
	db, err = sqlx.Open("mssql", connString)
	if err != nil {
		fmt.Println("Error opening database:", err)
		return
	}
	// "defer" closes the connection automatically when main() terminates
	defer db.Close()

	// Create tables if not exists
	// createTables()
	testTables()
	fmt.Println("Db opened successfully")

	// Load query metadata from queries.json
	queryMetadata, err := loadQueryMetadata(QueriesMetaPath)
	if err != nil {
		fmt.Println("Error loading query metadata:", err)
		return
	}
	fmt.Println("Query metadata", queryMetadata)

	// API endpoint to execute queries
	http.HandleFunc("/api/query", executeQueryHandler)

	// API endpoint to get query metadata
	http.HandleFunc("/api/get_query_list", getQueryListHandler)

	// handle test
	http.HandleFunc("/api/test", testEndpoint)

	// Handle update server
	http.HandleFunc("/api/update_server", update_server)
	http.Handle("/", http.FileServer(http.Dir("./static")))
	fmt.Println("Server listening on ", port, "...")
	http.ListenAndServe(port, nil)
}

func loadConfig(filename string) (*Config, error) {
	config := &Config{}

	// Load TOML configuration from file
	tree, err := toml.LoadFile(filename)
	if err != nil {
		return nil, err
	}

	// Unmarshal the TOML data into the Config struct
	if err := tree.Unmarshal(config); err != nil {
		return nil, err
	}

	return config, nil
}

func createTables() {
	// Read the SQL initialization script from pokemon.sql
	sqlScript, err := os.ReadFile(SqlPath)
	if err != nil {
		fmt.Println("Error reading pokemon.sql:", err)
		return
	}

	// Execute the SQL initialization script
	_, err = db.Exec(string(sqlScript))
	if err != nil {
		fmt.Println("Error executing SQL script:", err)
	}
	testTables()
}

func testTables() {
	rows, err := db.Queryx("SELECT * FROM pokemon")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	// Process query results
	for rows.Next() {
		result := map[string]interface{}{}
		if err := rows.MapScan(result); err != nil {
			log.Fatal(err)
		}
		fmt.Println(result)
	}

	if err := rows.Err(); err != nil {
		log.Fatal(err)
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

// /////////////
// / STRUCTS ///
// /////////////
// QueryMetadata represents the metadata for a query
type QueryMetadata struct {
	QueryName        string       `json:"-"`
	Parameters       []QueryParam `json:"parameters"`
	ReturnParameters []QueryParam `json:"return_parameters"`
	Display          string       `json:"display,omitempty"`
	Flags            []string     `json:"flags,omitempty"`
	SQLFile          string       `json:"sql_file"`
}

type QueryParam struct {
	Type    string   `json:"type"`
	Name    string   `json:"name"`
	Order   []int    `json:"order"`
	Options []int    `json:"options,omitempty"`
	Flags   []string `json:"flags,omitempty"`
}

type ParsedParameters struct {
	Order int
	Value []string
}

// QueryRequest represents the request format for executing a query
type QueryRequest struct {
	QueryName  string              `json:"query_name"`
	Parameters []QueryRequestParam `json:"parameters"`
}
type QueryRequestParam struct {
	Name  string   `json:"name"`
	Value []string `json:"value"`
}

// UnmarshalJSON implements the json.Unmarshaler interface for QueryRequestParam
func (q *QueryRequestParam) UnmarshalJSON(b []byte) error {
	var temp struct {
		Name  string        `json:"name"`
		Value []interface{} `json:"value"`
	}
	if err := json.Unmarshal(b, &temp); err != nil {
		return err
	}
	fmt.Println(temp.Name)
	q.Name = temp.Name
	q.Value = []string{}
	for _, item := range temp.Value {
		fmt.Printf("Type: %s\n", reflect.TypeOf(item))
		switch item.(type) {
		case float64:
			fmt.Println(fmt.Sprint(item.(float64)))
			q.Value = append(q.Value, fmt.Sprint(item.(float64)))
			break
		case string:
			q.Value = append(q.Value, item.(string))
		}
	}
	return nil
}

type Credentials struct {
	Username string `toml:"username"`
	Password string `toml:"password"`
}

type ServerConfig struct {
	Server   string `toml:"server"`
	Database string `toml:"database"`
}

type Config struct {
	Credentials Credentials  `toml:"credentials"`
	Server      ServerConfig `toml:"server"`
}

/////////////////////////////////////
///////////// ENDPOINTs /////////////
/////////////////////////////////////

func executeQueryHandler(w http.ResponseWriter, r *http.Request) {
	var queryRequest QueryRequest
	fmt.Println("Endpoint hit: GET /api/get_query_list:")

	if err := json.NewDecoder(r.Body).Decode(&queryRequest); err != nil {
		errMsg := fmt.Sprintf("ERROR: Could not parse JSON body: %v", err)
		fmt.Println(errMsg)
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	// Execute the query (implementation omitted for simplicity)
	result, err := prepQuery(queryRequest)
	if err > 0 {
		http.Error(w, result, err)
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

func testEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint hit: test")
	fmt.Fprintf(w, "{\"name\":\"Bulbasaur\", \"id\":\"1\"}")
}

func update_server(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint hit: update server")
	cmd := exec.Command("git", "pull")
	err := cmd.Run()
	if err != nil {
		log.Printf("Error running Git pull: %s\n", err)
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

// ////////////////
// / Handle SQL ///
// ////////////////
func prepQuery(queryRequest QueryRequest) (out string, errCode int) {
	fullmeta, err := loadQueryMetadata(SqlPath)
	// Check if the query name exists in the metadata
	metadata, ok := fullmeta[queryRequest.QueryName]
	if !ok {
		fmt.Println("Query not found: ", queryRequest.QueryName)
		return "Query not found", http.StatusNotFound
	}

	// Validate the parameters
	if len(queryRequest.Parameters) != len(metadata.Parameters) {
		return "Invalid number of parameters", http.StatusBadRequest
	}

	result, err := executeQuery(metadata.SQLFile, metadata.Parameters, queryRequest.Parameters, len(metadata.ReturnParameters))
	fmt.Println(result)
	if err != nil {

		return fmt.Sprintf("Internal Server Error: ", err), http.StatusInternalServerError
	}
	return mapToJson(result), -1
}

func executeQuery(sqlFile string, QuearyParam []QueryParam, reqParams []QueryRequestParam, columnCount int) ([]map[string]interface{}, error) {
	fmt.Println("Endpoint hit: POST /api/execute_query")

	query, err := os.ReadFile(QueriesDirectory + sqlFile)
	if err != nil {
		log.Println("Could not read query ", err)
		return nil, err
	}

	values := flattenParameters(QuearyParam, reqParams)
	parsedQuery := handleListInputs(string(query), values)
	rows, err := db.Queryx(parsedQuery, flattenToAny(values)...)
	// rows, err := db.Query(string(query), values...)
	if err != nil {
		log.Println("Query failed ", err)
		return nil, err
	}
	defer rows.Close()

	// Process query resultscolumnCount
	var output []map[string]interface{}
	for rows.Next() {
		result := map[string]interface{}{}
		err := rows.MapScan(result)
		if err != nil {
			log.Println("Query failed2 ", err)
			return nil, err
		}
		output = append(output, result)
	}
	fmt.Println("Query executed successfully")
	return output, nil
}

func flattenParameters(meta []QueryParam, req []QueryRequestParam) [][]string {
	var flattened []ParsedParameters
	for _, param := range meta {
		value := getParamByName(param.Name, req)
		for _, num := range param.Order {
			flattened = append(flattened, ParsedParameters{Order: num, Value: value})
		}
	}

	sort.Slice(flattened, func(i, j int) bool {
		return flattened[i].Order < flattened[j].Order
	})

	var values [][]string
	for _, v := range flattened {
		values = append(values, v.Value)
	}

	return values
}
func getParamByName(name string, reqs []QueryRequestParam) []string {
	for _, value := range reqs {
		if value.Name == name {
			return value.Value
		}
	}
	return nil
}

func handleListInputs(query string, params [][]string) string {
	var result strings.Builder
	fmt.Println("Padding query: " + query)

	countIndex := 0
	for _, char := range query {
		if char == '?' && countIndex < len(params) {
			// Replace '?' with the desired number of repetitions
			result.WriteString(strings.Repeat("?,", len(params[countIndex])-1) + "?")
			countIndex++
		} else {
			// Keep the character as is
			result.WriteRune(char)
		}
	}

	return result.String()
}

func flattenToAny(arg [][]string) []interface{} {
	var result []interface{}
	for _, slice := range arg {
		for _, s := range slice {
			result = append(result, s)
		}
	}
	return result
}

func mapToJson(data []map[string]interface{}) string {
	// Convert the data to JSON
	jsonBytes, err := json.Marshal(data)
	if err != nil {
		return "error"
	}

	// Convert JSON bytes to a string
	jsonString := string(jsonBytes)

	return jsonString
}

//////////////////////
/// Helper Methods ///
//////////////////////

func getErrorMessage(message string) string {
	return "{\"status\":\"error\", \"error\":\"" + message + "\"}"
}

// expects a message like "{\"key\":\"value\"}"
func getOkMessage(message string) string {
	return "{\"status\":\"ok\", \"error\":\"\", \"data\":" + message + "}"
}
