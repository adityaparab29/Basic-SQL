import mysql_connection
import csv


def insert_data_in_db(csvFilename, tableName, columnNames, columnCount):
    db_connection = mysql_connection.mysqlconnect()
    # Making Cursor Object For Query Execution
    cursor = db_connection.cursor()
    with open(csvFilename, mode='r') as file:
        # reading the CSV file
        dataCSV = csv.reader(file)
        val = '%s,'
        query = 'INSERT INTO ' + tableName + ' ( ' + columnNames + ') VALUES( '
        for i in range(columnCount):
            query += val
        query = query[:len(query) - 1] + " )"
        print(query)

        for row in dataCSV:
            for i in range(len(row)):
                value = row[i]
                value = value.replace("'", "")

                if "FALSE" or "TRUE" in value:
                    value = value.replace("FALSE", "0")
                    value = value.replace("TRUE", "1")

                row[i] = value
            # print(row)
            cursor.execute(query, row)

    db_connection.commit()
    cursor.close()
    # Closing Database Connection
    db_connection.close()


soccerData = {
    "COUNTRY": ["Country_Name", "Population", "No_of_Worldcup_won", "Manager"],
    "PLAYERS": ["Player_id", "Name", "Fname", "Lname", "DOB", "Country", "Height", "Club", "Position",
                "Caps_for_Country", "IS_CAPTAIN"],
    "MATCH_RESULTS": ["Match_id", "Date_of_Match", "Start_Time_Of_Match", "Team1", "Team2", "Team1_score",
                      "Team2_score", "Stadium_Name", "Host_City"],
    "PLAYER_CARDS": ["Player_id", "Yellow_Cards", "Red_Cards"],
    "PLAYER_ASSISTS_GOALS": ["Player_id", "No_of_Matches", "Goals", "Assists", "Minutes_Played"]
}

soccerDataCSV = {
    "COUNTRY": "Country.csv",
    "PLAYERS": "Players.csv",
    "MATCH_RESULTS": "Match_results.csv",
    "PLAYER_CARDS": "Player_Cards.csv",
    "PLAYER_ASSISTS_GOALS": "Player_Assists_Goals.csv"
}

for x, y in soccerData.items():
    columns = soccerData[x]
    columnNames = ', '.join(columns)
    print("Table: " + x)
    insert_data_in_db(soccerDataCSV[x], x, columnNames, len(columns))
