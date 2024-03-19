<?php

class DbOperation
{
    private $conn;

    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Constants.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    public function getProviders() {
        $stmt = $this->conn->prepare("
            SELECT DISTINCT Provider 
            FROM Plan
            ORDER BY Provider;
        ");
        $stmt -> execute();
        // Fetch all rows from the result set as associative arrays
        $providers = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        return $providers;
    }


    // CONCAT(Duration_value, ' ', Duration_unit) AS Duration
    public function getPlans($provider) {
        $stmt = $this->conn->prepare("
            SELECT DISTINCT 
                Plan_ID,
                Plan_name,
                Duration_value,
                Duration_unit
            FROM 
                Plan
            WHERE 
                Provider = ?
            ORDER BY
                Plan_name,
                Duration_unit,
                Duration_value;
        ");
        $stmt->bind_param("s", $provider);
        $stmt -> execute();
        // Fetch all rows from the result set as associative arrays
        $plans = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        return $plans;
    }

    public function getSubscriptions($id, $threshold) {
        $stmt = $this->conn->prepare("
            SELECT DISTINCT 
                p.Provider, 
                p.Plan_name,
                p.Subscription_type,
                s.Subscription_ID,
                s.Free_trial,
                s.Start_date, 
                s.End_date,
                DATEDIFF(s.End_date, CURDATE()) AS Remaining
            FROM 
                Subscription s 
                JOIN Plan p ON s.Plan_ID = p.Plan_ID 
            WHERE 
                s.User_ID = ?
                AND (DATEDIFF(s.End_date, CURDATE()) <= ? OR ? < 0)
            ORDER BY
                Remaining;
        ");
        // Bind the id parameter to the placeholder
        $stmt->bind_param("sii", $id, $threshold, $threshold);
        $stmt -> execute();
        $subscriptions = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        return $subscriptions;
    }

    public function newSubscription($startDate, $freeTrial, $userID, $planID) {
        $stmt = $this->conn->prepare("
            INSERT INTO Subscription (Start_date, Free_trial, User_ID, Plan_ID)
            VALUES (?, ?, ?, ?)
        ");
        $stmt->bind_param("sssi", $startDate, $freeTrial, $userID, $planID);
        $stmt->execute();
    
        // Check if the insertion was successful
        if ($stmt->affected_rows > 0) {
            // Return success message or ID of the newly inserted row
            return "Subscription added successfully";
        } else {
            // Return error message or handle the case where insertion failed
            return "Failed to add subscription";
        }
    }

    public function deleteSubscription($subscriptionID) {
        $stmt = $this->conn->prepare("
            DELETE FROM Subscription
            WHERE Subscription_ID = ?
        ");
        $stmt->bind_param("i", $subscriptionID);
        $stmt->execute();
    
        // Check if the insertion was successful
        if ($stmt->affected_rows > 0) {
            // Return success message or ID of the newly inserted row
            return "Subscription deleted successfully";
        } else {
            // Return error message or handle the case where insertion failed
            return "Failed to delete subscription";
        }
    }

    public function renewSubscription($subscriptionID) {
        // Fetch End_date and Free_trial
        $stmt = $this->conn->prepare("
            SELECT End_date, Free_trial
            FROM Subscription
            WHERE Subscription_ID = ?
        ");
        $stmt->bind_param("i", $subscriptionID);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $endDate = $row['End_date'];
        $freeTrial = $row['Free_trial'];
    
        // Update Start_date to be the same as End_date
        $stmt = $this->conn->prepare("
            UPDATE Subscription
            SET Start_date = ?
            WHERE Subscription_ID = ?
        ");
        $stmt->bind_param("si", $endDate, $subscriptionID);
        $stmt->execute();
    
        // Update Free_trial if it is 1
        if ($freeTrial == 1) {
            $stmt = $this->conn->prepare("
                UPDATE Subscription
                SET Free_trial = 0
                WHERE Subscription_ID = ?
            ");
            $stmt->bind_param("i", $subscriptionID);
            $stmt->execute();
        }
    
        // Check if the update was successful
        if ($stmt->affected_rows > 0) {
            // Return success message
            return "Start date updated successfully";
        } else {
            // Return error message or handle the case where update failed
            return "Failed to update start date";
        }
    }

    public function createUser($userID, $deviceToken) {
        $stmt = $this->conn->prepare("
            INSERT INTO User (User_ID, Device_token)
            VALUES (?, ?)
        ");
        $stmt->bind_param("ss", $userID, $deviceToken);
        $stmt->execute();
    
        // Check if the insertion was successful
        if ($stmt->affected_rows > 0) {
            // Return success message or ID of the newly inserted row
            return "User created successfully";
        } else {
            // Return error message or handle the case where insertion failed
            return "Failed to create user";
        }
    }
    
    public function getUsername($userID) {
        $stmt = $this->conn->prepare("
            SELECT u.User_name
            FROM User u
            JOIN Account a ON u.User_ID = a.User_ID
            WHERE a.User_ID = ?;
        ");
        $stmt->bind_param("s", $userID);
        $stmt -> execute();
        // Fetch all rows from the result set as associative arrays
        $userName = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        return $userName;
    }

    public function syncData($username, $email, $password, $userID, $requestMethod) {
        if ($requestMethod === 'GET') {
                $stmt = $this->conn->prepare("
                SELECT User_ID
                FROM Account
                WHERE Email = ? AND Password = ?
            ");
            $stmt->bind_param("ss", $email, $password);
            $stmt->execute();
            $user_ID = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
            return $user_ID;
        
        } elseif ($requestMethod === 'POST') {
            $stmt = $this->conn->prepare("
                INSERT INTO Account (Email, Password, User_ID)
                VALUES (?, ?, ?)
            ");
            $stmt->bind_param("sss", $email, $password, $userID);
            $stmt->execute();
    
            if ($stmt->affected_rows > 0) {
                // User created successfully, retrieve the newly generated userID
                return "Account created successfully";
            } else {
                // Failed to create user
                return "Failed to create account";
            }
        } elseif ($requestMethod === 'PUT') {
            $stmt = $this->conn->prepare("
                Update User
                SET User_name = ?
                WHERE User_ID = ?
            ");
            $stmt->bind_param("ss", $username, $userID);
            $stmt->execute();
    
            if ($stmt->affected_rows > 0) {
                // User created successfully, retrieve the newly generated userID
                return "Username updated successfully";
            } else {
                // Failed to create user
                return "Failed to update username";
            }
        }
            
    }

    public function notificationSetup($userID, $deviceToken, $requestMethod) {
        if ($requestMethod === 'GET') {
                $stmt = $this->conn->prepare("
                SELECT Device_token
                FROM User
                WHERE User_ID = ?
            ");
            $stmt->bind_param("s", $userID);
            $stmt->execute();
            $deviceToken = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
            return $deviceToken;
        
        } elseif ($requestMethod === 'PUT') {
            $stmt = $this->conn->prepare("
                Update User
                SET Device_token = ?
                WHERE User_ID = ?
            ");
            $stmt->bind_param("ss", $deviceToken, $userID);
            $stmt->execute();
    
            if ($stmt->affected_rows > 0) {
                // User created successfully, retrieve the newly generated userID
                return "Username updated successfully";
            } else {
                // Failed to create user
                return "Failed to update username";
            }
        }
            
    }
}