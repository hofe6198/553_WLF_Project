library(RSQLite)
library(readr)


db <- dbConnect(SQLite(), dbname = "finalproject-db.sqlite")


dbExecute(db, "
  DROP TABLE IF EXISTS Site;
  DROP TABLE IF EXISTS FishObs;
  DROP TABLE IF EXISTS SampleEvent;
  DROP TABLE IF EXISTS Survey;
  DROP TABLE IF EXISTS FishIndv;

  CREATE TABLE Site (
    siteID INTEGER PRIMARY KEY,
    decDegLat1 REAL,
    decDegLon1 REAL,
    streamName VARCHAR(50),
    streamNameType VARCHAR(10)
  );

  CREATE TABLE Survey (
    surveyID INTEGER PRIMARY KEY,
    siteID INTEGER,
    surveyDate DATE,
    observer1 VARCHAR(40),
    precipitation REAL,
    PH REAL,
    DO REAL,
    NTU REAL,
    tempWater REAL,
    FOREIGN KEY (siteID) REFERENCES Site(SiteID)
  );

  CREATE TABLE SampleEvent (
    sampleEventID INTEGER PRIMARY KEY,
    surveyID INTEGER,
    sampleGear VARCHAR(50),
    trapCount INTEGER,
    FOREIGN KEY (surveyID) REFERENCES Survey(surveyID)
  );

  CREATE TABLE FishObs (
    FishObsID INTEGER PRIMARY KEY,
    surveyID INTEGER,
    species TEXT,
    lifeStage TEXT,
    suspectSpawn BOOLEAN,
    FOREIGN KEY (surveyID) REFERENCES Survey(surveyID)
  );

  CREATE TABLE FishIndv (
    fishIndividualID INTEGER PRIMARY KEY,
    fishObservationID INTEGER,
    length REAL,
    lengthType VARCHAR(20),
    sex VARCHAR(10),
    FOREIGN KEY (fishObservationID) REFERENCES FishObs(FishObsID)
  );
")

setwd("C:/Users/jhofe/OneDrive/Desktop/Jacob_School_UI/553_WLF/553_WLF_Project/Processed_Data")
site_data <- read_csv("SITE1.csv")
dbWriteTable(db, "Site", site_data, append = TRUE, row.names = FALSE)

survey_data <- read_csv("SURVEY1.csv")
dbWriteTable(db, "Survey", survey_data, append = TRUE, row.names = FALSE)

sample_event_data <- read_csv("SAMPLE1.csv")
dbWriteTable(db, "SampleEvent", sample_event_data, append = TRUE, row.names = FALSE)

fish_obs_data <- read_csv("FISHOB1.csv")
fish_obs_data$suspectSpawn <- as.integer(fish_obs_data$suspectSpawn)
dbWriteTable(db, "FishObs", fish_obs_data, append = TRUE, row.names = FALSE)

fish_indv_data <- read_csv("FISHINV1.csv")
dbWriteTable(db, "FishIndv", fish_indv_data, append = TRUE, row.names = FALSE)


dbDisconnect(db)
