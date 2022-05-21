/* 
3. Execute each query and display its results
1)	Print the name, club, and country name of all midfielder players whose country is 'USA'.
*/

SELECT
	Name, Club, Country
FROM
	PLAYERS
WHERE
	Position = 'Midfielder'
AND
	Country = 'USA';


/*
2)	Print the name, club, country and age of captains of each country participating in the 2014 world cup (this database)
*/

SELECT
	Name, Club, Country, TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS Age
FROM
	PLAYERS
WHERE
	Is_captain is true;

/*
3)	Retrieve the names of countries participating in the 2014 world cup (this database) that have won the world cup more than twice.
*/

SELECT
	Country_Name
FROM
	COUNTRY
WHERE
	No_of_Worldcup_won > 2;

/*
4)	Retrieve the names of countries participating in the 2014 world cup (this database) that have never won the world cup.
*/

SELECT
	Country_Name, No_of_Worldcup_won AS 'World Cups Won'
FROM
	COUNTRY
WHERE
	No_of_Worldcup_won < 1;

/*
5)	Retrieve the name and country of the player who had neither red cards nor yellow cards in the 2014 world cup.
*/

SELECT 
	Name, Country
FROM 
	PLAYERS PL
LEFT JOIN 
	PLAYER_CARDS PC 
ON 
	PL.Player_id = PC.Player_id
WHERE 
	PC.Player_id IS NULL;

/*
6)	Retrieve the name and country of the players with the most Red cards in the 2014 world cup.
*/

SELECT 
	Name, Country
FROM 
	PLAYERS PL
INNER JOIN 
	PLAYER_CARDS PC 
ON 
	PL.Player_id = PC.Player_id
WHERE 
	PC.Red_Cards IN (SELECT 
						MAX(Red_Cards) 
					FROM 
						PLAYER_CARDS);

/*
7)	For each Host city, retrieve the HostCity and the total number of games played in that city.
*/

SELECT 
	Host_city, COUNT(1) AS 'Games Played' 
FROM 
	MATCH_RESULTS 
GROUP BY 
	Host_city;

/*
8)	Retrieve the names of host city with the most games played in that city.
*/

SELECT 
	Host_city, COUNT(1) AS 'Most Games Played'
FROM
	MATCH_RESULTS
GROUP BY
	Host_city
HAVING COUNT(1) = (
					SELECT 
						MAX(y.num)
					FROM 
						(
							SELECT 
								Host_city, COUNT(1) AS num
							FROM 
								MATCH_RESULTS x 
							GROUP BY 
								Host_city
						) y
					);


/*
9)	For each country, retrieve the country name and the number of games they played as Team1 in the MATCH_RESULTS table, and the total goals scored (SUM of Team1_score) and the goals against (SUM of Team2_score).
*/

Select 
	Team1 AS 'Country Name', 
	Count(Match_id) AS 'Games Played As Team 1', 
	SUM(Team1_score) AS 'Total Goals Scored', 
	SUM(Team2_score) AS 'Total Goals Against'
FROM 
	MATCH_RESULTS 
Group By 
	Team1;

/*
10)	For each country, retrieve the country name and the number of games they played as Team2 in the MATCH_RESULTS table, and the total goals scored (SUM of Team12_score) and the goals against (SUM of Team1_score)
*/

Select 
	Team2 AS 'Country Name', 
	Count(Match_id) AS 'Games Played As Team 2', 
	SUM(Team2_score) AS 'Total Goals Scored', 
	SUM(Team1_score) AS 'Total Goals Against'
FROM 
	MATCH_RESULTS 
Group By 
	Team2;

/*
11)	Write a query that combines the results of the queries in 9. and 10. To get the total number of games each country has played (either as Team1 or as Team2), their total goals scored and their total goals against. Create a view TEAM_SUMMARY that has the following data attributes to hold the result of the combined query: CountryName, NoOfGames, TotalGoalsFor, TotalGoalsAgainst. Order in descending order of number of games played.
*/

CREATE OR REPLACE VIEW TEAMS_SUMMARY AS
SELECT 
	t.Team1, 
	SUM(t.matches) as 'Games Played', 
	SUM(t.total_scored) as 'Total Goals For', 
	SUM(t.total_against) as 'Total Goals Against' 
FROM 
	(
		SELECT 
			Team1, 
			COUNT(1) as matches, 
			SUM(Team1_score) as total_scored,
			SUM(Team2_score) as total_against 
		FROM 
			MATCH_RESULTS 
		GROUP BY 
			Team1 
		
		UNION 

		SELECT 
			Team2, 
			COUNT(1) as matches, 
			SUM(Team2_score) as total_scored, 
			SUM(Team1_score) as total_against 
		FROM 
			MATCH_RESULTS 
		GROUP BY  
			Team2
	) t 
GROUP BY  
	t.Team1
ORDER BY 
	SUM(t.matches) DESC;

SELECT * FROM TEAMS_SUMMARY;

