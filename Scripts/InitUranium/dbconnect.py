import pyodbc
import configparser

# Read database credentials from config file
config = configparser.ConfigParser()
config.read('auth.cfg')

username = config.get('credentials', 'username')
password = config.get('credentials', 'password')

if username is None or password is None:
    print("Username or password not provided.")
    exit(1)

# Database connection parameters
server = 'uranium.cs.umanitoba.ca'
database = 'cs3380'
connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

# Establish a connection to the database
try:
    connection = pyodbc.connect(connection_string)
    cursor = connection.cursor()

    # Execute a SELECT SQL statement
    select_sql = '''
    SELECT firstname, lastname, provinces.name
    FROM people
    JOIN provinces ON people.provinceID = provinces.provinceID
    '''

    cursor.execute(select_sql)

    # Print results from the SELECT statement
    for row in cursor.fetchall():
        print(f"{row.firstname} {row.lastname} lives in {row.name}")

except pyodbc.Error as e:
    print(f"Error: {str(e)}")

finally:
    # Close the connection
    if 'connection' in locals():
        connection.close()
