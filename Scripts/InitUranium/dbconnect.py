import pyodbc
import configparser


class Db_Connection:
    def __init__(self):
        print("init")
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

        ## use if you only have SQL Server driver installed on your system
        # self.connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

        ## use if you have ODBC v17
        self.connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'
        
    def __enter__(self):
        print('starting connection')
        try:
            self.connection = pyodbc.connect(self.connection_string)
        except pyodbc.Error as e:
            print(f"Error: {str(e)}")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print('closing connection')
        self.connection.close()

    def send_sql(self, sql, error_callback):
        # Establish a connection to the database    
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(sql)

                # Print results from the SELECT statement
                if any([s.strip().upper().startswith('SELECT') or s.strip().upper().startswith('WITH') for s in sql.split(";")]):
                    results = cursor.fetchall()
                    for row in results:
                        print(f"{row.firstname} {row.lastname} lives in {row.name}")
                    return results
                else:
                    # For non-SELECT queries, just commit the changes
                    self.connection.commit()
                    return None
        except pyodbc.Error as e:
            print(sql)
            # print(f"Error: {str(e)}")
            # error_callback(self, sql)

    def commit(self):
        # self.connection.commit()
        pass