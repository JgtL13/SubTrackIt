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
for _ in range(1000):  # Generate 1000 records
    Provider = fake.company()
    Plan_name = fake.text(max_nb_chars=10)
    Subscription_type = 'standard'
    Monthly_fee = fake.pyfloat(right_digits=2, positive=True, max_value=200)
    Duration_value = 1
    Duration_unit = 'month'

    # Insert data into database
    query = "INSERT INTO Plan (Provider, Plan_name, Subscription_type, Monthly_fee, Duration_value, Duration_unit) VALUES (%s, %s, %s, %s, %s, %s)"
    values = (Provider, Plan_name, Subscription_type, Monthly_fee, Duration_value, Duration_unit)
    cursor.execute(query, values)

# Commit changes and close connection
conn.commit()
conn.close()