////////////
/// INIT ///
////////////
window.onload = function (){
    //Get query list
    makeXHRRequest('GET', '/api/get_query_list', null, function (response) {
        queries = response["data"]
        updateQueryList();
        console.log('Get Query List Response:', response);
    });
}

/////////////////////
/// Event handlers///
/////////////////////
var dropdownWrapper = document.getElementById("dropdown")
dropdownWrapper.onclick = (function (event) {
    let target = event.target.closest('.drop-option, .dropbtn')
    if (!dropdownWrapper.contains(target)) return;

    if (target.className == 'dropbtn') {
        toggleDropdown()
    } else if (target.className == 'drop-option') {
        let functionName = target.innerText
        selectQuery(functionName)
        toggleDropdown()
        hideOutput()
        console.log(functionName)
    }
});

function toggleDropdown() {
    let dropdown = document.getElementById("queries-list")
    if (dropdown.style.display === 'block') {
        dropdown.style.display = "none"
    } else {
        dropdown.style.display = 'block'
    }
}

function hideOutput() {
    //Add any new output elements to this function
    document.getElementById("table-output").style.display = "none"
}

function showHideLoading(show=false){
    let loading = document.getElementById("loading")
    if (show) {
        loading.style.display = "flex";
    } else {
        loading.style.display = "none";
    }
}

//////////////
/// Output ///
//////////////
function tableOutput(data){
    if (!data || data.length===0) {
        alert("Query returned no data")
        return
    }

    let table = document.getElementById("table-output")

    //Drop old children
    while (table.firstChild) table.removeChild(table.firstChild)

    const thead = document.createElement("thead")
    const headerRow = document.createElement("tr")

    //Populate headers
    const keys = Object.keys(data[0])
    keys.forEach(key=>{
        const th = document.createElement("th")
        th.textContent=key
        headerRow.appendChild(th)
    })
    //Add buffer to end of table
    const th = document.createElement("th")
    headerRow.appendChild(th)

    thead.appendChild(headerRow)
    table.appendChild(thead)

    //Populate body
    const tbody = document.createElement("tbody")
    for (let i = 0; i < data.length; i++) {
        const element = data[i];
        const row = document.createElement("tr")

        keys.forEach(key=>{
            const cell = document.createElement("td")
            cell.textContent = element[key]
            row.appendChild(cell)
        })
        //add buffer to end
        const cell = document.createElement("td")
        row.appendChild(cell)
        
        tbody.appendChild(row)
    }
    table.appendChild(tbody)
    table.style.display = "block"
}

///////////////
/// Queries ///
///////////////
let queries = {}
let selectedQuery = null

function updateQueryList() {
    let dropdownContent = document.getElementById("queries-list")
    //Drop all children
    while (dropdownContent.firstChild) dropdownContent.removeChild(dropdownContent.firstChild)

    //add new children
    for (const [key, value] of Object.entries(queries)) {
        var node = document.createElement("div")
        node.classList.add("drop-option")
        node.innerText = key
        dropdownContent.appendChild(node)
    }
}

function selectQuery(functionName) {
    if (!queries.hasOwnProperty(functionName)) {
        alert(`Query ${functionName} not found. Please reload queries`)
        return
    }

    queryInputs = document.getElementById("query-inputs")
    queryData = queries[functionName]
    selectedQuery = functionName

    //Drop all children from form
    while (queryInputs.firstChild) queryInputs.removeChild(queryInputs.firstChild)

    //add all inputs to form
    queryData.parameters.forEach(param => {
        console.log(param)
        var input = document.createElement("li")
        var inputElement = createInput(param.type, param.name)
        input.appendChild(inputElement)
        queryInputs.appendChild(input)
    });

    execButton = document.createElement("button")
    execButton.textContent = "Run Query"
    execButton.addEventListener("click", runCurrentQuery)
    queryInputs.appendChild(execButton)
}

function createInput(type, name) {
    let inputElement = document.createElement("input")
    switch (type) {
        case 'int':
            inputElement.type = 'number'
            break;
        case 'string':
            inputElement.type = 'text'
            break;
        default:
            inputElement.type = 'text'
            break;
    }
    inputElement.name = name
    inputElement.placeholder = `Enter ${name}`
    inputElement.id = name
    return inputElement
}

function runCurrentQuery() {
    console.log("Run this somehow lol")
    let request = { query_name: selectedQuery, parameters: [] }
    let queryData = queries[selectedQuery]

    queryData.parameters.forEach(param => {
        let inputElement = document.getElementById(param.name);
        if (inputElement) {
            request.parameters.push({
                name: param.name,
                value: [inputElement.value]
            })
        }
    });
    makeQueryRequest(request)
}

/////////////////////
/// Network calls ///
/////////////////////
function testQuery() {
    request = {
        "query_name": "get_pokemon_in",
        "parameters": [
            {
                "name": "minID",
                "value": [2]
            },
            {
                "name": "options_int",
                "value": [1, 2, 3, 4, 5, 6]
            },
            {
                "name": "options_strings",
                "value": ["Bulbasaur", "Charmander", "Wartortle"]
            }
        ]
    }
    makeXHRRequest("POST", "/api/query", request, (data) => {
        var obj = JSON.parse(data)
        console.log(`Response: ${data}`)
    })
}

function makeXHRRequest(method, url, data, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    showHideLoading(true)

    xhr.onreadystatechange = function () {
        showHideLoading(false)
        if (xhr.readyState === 4 && xhr.status === 200) {
            if (xhr.responseText) {
                callback(JSON.parse(xhr.responseText));
            } else {
                callback(null)
            }
        } else if (xhr.readyState===4 && xhr.status === 500){
            alert(xhr.responseText)
        } else if (xhr.readyState===4 && xhr.status === 404){
            alert("Query not found")
        }
    };
    msg = JSON.stringify(data)
    xhr.send(msg);
}

//THIS MAKES A QUERY REQUEST!
function makeQueryRequest(request) {
    console.log(`Request: ${request}`)
    makeXHRRequest("POST", "/api/query", request, (data) => {
        if (!data) {
            alert("No entries returned from query")
        }
        data = JSON.parse(data) //Not sure why it got double encoded, but here we are
        //Add your custom view model method here
        if (queries[selectedQuery].display === "The type you care about") {
            exampleOutputMethod(data)
        } else {
            //Handle default output (as a table)
            tableOutput(data)
        }
        console.log(`Response: ${data}`)
    })
}

document.getElementById('updateServerButton').addEventListener('click', function () {
    makeXHRRequest('GET', '/api/update_server', {}, (data) => {
        alert("Server updating\nCould take up to 5 seconds")
    });
});

document.getElementById('getQueryListButton').addEventListener('click', function () {
    makeXHRRequest('GET', '/api/get_query_list', null, function (response) {
        queries = response["data"]
        updateQueryList();
        console.log('Get Query List Response:', response);
    });
});




