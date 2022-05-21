import mysql.connector


def mysqlconnect():
    try:
        db_connection = mysql.connector.connect(
            host="acadmysqldb001p.uta.edu",
            user="",
            password="",
            database="axp9807"
        )
    # If connection is not successful
    except:
        print("Can't connect to database")
        return 0
    print("Connected")

    return db_connection
