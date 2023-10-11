# Coursera-Developing-data-products
Welcome to the Data Cleaning Made Easy Shiny App! This documentation will guide you on how to use the app effectively to streamline your data cleaning process. Whether you're a data analyst, researcher, or just someone working with data, this app will make your data cleaning tasks a breeze.


Uploading Your Data
When you open the app, you'll see a user-friendly interface that allows you to upload your CSV file. Click on the 'Browse...' button and select the CSV file you want to clean. If your file has headers, check the 'Does the uploaded file have headers' checkbox; otherwise, leave it unchecked.
Split Columns on Specific Delimiters
If you have a column with multiple values separated by a specific delimiter (e.g., comma, semicolon), you can split it into separate columns. Here's how you can do it:
1. Specify the column number you want to edit (e.g., 1 for the first column).
2. Enter the number of columns you want to divide the data into (e.g., 2 for splitting into two columns).
3. Provide the delimiter to use for splitting (e.g., ',' for comma-separated values).
4. Click the 'Divide' button to apply the split.
Substitution of a Specific Variable in Your Column
If you need to replace specific values in a column, you can use the substitution function. Here's how:
1. Enter the variable you want to substitute (e.g., 'old_value').
2. Provide the new variable you want to replace it with (e.g., 'new_value').
3. Optionally, check the 'Use the given variable substitution as a regex' box if you want to use regular expressions for substitution.
4. Click the 'Substitute' button to apply the changes.
Changing Variable Type of the Selected Column
Sometimes, you may need to change the data type of a column, such as converting it to a factor, numeric, or character. Here's how:
1. Select the desired data type from the available options: Factor, Numeric, or Character.
2. Click the 'Change Type' button to apply the conversion.
Downloading Cleaned Data
Once you have completed the desired data cleaning operations, you can download the cleaned data as a new CSV file. Click the "Download Cleaned File" button, and a CSV file will be saved to your local machine.