/*
12)	For each match, print the date of match, name of team1, name of team2, name of winning team and goal difference between teams. Goal difference should be a positive value.
*/

SELECT
	Date_of_Match,
	Team1,
	Team2,
	CASE
		WHEN Team1_score > Team2_score THEN Team1
		WHEN Team2_score > Team1_score THEN Team2
		ELSE '-'
	END AS 'Winning Team',
	CASE
		WHEN Team1_score > Team2_score THEN Team1_score-Team2_score
		ELSE Team2_score-Team1_score
	END AS 'Goals Diff'
FROM
	MATCH_RESULTS
ORDER BY
	Date_of_Match;

/*
13)	Find all the matches played with country ‘Brazil’.
*/

SELECT
	*
FROM 
	MATCH_RESULTS 
WHERE 
	Team1 = 'Brazil' 
OR 
	Team2 = 'Brazil';

/*
14)	Retrieve the names of the players who have scored at least one goal, the player’s country, and the number of goals each player scored. Order the result by number of goals scored in descending order.
*/

SELECT 
	CONCAT(PL.Fname, ' ', PL.Lname) AS Name,
	PL.Country As 'Country',
	PAG.Goals As 'Goals Scored'
FROM 
	PLAYERS PL
INNER JOIN 
	PLAYER_ASSISTS_GOALS PAG
ON
	PL.Player_id = PAG.Player_id 
WHERE
	PAG.Goals > 0
ORDER BY
	PAG.Goals DESC;

/*
15)	Repeat 14. But only for the players who have more than 2 goals.
*/

SELECT 
	CONCAT(PL.Fname, ' ', PL.Lname) AS Name,
	PL.Country As 'Country',
	PAG.Goals As 'Goals Scored'
FROM 
	PLAYERS PL
INNER JOIN 
	PLAYER_ASSISTS_GOALS PAG
ON
	PL.Player_id = PAG.Player_id 
WHERE
	PAG.Goals > 2
ORDER BY
	PAG.Goals DESC;

/*
16)	Make a list of participating countries and their population, ordered in descending order of population.
*/

SELECT
	Country_Name, 
	Population 
FROM 
	COUNTRY 
ORDER BY 
	Population DESC;

/* --------------------------------------------------------- */
/*
4. Execute 3 more Insert commands that attempt to insert 3 more records, such that the records violate the integrity constraints. Make each of the 3 records violate a different type of integrity constraint. Capture your commands in spool files for turning in.
*/

/* Key Constraint Violation */
INSERT INTO COUNTRY(Country_Name, Population, No_of_Worldcup_won, Manager)
VALUES ('USA', 318.90, 0, 'Jurgen Klinsmann');

/* Entity Integrity Constraint Violation */
INSERT INTO PLAYERS(Player_id, Name, Fname, Lname, DOB, Country, Height, Club, Position, Caps_for_Country, IS_CAPTAIN)
VALUES (null, 'Alex Ferro', 'Alex', 'Ferro', '1994-10-24', 'England', 175, 'Chelsea', 'Forward', 94, 0);

/* Referential Integrity Constraint Violation */
INSERT INTO PLAYER_ASSISTS_GOALS(Player_id, No_of_Matches, Goals, Assists, Minutes_Played)
VALUES(100, 2,  2, 2, 180);

/*
5. Execute a sql command to Delete a record that violates a referential integrity constraint. Capture your command in a spool file for turning in.
*/

/* Referential Integrity Constraint Violation */
DELETE FROM COUNTRY WHERE Country_Name = 'England';

/*
6. Repeat 5 but Insert three new records that do not violate any integrity constraints. 
Capture your commands in spool files for turning in
*/

/* Inserting new record in COUNTRY Table */
INSERT INTO COUNTRY(Country_Name, Population, No_of_Worldcup_won, Manager)
VALUES ('India', 1326.10, 0, 'Igor Stimac');

/* Inserting new record in PLAYERS Table */
INSERT INTO PLAYERS(Player_id, Name, Fname, Lname, DOB, Country, Height, Club, Position, Caps_for_Country, IS_CAPTAIN)
VALUES (3201, 'Sunil Chhetri', 'Sunil', 'Chhetri', '1984-08-03', 'India', 170, 'Bengaluru FC', 'Forward', 125, 0);

/* Inserting new record in PLAYER_ASSISTS_GOALS Table */
INSERT INTO PLAYER_ASSISTS_GOALS(Player_id, No_of_Matches, Goals, Assists, Minutes_Played)
VALUES(3201, 5,  3, 1, 490);

/* Trying to delete above Country and Player records now and violating Referential Integrity Constraint */
DELETE FROM COUNTRY WHERE Country_Name = 'India';
DELETE FROM PLAYERS WHERE Player_id = 3201;

/* Deleting above records now without violating any constraint */
DELETE FROM PLAYER_ASSISTS_GOALS WHERE Player_id = 3201;
DELETE FROM PLAYERS WHERE Player_id = 3201;
DELETE FROM COUNTRY WHERE Country_Name = 'India';




