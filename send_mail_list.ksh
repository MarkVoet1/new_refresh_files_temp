#!/bin/ksh

send_email() {
    sender_display_name="Korn sehll refresh organisator"
    sender_email="mark.voet@proximus.com"
    recipient_email="mark.voet@proximus.com"
    subject="this is a test mail using the sendmail command"
    body=$(cat /home/oracle/mark/mark.txt)
    attachment_path="/home/oracle/mark/mark.attach"
    attachment_name="mark.attach"

    # Create the email headers and body
    email_content="From: \"$sender_display_name\" <$sender_email>
To: $recipient_email
Subject: $subject
Date: $(date -R)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=\"boundary1\"

--boundary1
Content-Type: text/plain; charset=\"US-ASCII\"
Content-Transfer-Encoding: 7bit

$body

--boundary1
Content-Type: application/octet-stream; name=\"$attachment_name\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$attachment_name\"

$(base64 $attachment_path)
--boundary1--"

    # Send the email using sendmail
    echo "$email_content" | sendmail -t

    # Check the status code
    status_code=$?

    if [ $status_code -eq 0 ]; then
        echo "Email sent successfully!"
    else
        echo "Failed to send email with status code: $status_code"
    fi
}

# Predefined list separated by semicolons
list="mark.voet@proximus.be;mark.voet@proximus.be;mark.voet@proximus.be;mark.voet@proximus.be"

# Convert the list into an array
IFS=';' read -r -A array <<< "$list"

# Iterate over each member of the array
for item in "${array[@]}"; do
    # Perform an action with each member
    send_email "$item"
done
