from faker import Faker
import mysql.connector

# Connect to MySQL database
conn = mysql.connector.connect(
    user="root",
    password="",
    host="127.0.0.1",
    database="test"
)
cursor = conn.cursor()

# Create Faker instance
fake = Faker()
Faker.seed(0)

# Generate and insert fake data into database
for i in range(11, 1001, 1):  # Generate 1000 records
    Email = fake.email()
    Password = fake.password()
    User_ID = i

    # Insert data into database
    query = "INSERT INTO Account (Email, Password, User_ID) VALUES (%s, %s, %s)"
    values = (User_ID, Password, User_ID)
    cursor.execute(query, values)

# Commit changes and close connection
conn.commit()
conn.close()