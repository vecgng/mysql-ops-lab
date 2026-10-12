CREATE DATABASE IF NOT EXISTS ops_lab;

USE ops_lab;

CREATE TABLE IF NOT EXISTS servers (
    id INT PRIMARY KEY,
    hostname VARCHAR(50),
    ip_address VARCHAR(45),
    status VARCHAR(20)
);

INSERT INTO servers (id, hostname, ip_address, status)
VALUES
(1, 'web-server', '192.168.32.128', 'running'),
(2, 'db-server', '192.168.32.129', 'running'),
(3, 'backup-server', '192.168.32.130', 'stopped');
