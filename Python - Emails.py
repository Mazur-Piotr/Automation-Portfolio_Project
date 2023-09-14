# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 12:34:35 2023

@author: homa1003
"""

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os
import pandas as pd

os.chdir(r'C:\Users\your_path\Your_folder')
path = os.getcwd()

# Login credentials 
mail_username = 'your_email@gmail.com'  
mail_password = 'Password'

# Read the recipient list from a CSV file
mail_list = pd.read_csv('mail_list.csv')
person_list = mail_list['Name']
company_list = mail_list['company']
mail_address = mail_list['email']

# Read the email body from the 'mail.txt' file
with open('mail.txt', 'r') as file:
    email_body1 = file.read()

# Create a list of recipient email addresses
email_recipients = list(mail_list['email'])

    
# Function to send emails
def send_email(subject, message, recipient_email):
    username = mail_username
    __password = mail_password
    mail_from =  mail_username
    mail_to = recipient_email
    mail_subject = subject
    html_body = message
    
    # Create an MIMEMultipart object
    mimemsg = MIMEMultipart()
    mimemsg['From'] = mail_from
    mimemsg['To'] = mail_to
    mimemsg['Subject'] = mail_subject
    mimemsg.attach(MIMEText(html_body, 'html'))
    
    # Connect to the Gmail SMTP server
    connection = smtplib.SMTP(host='smtp.gmail.com', port=587)
    connection.starttls()
    connection.login(username,__password)
    # Send the email message
    connection.send_message(mimemsg)
    connection.quit()


# Loop to send emails to all recipients
for i in range(len(email_recipients)):
    person = person_list[i]
    company = company_list[i]
    email_body = email_body1.replace('+++person+++', person).replace('+++company_name+++', company)
    recipient_email = email_recipients[i]
    subject = 'Your Subject'  # Zaktualizuj temat według potrzeb
    send_email(subject, email_body, recipient_email)
