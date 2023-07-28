library(shiny)
library(rsconnect)
library(tidyverse)
library(DT)
library(shinythemes)
# Define UI with conditional Panel
ui <- fluidPage(theme = shinytheme(theme = 'cerulean'),
    titlePanel("Cleaning Data"),
    sidebarLayout(
        sidebarPanel(width = 5,
            fileInput(inputId = 'uploaded_data',label = 'Upload Your CSV',
                      accept = '.csv',multiple = F
            ),
            fluidRow(
                column(6,
                       checkboxInput("header", "Does the uploaded file have headers", value = TRUE)),
                column(6,
                       actionButton("reset", "Reset & Reupload")), 
                ),
            numericInput(inputId = 'Column_No',label = 'Which Column to edit',
                         value = 1,min = 1,max = Inf,step = 1
                ),
            h4('Split columns on specific delimiters'),
            fluidRow(
                column(6,
                       numericInput(inputId = 'no.of.cols',label = 'No. of colums to divide into',
                                    value = 2,min = 2,max = Inf,step = 1)),
                column(6,
                       textInput(inputId = 'Delimiter',label = 'Delimiter to use to divide')),
            ),
            actionButton("action", "Divide"),
            br(),
            h4('Substitution of a specific variable in your column'),
            fluidRow(
                column(6,
                       textInput(inputId = 'variable_sub',label = 'Which variable to substitute')),
                column(6,
                       textInput(inputId = 'variable_replace',label = 'Which variable to replace by')),
            ),
            checkboxInput("Fixed", "Use the given variable substitution as a regex", value = TRUE),
            actionButton("action2", "Substitute"),
            br(),
            radioButtons("choice",h4("Changing Variable Type of the selected column"),
                               choices = list("Factor" = 1,"Numeric" = 2,"Character" = 3),
                               selected = 1),
            actionButton("action3", "Change Type"),
            br(),
            br(),
            downloadButton('download',label = 'Download Cleaned file')
        ),
        mainPanel(width = 7,
                  tabsetPanel(
                      tabPanel(title = 'Output',
                               br(),
                               DT::dataTableOutput('contents'),),
                      tabPanel(title = 'Instructions',
                               br(),
                               br(),
                               p("Welcome to the Data Cleaning Made Easy Shiny App! This documentation will guide you on how to use the app effectively to streamline your data cleaning process. Whether you're a data analyst, researcher, or just someone working with data, this app will make your data cleaning tasks a breeze."),
                               br(),
                               h4('Uploading Your Data'),
                               HTML("When you open the app, you'll see a user-friendly interface that allows you to upload your CSV file. Click on the 'Browse...' button and select the CSV file you want to clean. If your file has headers, check the 'Does the uploaded file have headers' checkbox; otherwise, leave it unchecked."),
                               h4('Split Columns on Specific Delimiters'),
                               HTML(paste0("If you have a column with multiple values separated by a specific delimiter (e.g., comma, semicolon), you can split it into separate columns. Here's how you can do it:",br(),
                                 "1. Specify the column number you want to edit (e.g., 1 for the first column).",br(),
                                 "2. Enter the number of columns you want to divide the data into (e.g., 2 for splitting into two columns).",br(),
                                 "3. Provide the delimiter to use for splitting (e.g., ',' for comma-separated values).",br(),
                                 "4. Click the 'Divide' button to apply the split.")),
                               h4('Substitution of a Specific Variable in Your Column'),
                               HTML(paste0("If you need to replace specific values in a column, you can use the substitution function. Here's how:",br(),
                                        "1. Enter the variable you want to substitute (e.g., 'old_value').",br(),
                                        "2. Provide the new variable you want to replace it with (e.g., 'new_value').",br(),
                                        "3. Optionally, check the 'Use the given variable substitution as a regex' box if you want to use regular expressions for substitution.",br(),
                                        "4. Click the 'Substitute' button to apply the changes.")),
                               h4('Changing Variable Type of the Selected Column'),
                               HTML(paste0("Sometimes, you may need to change the data type of a column, such as converting it to a factor, numeric, or character. Here's how:",br(),
                                        "1. Select the desired data type from the available options: Factor, Numeric, or Character.",br(),
                                        "2. Click the 'Change Type' button to apply the conversion.")),
                               h4(' Downloading Cleaned Data'),
                               p('Once you have completed the desired data cleaning operations, you can download the cleaned data as a new CSV file. Click the "Download Cleaned File" button, and a CSV file will be saved to your local machine.')
                               )
        ))
    )
)
# Define server logic that generates a random number based on user input
server <- function(input, output,session) {
    edit <- reactiveValues(df_data = NULL)
    observeEvent(input$uploaded_data,{
        file <- input$uploaded_data
        ext <- tools::file_ext(file$datapath)
        req(file)
        validate(need(ext == "csv", "Please upload a csv file"))
        edit$df_data <- read.csv(file$datapath, header = input$header)
    })
    
    #orignal dataset
    observeEvent(input$action ,{
        x <- str_split(string = edit$df_data[,input$Column_No],
                       pattern = as.character(input$Delimiter),
                       n = input$no.of.cols)
        x <- lapply(x, function(x){x[1]})
        edit$df_data[,input$Column_No] <- unlist(x)
        data.orignal <- edit$df_data
    })
    observeEvent(input$action2 ,{
        if (input$Fixed==T) {
            x <- str_replace_all(edit$df_data[,input$Column_No],pattern = regex(input$variable_sub),
                                 replacement = input$variable_replace)
        }
        else {x <- str_replace_all(edit$df_data[,input$Column_No],pattern = fixed(input$variable_sub),
                                   replacement = input$variable_replace)}
        edit$df_data[,input$Column_No] <- unlist(x)
    })
    observeEvent(input$action3 ,{
        if (input$choice=='Factor') {
            edit$df_data[,input$Column_No] <- as.factor(edit$df_data[,input$Column_No])
        }
        else if (input$choice=='Numeric') {
            edit$df_data[,input$Column_No] <- as.numeric(edit$df_data[,input$Column_No])
        }
        else {
            edit$df_data[,input$Column_No] <- as.character(edit$df_data[,input$Column_No])
        }
    })
    observeEvent(input$reset, {
        session$reload()
    })
    output$contents <- DT::renderDataTable(edit$df_data)
    output$download <- downloadHandler(
        filename = function() {
            paste("data-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(edit$df_data, file)
        }
    )
}

shinyApp(ui = ui, server = server)