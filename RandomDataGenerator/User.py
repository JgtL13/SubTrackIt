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
    User_ID = i
    User_name = fake.first_name()

    # Insert data into database
    query = "INSERT INTO User (User_ID, User_name) VALUES (%s, %s)"
    values = (User_ID, User_name)
    cursor.execute(query, values)

# Commit changes and close connection
conn.commit()
conn.close()