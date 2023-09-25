# Data Download and Email Send Automation
## Overview
This project consists of two automation scripts: one for downloading data from a website and another for sending customized emails to a list of recipients. These scripts streamline repetitive tasks and save time by automating data retrieval and email communication.

## Data Download Automation
Description
The Data Download Automation script automates the process of downloading images, titles, links, and company descriptions from a specific website.

### Usage
1. Ensure you have the necessary modules installed (e.g., Selenium, requests, pandas, tqdm).
2. Modify the script's configuration, including the website URL and file paths.
3. Run the script to download the data.
4. The downloaded data is stored in CSV format (Output_list.csv) for further analysis or usage.

## Email Send Automation
### Description
The Email Send Automation script automates the process of sending customized emails to a list of recipients. It reads recipient information and email content from CSV and text files, respectively, and sends personalized emails.

### Usage
1. Ensure you have the necessary modules installed (e.g., smtplib, email.mime).
2. Update the script with your email credentials (username and password) and configure the email subject and content.
3. Create a CSV file (mail_list.csv) containing recipient information (name, company, email address).
4. Create an email template in a text file (mail.txt) with placeholders for recipient-specific data (e.g., +++person+++ and +++company_name+++).
5. Run the script to send personalized emails to the recipients in the CSV file.
6. Check the recipients' inboxes for the sent emails.

## Requirements
- Python 3.x
- Relevant Python libraries (see script comments for details)
- Google Chrome (for the Data Download Automation script)
## Project Structure
Copy code
Project/
│
├── Data_Download_Automation/
│   ├── data_download.py
│   └── chromedriver.exe
│
├── Email_Send_Automation/
│   ├── email_send.py
│   ├── mail_list.csv
│   ├── mail.txt
│   └── Your_folder/
│
└── README.md
## Notes
- Ensure that you have the appropriate web drivers for Selenium (e.g., chromedriver.exe) in the respective project directories.
- Customize the scripts, email templates, and configurations to meet your specific needs.
- Be cautious when handling email credentials and sensitive data.
