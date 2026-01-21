-- example.sql: Basic schema for tracking delivered data files

CREATE TABLE IF NOT EXISTS data_delivery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    region VARCHAR(50) NOT NULL,
    delivery_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('SUCCESS', 'FAILOVER', 'ERROR') DEFAULT 'SUCCESS',
    user_id INT
);

-- Insert example data
INSERT INTO data_delivery (file_name, region, user_id) VALUES 
('report.pdf', 'us-east-1', 1),
('image.jpg', 'us-west-2', 2);

-- Query example
SELECT * FROM data_delivery WHERE status = 'SUCCESS';