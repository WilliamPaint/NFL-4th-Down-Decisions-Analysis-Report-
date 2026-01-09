/* Step 1: Import the CSV dataset from the given path */
PROC IMPORT DATAFILE="/home/u64128359/DSCI_507/PG2/data/play_by_play_2024.csv"  /* Specify file path */
    OUT=work.play_by_play_2024    /* Name the output table */
    DBMS=CSV                      /* Input format is CSV */
    REPLACE;                     /* Replace existing table if it exists */
    GETNAMES=YES;                /* Use column names from the first row */
RUN;


/* Step 2: Filter for 4th down plays and create a binary decision variable */
DATA work.fourth_down_model;                       /* Create a new dataset */
    SET work.play_by_play_2024;                    /* Load the original data */
    WHERE down = 4;                                /* Keep only 4th down plays */

    IF play_type IN ('run', 'pass') THEN           /* If team chose to run or pass */
        go_for_it = 1;                             /* Set go_for_it = 1 (went for it) */
    ELSE IF play_type IN ('punt', 'field_goal') THEN
        go_for_it = 0;                             /* Set go_for_it = 0 (kick) */
    ELSE
        go_for_it = .;                             /* Otherwise set to missing */
RUN; 

/* Step 3: Check Information about the Dataset*/
PROC CONTENTS DATA=work.fourth_down_model;  /* display metadata information about the dataset*/
RUN;


/* Step 4: Get frequency counts of play types, quarter, and decision */
PROC FREQ DATA=work.fourth_down_model;             /* Run frequency analysis */
    TABLES play_type qtr go_for_it;                /* Analyze these variables */
RUN;


/* Step 5: Check relationship between quarter and decision using Chi-Square */
PROC FREQ DATA=work.fourth_down_model;             /* Run cross-tabulation */
    TABLES qtr*go_for_it / CHISQ MEASURES;         /* Include Chi-Square and Cramer's V */
RUN;


/* Step 6: Create a new variable for game half (early vs. late) */
DATA work.odds_half;                               /* New dataset for half classification */
    SET work.fourth_down_model;                    /* Use 4th down data */
    IF qtr IN (1, 2) THEN                          /* If quarter is 1 or 2 */
        half = 'Early';                            /* Label it Early */
    ELSE IF qtr IN (3, 4) THEN                     /* If quarter is 3 or 4 */
        half = 'Late';                             /* Label it Late */
RUN;


/* Step 7: Compare go-for-it decisions between Early and Late game halves */
PROC FREQ DATA=work.odds_half;                     /* Frequency test for half vs decision */
    TABLES half*go_for_it / RELRISK;               /* Include odds ratio and relative risk */
RUN;


/* Step 8: Build a logistic regression model to predict go_for_it decision */
PROC LOGISTIC DATA=work.fourth_down_model;   /* Run logistic regression */;
    CLASS qtr / PARAM=REF;                         /* Treat qtr as categorical; Q1 as reference */
    MODEL go_for_it(event='1') =                   /* Model the probability of going for it */
        qtr                                         /* Game quarter */
        game_secs_remaining                         /* Time remaining in game */
        ydstogo                                     /* Yards to go for first down */
        yardline_100                                /* Distance from opponent’s goal line */
        score_differential                          /* Current score difference */
        / SELECTION=STEPWISE;                       /* Use stepwise selection for best model */
RUN;


/* Step 9: Create bar chart for play type frequency */
PROC FREQ DATA=work.fourth_down_model NOPRINT;     /* Frequency of play_type without printing output */
    TABLES play_type / OUT=play_type_freq;          /* Output table with frequency counts */
RUN;

PROC SGPLOT DATA=play_type_freq;                   /* Create a bar chart using SGPLOT */
    VBAR play_type / RESPONSE=COUNT DATALABEL;     /* Vertical bars, show counts and labels */
    TITLE "Play Type Frequency on 4th Down";        /* Title of the chart */
    YAXIS LABEL="Frequency";                        /* Y-axis label */
    XAXIS LABEL="Play Type";                        /* X-axis label */
RUN;


/* Step 10: Create bar chart for go-for-it rate by quarter */
PROC FREQ DATA=work.fourth_down_model NOPRINT;     /* Frequency table without output display */
    TABLES qtr*go_for_it / OUT=qtr_go_rate OUTPCT;  /* Output table with percentages by quarter */
RUN;

DATA qtr_go;                                       /* New dataset to keep go-for-it rows only */
    SET qtr_go_rate;                               /* Load the frequency table */
    WHERE go_for_it = 1;                           /* Keep only where team went for it */
RUN;

PROC SGPLOT DATA=qtr_go;                           /* Create bar chart for go-for-it rate by quarter */
    VBAR qtr / RESPONSE=pct_row DATALABEL;         /* Vertical bars, show percentage per row */
    TITLE "Go-for-It Rate by Quarter";             /* Chart title */
    YAXIS LABEL="Go-for-It Rate (%)" MAX=50;       /* Y-axis label and scale */
    XAXIS LABEL="Quarter";                         /* X-axis label */
RUN;


/* Step 11: Create bar chart for go-for-it rate: Early vs Late Game */
DATA fourth_down_model_half;                       /* New dataset to assign game halves */
    SET work.fourth_down_model;                    /* Use original 4th down model data */
    IF qtr IN (1, 2) THEN half = "Early";           /* Assign 'Early' to Q1 & Q2 */
    ELSE IF qtr IN (3, 4) THEN half = "Late";       /* Assign 'Late' to Q3 & Q4 */
RUN;

PROC FREQ DATA=fourth_down_model_half NOPRINT;     /* Create frequency table by half */
    TABLES half*go_for_it / OUT=half_go_rate OUTPCT; /* Output with percentages */
RUN;

DATA half_go;                                      /* New dataset for go-for-it rows only */
    SET half_go_rate;                              /* Use half vs decision table */
    WHERE go_for_it = 1;                           /* Keep go-for-it only */
RUN;

PROC SGPLOT DATA=half_go;                          /* Bar chart for go-for-it rate by half */
    VBAR half / RESPONSE=pct_row DATALABEL;        /* Show percent of go-for-it per half */
    TITLE "Go-for-It Rate: Early vs Late Game";    /* Chart title */
    YAXIS LABEL="Go-for-It Rate (%)" MAX=50;       /* Y-axis settings */
    XAXIS LABEL="Game Half";                       /* X-axis label */
RUN; 






