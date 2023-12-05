from math import floor
import os
from dbconnect import Db_Connection

SQL_SCRIPT_PATH = os.path.join("UI","db","pokemon.sql")
BATCH_SIZE = 500

def main():
    script_directory = os.path.dirname(os.path.abspath(__file__))

    # Construct the path to myfile.sql
    sql_file_path = os.path.join(script_directory, '..', 'UI', 'db', 'temp.sql')
    with open(sql_file_path, 'r', encoding='utf8') as file:
        content = file.read()
        with Db_Connection() as db:
            

            lines = content.split(";")
            i = 0
            while lines:
                if i<1:
                    b_s=500
                # if i<2:
                #     s=content.splitlines()
                #     s=[las for las in s if len(las)>2 and las[:2]!='--']
                #     content="".join(s)
                # elif i>101:
                #     b_s=1
                # elif i>5:
                #     b_s=1
                # elif i>2:
                #     b_s=1000
                else:
                    b_s=BATCH_SIZE
                # Take the next batch of lines
                batch = lines[:b_s]
                lines = lines[b_s:]
                
                sql_statements = ";".join(batch)
                db.send_sql(sql_statements, error_callback)
                # # Join the batch to form a SQL statement
                # sql_statements = "\n".join(batch).split(';')

                # # Send the SQL statement to the database
                # for sql_statement in sql_statements:
                #     db.send_sql(sql_statement+";")
                print(f"batch {i} complete")
                i+=1
            print("done")

def error_callback(_, sql):
    with Db_Connection as db:
        s=sql.split(";")
        bat_siz=floor(len(s)/10)
        i=0
        while s:
            batch = s[:bat_siz]
            s = s[bat_siz:]
            sql_statements = ";".join(batch)
            db.send_sql(sql_statements, error_callback)

            print(f"batch {i} complete")
            i+=1

if __name__=="__main__":
    main()