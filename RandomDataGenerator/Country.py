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
for _ in range(100):  # Generate 1000 records
    countryName = fake.country()

    # Insert data into database
    query = "INSERT INTO Country (Country_name) VALUES (%s)"
    values = (countryName, )
    cursor.execute(query, values)

# Commit changes and close connection
conn.commit()
conn.close()